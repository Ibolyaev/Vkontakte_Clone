//
//  VkAPI.swift
//  MyApp
//
//  Created by Ronin on 31/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import Foundation
import Alamofire

struct GroupMembers:Codable {
    let count:Int
    let users: [Int]
}

struct Groups:Decodable {
    let count:Int
    let items: [Group]
}

struct NewsFeed: Decodable {
    let items: [News] 
    //let profiles: []
    //let groups: []
    enum CodingKeys: String, CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        items = try values.decode([News].self, forKey: .items)
    }
}

struct VKResponse<T:Decodable>:Decodable {
    let response:T
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        response = try values.decode(T.self, forKey: .response)
    }
    enum CodingKeys: String, CodingKey {
        case response
    }
}

struct VK {
    static let url = "https://api.vk.com"
    static let accessToken = "325f9bfb325f9bfb325f9bfb013200b9d33325f325f9bfb6bae006de8d253d3e2996849"
    static let appId = "6234664"
    static let authorize = "https://oauth.vk.com/authorize"
    static let users = "https://api.vk.com/method/users.get"
    static let friends = "https://api.vk.com/method/friends.get"
    static let groups = "https://api.vk.com/method/groups.get"
    static let groupsSearch = "https://api.vk.com/method/groups.search"
    static let groupMembers = "https://api.vk.com/method/groups.getMembers"
    static let photosURL = "https://api.vk.com/method/photos.get"
    static let newsFeed = "https://api.vk.com/method/newsfeed.get"
}

class VKontakteAPI {
    
    let appToken = VK.accessToken
    
    static func authRequest() -> URL {
        var urlComponents = URLComponents()
        urlComponents.host = "oauth.vk.com"
        urlComponents.scheme = "https"
        urlComponents.path = "/authorize"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "revoke", value:"1"),
            URLQueryItem(name: "response_type", value:"token"),
            URLQueryItem(name: "display", value:"mobile"),
            URLQueryItem(name: "scope", value:"email,offline,friends,wall"),
            URLQueryItem(name: "redirect_uri", value:"vk\(VK.appId)://authorize"),
            URLQueryItem(name: "client_id", value:VK.appId),
            URLQueryItem(name: "sdk_version", value:"1.4.6")
        ]
        
      return urlComponents.url!
        
    }
    
    static func getUser(userToken:String, completionHandler:@escaping  (_ user:User?, _ error:Error?)->()) {
        let params = ["access_token":userToken,
                      "fields":"photo_100"]
        Alamofire.request(VK.users, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData {[userToken] (response) in
            
            if response.result.isSuccess, let data = response.data {
                var result:VKResponse<[User]>?
                do {
                    result = try JSONDecoder().decode(VKResponse<[User]>.self, from: data)
                } catch let error {
                    completionHandler(nil, error)
                }
                if let users = result?.response {
                    AppState.shared.token = userToken
                    AppState.shared.userLoggedIn = true
                    completionHandler(users[0], nil)
                }
            } else {
                completionHandler(nil, response.result.error)
            }
        }
    }
    
    func getGroupMembers(groupId:Int, userToken:String, completionHandler:@escaping (_ membersCount:Int,_ groupId:Int,_ error:Error?)->()) {
        let params = ["group_id":groupId,
                      "access_token":userToken] as [String : Any]
        getVKResourse(VK.groupMembers, params: params, type: GroupMembers.self) {(groupMembers, error) in
            if let groupMembers = groupMembers {
                completionHandler(groupMembers.count,groupId,nil)
            } else {
                completionHandler(0,groupId, error)
            }
        }
    }
    
    func getGroups(_ searchText:String,userToken:String, completionHandler:@escaping (_ groups:[Group]?,_ error:Error?)->() ) {
        let params = ["q":searchText,
                      "access_token":userToken]
        getVKResourse(VK.groupsSearch, params: params, type: [Group].self, completionHandler: completionHandler)
    }
    
    func getUserGroups(_ userToken:String, completionHandler:@escaping (_ groups:[Group]?,_ error:Error?)->() ) {
        let params = ["access_token":userToken,"extended":"1"] as [String : Any]
        getVKResourse(VK.groups, params: params, type: [Group].self, completionHandler: completionHandler)
    }
    
    func getPhotos(_ userToken:String, ownerId:Int, completionHandler:@escaping (_ groups:[AlbumPhoto]?,_ error:Error?)->()) {
        let params = ["access_token":userToken,
                      "album_id":"profile",
                      "owner_id":ownerId] as [String : Any]
        getVKResourse(VK.photosURL, params: params, type: [AlbumPhoto].self, completionHandler: completionHandler)
    }
    
    func getUserNewsFeed(_ userToken:String, completionHandler:@escaping (_ groups:[News]?,_ error:Error?)->()) {
        
        let params = ["access_token":userToken,
                      "count":10] as [String : Any]
        Alamofire.request(VK.newsFeed, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData {(response) in
            
            if response.result.isSuccess, let data = response.data {
                /*let test = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                let response = test["response"] as! [String:Any]
                let items = response["items"] as! [Any]
                let element = items[0] as! [String:Any]
                let likes = element["likes"] as! [String:Any]
                //print(likes["count"])*/
            
                var result:NewsResource?
                do {
                    result = try JSONDecoder().decode(NewsResource.self, from: data)
                } catch let error {
                    completionHandler(nil, error)
                }
                if let objects = result?.response?.items {
                    completionHandler(objects, nil)
                }
                
            } else {
                completionHandler(nil, response.result.error)
            }
        }
    }
    private func getVKResourse<T:Decodable>(_ url:String , params:[String : Any], type:T.Type, completionHandler: @escaping (_ objects:T?,_ error:Error?)->() ) {
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData {(response) in
            
            if response.result.isSuccess, let data = response.data {
                var result:VKResponse<T>?
                do {
                    result = try JSONDecoder().decode(VKResponse<T>.self, from: data)
                } catch let error {
                    completionHandler(nil, error)
                }
                if let objects = result?.response {
                    completionHandler(objects, nil)
                }
                
            } else {
                completionHandler(nil, response.result.error)
            }
        }
    }
    
    func getUserFriends(userToken:String, completionHandler: @escaping (_ friends:[User]?,_ error:Error?)->() ) {
        let params = ["access_token":userToken] as [String:Any]
        getVKResourse(VK.friends, params: params, type: [Int].self) {[weak self] (userIds, error) in
            
            if let userIds = userIds {
                self?.loadFriendsWithIds(userIds: userIds, completionHandler: completionHandler)
            } else {
                completionHandler(nil,error)
            }
        }
    }
    
    func loadFriendsWithIds(userIds:[Int], completionHandler: @escaping (_ friends:[User]?,_ error:Error?)->() ) {
        let params = ["user_ids":userIds,
                      "access_token":appToken,
                      "fields":["photo_100"]] as [String : Any]
        getVKResourse(VK.users, params: params, type: [User].self, completionHandler: completionHandler)
    }
}

