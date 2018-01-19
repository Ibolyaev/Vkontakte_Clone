import Foundation
struct Attachment : Decodable {
	let type : String
	let photo : NewsPhoto?
    let video : Video?
}

struct Video : Decodable {
    let image : String?
}
