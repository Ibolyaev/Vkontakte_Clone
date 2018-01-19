/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct NewsPhoto : Decodable {
    let id : Int?
    let album_id : Int?
    let owner_id : Int?
    let user_id : Int?
    let photo_75 : String?
    let photo_130 : String?
    let photo_604 : String?
    let photo_807 : String?
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
        width = try values.decodeIfPresent(Int.self, forKey: .width)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        date = try values.decodeIfPresent(Int.self, forKey: .date)
        post_id = try values.decodeIfPresent(Int.self, forKey: .post_id)
        access_key = try values.decodeIfPresent(String.self, forKey: .access_key)
    }
	/*init(from decoder: Decoder) throws {
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
	}*/

}
