/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Profiles : Codable {
	let uid : Int?
	let first_name : String?
	let last_name : String?
	let sex : Int?
	let screen_name : String?
	let photo : String?
	let photo_medium_rec : String?
	let online : Int?

	enum CodingKeys: String, CodingKey {

		case uid = "uid"
		case first_name = "first_name"
		case last_name = "last_name"
		case sex = "sex"
		case screen_name = "screen_name"
		case photo = "photo"
		case photo_medium_rec = "photo_medium_rec"
		case online = "online"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		uid = try values.decodeIfPresent(Int.self, forKey: .uid)
		first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
		last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
		sex = try values.decodeIfPresent(Int.self, forKey: .sex)
		screen_name = try values.decodeIfPresent(String.self, forKey: .screen_name)
		photo = try values.decodeIfPresent(String.self, forKey: .photo)
		photo_medium_rec = try values.decodeIfPresent(String.self, forKey: .photo_medium_rec)
		online = try values.decodeIfPresent(Int.self, forKey: .online)
	}

}