//
//  VkAPI.swift
//  MyApp
//
//  Created by Ronin on 31/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct VK {
    static let url = "https://api.vk.com"
    static let accessToken = "325f9bfb325f9bfb325f9bfb013200b9d33325f325f9bfb6bae006de8d253d3e2996849"
    static let appId = "6234664"
    static let authorize = "https://oauth.vk.com/authorize"
    static let urlUsers = "https://api.vk.com/method/users.get"
    static let urlFriends = "https://api.vk.com/method/friends.get"
    static let urlPhotosAll = "https://api.vk.com/method/photos.getAll"
    static let urlGroups = "https://api.vk.com/method/groups.get"
    static let urlGroupsSearch = "https://api.vk.com/method/groups.search"
    static let urlGroupMembers = "https://api.vk.com/method/groups.getMembers"
}

class VKontakteAPI {
    let appToken = VK.accessToken
    let parameters = ["":""]
    
    static func authRequest() -> URL {
        var urlComponents = URLComponents()
        urlComponents.host = "oauth.vk.com"
        urlComponents.scheme = "https"
        urlComponents.path = "/authorize"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "revoke", value:"1"),
            URLQueryItem(name: "response_type", value:"token"),
            URLQueryItem(name: "display", value:"mobile"),
            URLQueryItem(name: "scope", value:"email,offline"),
            URLQueryItem(name: "redirect_uri", value:"vk\(VK.appId)://authorize"),
            URLQueryItem(name: "client_id", value:VK.appId),
            URLQueryItem(name: "sdk_version", value:"1.4.6")
        ]
        
      return urlComponents.url!
        
    }
    
    
    static func getUser(userToken:String, completionHandler:@escaping  (_ user:User?, _ error:Error?)->()) {
        let params = ["access_token":userToken, "fields":"photo_100"]
        
        Alamofire.request(VK.urlUsers, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON {[userToken] (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let json = JSON(value)
                    if let result = json.dictionary {
                        if let response = result["response"]?.array,
                            let userJSON = response[0].dictionary {
                            let name = userJSON["first_name"]?.stringValue ?? ""
                            let user = User(name: name, photoURL: userJSON["photo_100"]?.string, token: userToken)
                            AppState.shared.user = user
                            completionHandler(user, nil)
                        } else {
                            completionHandler(nil, response.result.error)
                        }
                    }
                }
            } else {
                completionHandler(nil, response.result.error)
            }
        }
    }
    
    func getGroupMembers(groupId:String, userToken:String, completionHandler:@escaping (_ membersCount:Int,_ groupId:String,_ error:Error?)->()) {
        let params = ["group_id":groupId,"access_token":userToken]
        
        Alamofire.request(VK.urlGroupMembers, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON {[groupId] (response) in
            
            if response.result.isSuccess {
                
                if let value = response.result.value {
                    let json = JSON(value)
                    if let result = json.dictionary {
                        if let response = result["response"]?.dictionary {
                            
                            if let membersCount = response["count"]?.int {
                                completionHandler(membersCount,groupId,nil)
                            }
                        }
                    }
                }
            
        } else {
            completionHandler(0, groupId, response.result.error)
        }
    }
    }
    
    func getGroups(_ searchText:String,userToken:String, completionHandler:@escaping (_ groups:[Group]?,_ error:Error?)->() ) {
        
        let params = ["q":searchText,"access_token":userToken]
        
        Alamofire.request(VK.urlGroupsSearch, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON {(response) in
            
            if response.result.isSuccess {
                var groups = [Group]()
                if let value = response.result.value {
                    let json = JSON(value)
                    if let result = json.dictionary {
                        if let users = result["response"]?.array {
                            for jsonGroup in users {
                                groups.append(Group(json:jsonGroup))
                            }
                            completionHandler(groups,nil)
                        }
                    }
                }
                
            } else {
                completionHandler(nil,response.result.error)
            }            
        }
        
    }
    
    func getUserGroups(_ userToken:String, completionHandler:@escaping (_ groups:[Group]?,_ error:Error?)->() ) {
        let params = ["access_token":userToken,"extended":"1"] as [String : Any]
        
        Alamofire.request(VK.urlGroups, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON {(response) in
            
            if response.result.isSuccess {
                var groups = [Group]()
                if let value = response.result.value {
                    let json = JSON(value)
                    if let result = json.dictionary {
                        if let users = result["response"]?.array {
                            for jsonGroup in users {
                                groups.append(Group(json:jsonGroup))
                            }
                            completionHandler(groups,nil)
                        }
                    }
                }
                
            } else {
                completionHandler(nil,response.result.error)
            }
            
        }
    }
    
    func getUserFriends(userId:String, completionHandler: @escaping (_ friends:[Friend]?,_ error:Error?)->() ) {
        
        let params = ["user_id":userId,"access_token":appToken]
        
        Alamofire.request(VK.urlFriends, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON {[weak self] (response) in
            
            if response.result.isSuccess {
                
                if let value = response.result.value {
                    let json = JSON(value)
                    if let result = json.dictionary {
                        if let responseResult = result["response"]?.array {
                            let usersIds = responseResult.flatMap({ (json) -> String? in
                                json.stringValue
                            })
                            self?.loadFriendsWithIds(userIds: usersIds, completionHandler: { (friends, error) in
                                completionHandler(friends, error)
                            })
                        }
                    }
                }
                
            } else {
                completionHandler(nil, response.result.error)
            }
            
        }
    }
    
    func loadFriendsWithIds(userIds:[String], completionHandler: @escaping (_ friends:[Friend]?,_ error:Error?)->() ) {
        let params = ["user_ids":userIds,"access_token":appToken, "fields":["photo_100"]] as [String : Any]
        
        Alamofire.request(VK.urlUsers, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON {[weak self] (response) in
            
            if response.result.isSuccess {
                var friends = [Friend]()
                if let value = response.result.value {
                    let json = JSON(value)
                    if let result = json.dictionary {
                        if let users = result["response"]?.array {
                            for userJson in users {
                                friends.append(Friend(json:userJson))
                            }
                            completionHandler(friends, nil)
                        }
                    }
                }
                
            } else {
                completionHandler(nil, response.result.error)
            }
            
        }
    }
    
    
}
