/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct News : Decodable {
	let type : String?
	let source_id : Int?
	let date : Int?
	let post_id : Int?
	let post_type : String?
	let text : String?
	let marked_as_ads : Int?
	let attachments : [Attachments]?
	let post_source : Post_source?
	let comments : Comments?
	let likes : Likes?
	let reposts : Reposts?
	let views : Views?

	enum CodingKeys: String, CodingKey {

		case type = "type"
		case source_id = "source_id"
		case date = "date"
		case post_id = "post_id"
		case post_type = "post_type"
		case text = "text"
		case marked_as_ads = "marked_as_ads"
		case attachments = "attachments"
		case post_source
		case comments
		case likes
		case reposts
		case views
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		source_id = try values.decodeIfPresent(Int.self, forKey: .source_id)
		date = try values.decodeIfPresent(Int.self, forKey: .date)
		post_id = try values.decodeIfPresent(Int.self, forKey: .post_id)
		post_type = try values.decodeIfPresent(String.self, forKey: .post_type)
		text = try values.decodeIfPresent(String.self, forKey: .text)
		marked_as_ads = try values.decodeIfPresent(Int.self, forKey: .marked_as_ads)
		attachments = try values.decodeIfPresent([Attachments].self, forKey: .attachments)
		post_source = try Post_source(from: decoder)
		comments = try Comments(from: decoder)
		likes = try Likes(from: decoder)
		reposts = try Reposts(from: decoder)
		views = try Views(from: decoder)
	}

}
