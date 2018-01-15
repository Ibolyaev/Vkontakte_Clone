/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct NewsGroups : Codable {
	let gid : Int?
	let name : String?
	let screen_name : String?
	let is_closed : Int?
	let type : String?
	let photo : String?
	let photo_medium : String?
	let photo_big : String?

	enum CodingKeys: String, CodingKey {

		case gid = "gid"
		case name = "name"
		case screen_name = "screen_name"
		case is_closed = "is_closed"
		case type = "type"
		case photo = "photo"
		case photo_medium = "photo_medium"
		case photo_big = "photo_big"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		gid = try values.decodeIfPresent(Int.self, forKey: .gid)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		screen_name = try values.decodeIfPresent(String.self, forKey: .screen_name)
		is_closed = try values.decodeIfPresent(Int.self, forKey: .is_closed)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		photo = try values.decodeIfPresent(String.self, forKey: .photo)
		photo_medium = try values.decodeIfPresent(String.self, forKey: .photo_medium)
		photo_big = try values.decodeIfPresent(String.self, forKey: .photo_big)
	}

}
