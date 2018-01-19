/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct NewsPhoto : Decodable {
	let pid : Int?
	let aid : Int?
	let owner_id : Int?
	let user_id : Int?
	let src : String?
	let src_big : String?
	let src_small : String?
	let src_xbig : String?
	let width : Int?
	let height : Int?
	let text : String?
	let created : Int?
	let post_id : Int?
	let access_key : String?
    let numberOfPhotos : Int?

	enum CodingKeys: String, CodingKey {

		case pid = "pid"
		case aid = "aid"
		case owner_id = "owner_id"
		case user_id = "user_id"
		case src = "src"
		case src_big = "src_big"
		case src_small = "src_small"
		case src_xbig = "src_xbig"
		case width = "width"
		case height = "height"
		case text = "text"
		case created = "created"
		case post_id = "post_id"
		case access_key = "access_key"
	}
	init(from decoder: Decoder) throws {
        // ВКонтакте передает массив в ответе, но первый элемент массива, это количество,
        // пытаемся распарсить, если не получилось, значит это первый элемент с количеством
        if let values = try? decoder.container(keyedBy: CodingKeys.self) {
            pid = try values.decodeIfPresent(Int.self, forKey: .pid)
            aid = try values.decodeIfPresent(Int.self, forKey: .aid)
            owner_id = try values.decodeIfPresent(Int.self, forKey: .owner_id)
            user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
            src = try values.decodeIfPresent(String.self, forKey: .src)
            src_big = try values.decodeIfPresent(String.self, forKey: .src_big)
            src_small = try values.decodeIfPresent(String.self, forKey: .src_small)
            src_xbig = try values.decodeIfPresent(String.self, forKey: .src_xbig)
            width = try values.decodeIfPresent(Int.self, forKey: .width)
            height = try values.decodeIfPresent(Int.self, forKey: .height)
            text = try values.decodeIfPresent(String.self, forKey: .text)
            created = try values.decodeIfPresent(Int.self, forKey: .created)
            post_id = try values.decodeIfPresent(Int.self, forKey: .post_id)
            access_key = try values.decodeIfPresent(String.self, forKey: .access_key)
            numberOfPhotos = nil
        } else {
            numberOfPhotos = try decoder.singleValueContainer().decode(Int.self)
            pid = nil
            aid = nil
            owner_id = nil
            user_id = nil
            src = nil
            src_big = nil
            src_small = nil
            src_xbig = nil
            width = nil
            height = nil
            text = nil
            created = nil
            post_id = nil
            access_key = nil
        }
	}

}
