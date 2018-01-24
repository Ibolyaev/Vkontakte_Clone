
import Foundation
struct Profiles : Codable, Profilable {
   
    var title: String { return screen_name }    
    var profilePhotoURL: String? { return photo_100 }
    
    let id : Int
    let first_name : String?
    let last_name : String?
    let sex : Int?
    let screen_name : String
    let photo_50 : String?
    let photo_100 : String?
    let online : Int?
    let online_app : String?
    let online_mobile : Int?
}
