import Foundation
struct Attachments : Decodable {
	let type : String
	let photo : NewsPhoto?
    let video : Video?
}
