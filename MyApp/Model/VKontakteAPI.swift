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

class VKontakteAPI {

    let appToken = Constants.VK.accessToken
    
    func getGroupMembers(groupId:String, userToken:String, completionHandler:@escaping (_ membersCount:Int,_ groupId:String,_ error:Error?)->()) {
        let params = ["group_id":groupId,"access_token":userToken]
        
        Alamofire.request(Constants.VK.urlGroupMembers, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON {[groupId] (response) in
            
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
        
        Alamofire.request(Constants.VK.urlGroupsSearch, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON {(response) in
            
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
    
    func getUserGroups(_ userId: String, userToken:String, completionHandler:@escaping (_ groups:[Group]?,_ error:Error?)->() ) {
        let params = ["user_id":userId,"access_token":userToken,"extended":"1"] as [String : Any]
        
        Alamofire.request(Constants.VK.urlGroups, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON {(response) in
            
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
        
        Alamofire.request(Constants.VK.urlFriends, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON {[weak self] (response) in
            
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
        
        Alamofire.request(Constants.VK.urlUsers, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON {[weak self] (response) in
            
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
