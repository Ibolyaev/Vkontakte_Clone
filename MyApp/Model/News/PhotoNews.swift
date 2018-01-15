/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct PhotoNews : Decodable {
	let id : Int?
	let album_id : Int?
	let owner_id : Int?
	let user_id : Int?
	let photo_75 : String?
	let photo_130 : String?
	let photo_604 : String?
	let photo_807 : String?
	let photo_1280 : String?
	let width : Int?
	let height : Int?
	let text : String?
	let date : Int?
	let post_id : Int?
	let access_key : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case album_id = "album_id"
		case owner_id = "owner_id"
		case user_id = "user_id"
		case photo_75 = "photo_75"
		case photo_130 = "photo_130"
		case photo_604 = "photo_604"
		case photo_807 = "photo_807"
		case photo_1280 = "photo_1280"
		case width = "width"
		case height = "height"
		case text = "text"
		case date = "date"
		case post_id = "post_id"
		case access_key = "access_key"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		album_id = try values.decodeIfPresent(Int.self, forKey: .album_id)
		owner_id = try values.decodeIfPresent(Int.self, forKey: .owner_id)
		user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
		photo_75 = try values.decodeIfPresent(String.self, forKey: .photo_75)
		photo_130 = try values.decodeIfPresent(String.self, forKey: .photo_130)
		photo_604 = try values.decodeIfPresent(String.self, forKey: .photo_604)
		photo_807 = try values.decodeIfPresent(String.self, forKey: .photo_807)
		photo_1280 = try values.decodeIfPresent(String.self, forKey: .photo_1280)
		width = try values.decodeIfPresent(Int.self, forKey: .width)
		height = try values.decodeIfPresent(Int.self, forKey: .height)
		text = try values.decodeIfPresent(String.self, forKey: .text)
		date = try values.decodeIfPresent(Int.self, forKey: .date)
		post_id = try values.decodeIfPresent(Int.self, forKey: .post_id)
		access_key = try values.decodeIfPresent(String.self, forKey: .access_key)
	}

}
