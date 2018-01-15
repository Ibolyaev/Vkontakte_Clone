/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct NewsResponse : Decodable {
	let items : [News]?
	let profiles : [Profiles]?
	let groups : [NewsGroups]?
	let new_offset : Int?
	let new_from : String?

	enum CodingKeys: String, CodingKey {

		case items = "items"
		case profiles = "profiles"
		case groups = "groups"
		case new_offset = "new_offset"
		case new_from = "new_from"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		items = try values.decodeIfPresent([News].self, forKey: .items)
		profiles = try values.decodeIfPresent([Profiles].self, forKey: .profiles)
		groups = try values.decodeIfPresent([NewsGroups].self, forKey: .groups)
		new_offset = try values.decodeIfPresent(Int.self, forKey: .new_offset)
		new_from = try values.decodeIfPresent(String.self, forKey: .new_from)
	}

}
