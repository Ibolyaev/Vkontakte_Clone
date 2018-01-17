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
struct VKResponse<T:Decodable>:Decodable {
    let response:T
    
    /*init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        response = try values.decode(T.self, forKey: .response)
    }
    enum CodingKeys: String, CodingKey {
        case response
    }*/
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
            //URLQueryItem(name: "sdk_version", value:"5.69")
        ]
        
      return urlComponents.url!
        
    }
    
    static func getUser(userToken:String, completionHandler:@escaping  (_ user:User?, _ error:Error?)->()) {
        let parameters = ["access_token":userToken,
                      "fields":"photo_100"]
        Alamofire.request(VK.users, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData(queue:DispatchQueue.global(qos: .userInitiated)) {[userToken] (response) in
            
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
    
    func getGroupMembers(groupId:Int, completionHandler:@escaping (_ membersCount:Int,_ groupId:Int,_ error:Error?)->()) {
        let parameters = ["group_id":groupId] as [String : Any]
        getResourse(VK.groupMembers, parameters: parameters, type: GroupMembers.self) {(groupMembers, error) in
            if let groupMembers = groupMembers {
                completionHandler(groupMembers.count,groupId,nil)
            } else {
                completionHandler(0,groupId, error)
            }
        }
    }
    
    func getGroups(_ searchText:String,userToken:String, completionHandler:@escaping (_ groups:[Group]?,_ error:Error?)->() ) {
        let parameters = ["q":searchText]
        getResourse(VK.groupsSearch, parameters: parameters, type: [Group].self, completionHandler: completionHandler)
    }
    
    func getUserGroups(_ completionHandler:@escaping (_ groups:[Group]?,_ error:Error?)->() ) {
        let parameters = ["extended":"1"] as [String : Any]
        getResourse(VK.groups, parameters: parameters, type: [Group].self, completionHandler: completionHandler)
    }
    
    func getPhotos(ownerId:Int, completionHandler:@escaping (_ groups:[AlbumPhoto]?,_ error:Error?)->()) {
        let parameters = ["album_id":"profile",
                      "owner_id":ownerId] as [String : Any]
        getResourse(VK.photosURL, parameters: parameters, type: [AlbumPhoto].self, completionHandler: completionHandler)
    }
    
    func getUserNewsFeed(_ completionHandler:@escaping (_ response:NewsResponse?,_ error:Error?)->()) {
        
        let parameters = ["count":50] as [String : Any]
        getResourse(VK.newsFeed, parameters: parameters, type: NewsResponse.self, completionHandler: completionHandler)
    }
    private func getResourse<T:Decodable>(_ url:String , parameters:[String : Any], type:T.Type, completionHandler: @escaping (_ objects:T?,_ error:Error?)->() ) {
        guard let token = AppState.shared.token else {
            return // return error
        }
        var finalParameters = parameters
        if finalParameters["access_token"] == nil {
           finalParameters.updateValue(token, forKey: "access_token")
        }
        //finalParameters.updateValue("5.69", forKey: "version")
        Alamofire.request(url, method: .get, parameters: finalParameters, encoding: URLEncoding.default, headers: nil).responseData(queue:DispatchQueue.global(qos: .userInitiated)) {(response) in
            
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
    
    func getUserFriends(_ completionHandler: @escaping (_ friends:[User]?,_ error:Error?)->() ) {
        let parameters = [String:Any]()
        getResourse(VK.friends, parameters: parameters, type: [Int].self) {[weak self] (userIds, error) in
            
            if let userIds = userIds {
                self?.loadFriendsWithIds(userIds: userIds, completionHandler: completionHandler)
            } else {
                completionHandler(nil,error)
            }
        }
    }
    
    func loadFriendsWithIds(userIds:[Int], completionHandler: @escaping (_ friends:[User]?,_ error:Error?)->() ) {
        let parameters = ["user_ids":userIds,
                      "access_token":appToken,
                      "fields":["photo_100"]] as [String : Any]
        getResourse(VK.users, parameters: parameters, type: [User].self, completionHandler: completionHandler)
    }
}

