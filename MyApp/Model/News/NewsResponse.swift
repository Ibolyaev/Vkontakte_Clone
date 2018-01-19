import Foundation
struct NewsResponse : Decodable {
	let items : [News]?
	let profiles : [Profiles]?
	let groups : [Group]?
	let new_offset : Int?
	let new_from : String?
}
