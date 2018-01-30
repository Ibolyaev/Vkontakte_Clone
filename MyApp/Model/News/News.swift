import Foundation
struct News : Decodable {
    let type : String?
    let source_id : Int
    let date : Int?
    let post_id : Int?
    let post_type : String?
    let text : String?
    let marked_as_ads : Int?
    let attachments : [Attachment]?
    let post_source : Post_source?
    let comments : Comments?
    let likes : Likes?
    let reposts : Reposts?
    let views : Views?
    lazy var havePhoto:Bool = {
        return attachments?.first() {$0.type == "photo" || $0.type == "video"} != nil
    }()
    var profile: Profile?
}
