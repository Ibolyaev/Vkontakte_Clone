//
//  VkAPI.swift
//  MyApp
//
//  Created by Ronin on 31/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import Foundation
import Alamofire

struct VKResponse<T:Decodable>: Decodable {
    let response:T
}

struct PostResponse: Decodable {
    let postId: Int
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
    }
}

struct UploadServer: Decodable {
    let uploadUrl: URL
    let albumId: Int
    let userid: Int
    
    enum CodingKeys: String, CodingKey {
        case uploadUrl = "upload_url"
        case albumId = "album_id"
        case userid = "user_id"
    }
}
struct UploadedPhotoResponse: Codable {
    let hash: String
    let photo: String
    let server: Int
}

struct JoinGroupResponse: Codable {
    let response: Int
}

struct UserFriendsResponse: Codable {
    let items:[Int]
    let count:Int
}

struct UserPhotosResponse: Codable {
    let items:[AlbumPhoto]
    let count:Int
}

struct UserGroupsResponse: Decodable {
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
            URLQueryItem(name: "scope", value:"email,offline,friends,wall,groups,photos"),
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
    
    func joinGroup(_ group: Group, completionHandler:@escaping (_ success: Bool, _ error: Error?) -> () ) {
        let parameters = ["group_id":group.id] as [String : Any]
        getResourse(VKConstants.groupsJoin, parameters: parameters, type: Int.self) {(_ response, error) in
            completionHandler(response ?? 0 == 1, error)
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
    
    func uploadPhoto(_ photo: UIImage, completionHandler:@escaping (_ newsPhoto:NewsPhoto?,_ error:Error?)->()) {
        let parameters = ["access_token": AppState.shared.token ?? ""] as [String : Any]
        getResourse(VKConstants.wallUploadServer, parameters: parameters, type: UploadServer.self) {[weak self] (uploadServer, error) in
            if let uploadServer = uploadServer {
                /*Передача файла
                Передайте файл на адрес upload_url, полученный в предыдущем пункте, сформировав POST-запрос с полем photo. Это поле должно содержать изображение в формате multipart/form-data.*/
                guard let urlRequest = try? URLRequest(url: uploadServer.uploadUrl, method: .post) else {
                    completionHandler(nil, error)
                    return
                }
                
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    if let imageData = UIImageJPEGRepresentation(photo, 1.0) {
                        multipartFormData.append(imageData, withName: "photo", fileName: "photo.jpeg", mimeType: "image/jpeg")
                    }
                }, with: urlRequest, encodingCompletion: { (encodingResult) in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseData { response in
                            //debugPrint(response)
                            if response.result.isSuccess, let data = response.data {
                                //UploadedPhotoResponse
                                var result:UploadedPhotoResponse?
                                do {
                                    result = try JSONDecoder().decode(UploadedPhotoResponse.self, from: data)
                                } catch let _ {
                                    if let errorJson = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]{
                                        print(errorJson?.values ?? "some error")
                                    }
                                    
                                    //completionHandler(nil, error)
                                }
                                if let photo = result {
                                   self?.saveWallPhoto(photo, completionHandler: completionHandler)
                                }
                                
                            }
                            
                            
                            }
                            .uploadProgress { progress in // main queue by default
                                print("Upload Progress: \(progress.fractionCompleted)")
                        }
                        return
                    case .failure(let encodingError):
                        debugPrint(encodingError)
                        completionHandler(nil, encodingError)
                    }
                })
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    func saveWallPhoto(_ photoResponse: UploadedPhotoResponse, completionHandler:@escaping (_ newsPhoto:NewsPhoto?,_ error:Error?)->()) {
        let parameters = ["user_id": AppState.shared.userId ?? "",
                          "photo": photoResponse.photo,
                          "server": photoResponse.server,
                          "hash": photoResponse.hash] as [String : Any]
        getResourse(VKConstants.saveWallPhoto, parameters: parameters, type: [NewsPhoto].self) { (photos, error) in
            if let photos = photos, let photo = photos.first {
               completionHandler(photo, nil)
            } else {
                completionHandler(nil, error)
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
                    // TODO: Make error as struct
                    if let errorJson = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]{
                        print(errorJson?.values)
                    }
                    
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
    
    func postOnWall(_ message: String, attachment: NewsPhoto?, completionHandler:@escaping (Bool, Error?)->()) {
        var parameters = ["owner_id": AppState.shared.userId ?? "",
                          "friends_only": 1,
                          "message": message,
                          "access_token": AppState.shared.token ?? ""] as [String : Any]
        if let attachment = attachment, let userId = AppState.shared.userId {
            /*Вы можете разместить её на стене, опубликовав запись с помощью метода wall.post и указав идентификатор фотографии в формате "photo"+{owner_id}+"_"+{photo_id} (например, photo12345_654321) в параметре attachments*/
            parameters.updateValue("photo\(userId)_\(attachment.id)", forKey: "attachments")
        }
        Alamofire.request(VKConstants.wallPost, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess, let data = response.data {
                do {
                    _ = try JSONDecoder().decode(VKResponse<PostResponse>.self, from: data)
                    completionHandler(true, nil)
                } catch let error {
                    completionHandler(false, error)
                }
            } else {
                completionHandler(false, response.result.error)
            }
        }
    }
}

