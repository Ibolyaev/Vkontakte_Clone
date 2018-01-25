//
//  VkAPI.swift
//  MyApp
//
//  Created by Ronin on 31/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import Foundation
import Alamofire

struct VKResponse<T:Decodable>:Decodable {
    let response:T
}

struct UserFriendsResponse: Codable {
    let items:[Int]
    let count:Int
}

struct UserPhotosResponse: Codable {
    let items:[AlbumPhoto]
    let count:Int
}

struct UserGroupsResponse:Decodable {
    let count:Int
    let items: [Group]
}

class VKontakteAPI {
    
    let appToken = VKConstants.accessToken
    
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
            URLQueryItem(name: "redirect_uri", value:"vk\(VKConstants.appId)://authorize"),
            URLQueryItem(name: "client_id", value:VKConstants.appId)
        ]
        
      return urlComponents.url!
        
    }
    
    func getUser(userToken:String, completionHandler:@escaping  (_ user:[User]?, _ error:Error?)->()) {
        let parameters = ["fields":"photo_100"]
        VKontakteAPI().getResourse(VKConstants.users, parameters: parameters, type: [User].self, completionHandler: completionHandler)
    }
    
    func getGroupMembers(groupId:Int, completionHandler:@escaping (_ membersCount:Int,_ groupId:Int,_ error:Error?)->()) {
        let parameters = ["group_id":groupId] as [String : Any]
        getResourse(VKConstants.groupMembers, parameters: parameters, type: GroupMembers.self) {(groupMembers, error) in
            if let groupMembers = groupMembers {
                completionHandler(groupMembers.count,groupId,nil)
            } else {
                completionHandler(0,groupId, error)
            }
        }
    }
    
    func getGroups(_ searchText:String,userToken:String, completionHandler:@escaping (_ groups:[Group]?,_ error:Error?)->() ) {
        let parameters = ["q":searchText]
        getResourse(VKConstants.groupsSearch, parameters: parameters, type: UserGroupsResponse.self) {(response, error) in
            if let response = response {
                completionHandler(response.items,error)
            } else {
                completionHandler(nil,error)
            }
        }
    }
    
    func getUserGroups(_ completionHandler:@escaping (_ groups:[Group]?,_ error:Error?)->() ) {
        let parameters = ["extended":"1"] as [String : Any]
        getResourse(VKConstants.groups, parameters: parameters, type: UserGroupsResponse.self) {(response, error) in
            if let response = response {
                completionHandler(response.items,error)
            } else {
                completionHandler(nil,error)
            }
        }
    }
    
    func getPhotos(ownerId:Int, completionHandler:@escaping (_ groups:[AlbumPhoto]?,_ error:Error?)->()) {
        let parameters = ["album_id":"profile",
                      "owner_id":ownerId] as [String : Any]
        getResourse(VKConstants.photosURL, parameters: parameters, type: UserPhotosResponse.self) {(_ response, error) in
            if let response = response {
                completionHandler(response.items,error)
            } else {
                completionHandler(nil,error)
            }
        }
    }
    
    func getUserNewsFeed(_ completionHandler:@escaping (_ response:NewsResponse?,_ error:Error?)->()) {
        let parameters = ["count":50] as [String : Any]
        getResourse(VKConstants.newsFeed, parameters: parameters, type: NewsResponse.self, completionHandler: completionHandler)
    }
    private func getResourse<T:Decodable>(_ url:String , parameters:[String : Any], type:T.Type, completionHandler: @escaping (_ objects:T?,_ error:Error?)->() ) {
        guard let token = AppState.shared.token else {
            return // return error
        }
        var finalParameters = parameters
        if finalParameters["access_token"] == nil {
           finalParameters.updateValue(token, forKey: "access_token")
        }
        finalParameters.updateValue("5.69", forKey: "v")
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
        getResourse(VKConstants.friends, parameters: parameters, type: UserFriendsResponse.self) {(userIds, error) in
            if let userIds = userIds {
                VKontakteAPI().loadFriendsWithIds(userIds: userIds.items, completionHandler: completionHandler)
            } else {
                completionHandler(nil,error)
            }
        }
    }
    
    func loadFriendsWithIds(userIds:[Int], completionHandler: @escaping (_ friends:[User]?,_ error:Error?)->() ) {
        let parameters = ["user_ids":userIds,
                      "access_token":appToken,
                      "fields":["photo_100"]] as [String : Any]
        getResourse(VKConstants.users, parameters: parameters, type: [User].self, completionHandler: completionHandler)
    }
}

