import Foundation
struct NewsPhoto : Decodable {
    
    let id : Int
    let album_id : Int?
    let owner_id : Int?
    let user_id : Int?
    let photo_75 : String?
    let photo_130 : String?
    let photo_604 : String?
    let photo_807 : String?
    let width : Int?
    let height : Int?
    let text : String?
    let date : Int?
    let post_id : Int?
    let access_key : String?    
}
