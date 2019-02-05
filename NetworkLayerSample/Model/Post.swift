//
//	Post.swift
//
//	Create by Ismail Ahmed on 21/1/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Post : Codable {

	var body : String?
	var id : Int?
	var title : String?
	var userId : Int?

    
    init() {
        body = nil
        id = nil
        title = nil
        userId = nil
    }
    
	enum CodingKeys: String, CodingKey {
		case body = "body"
		case id = "id"
		case title = "title"
		case userId = "userId"
	}

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        body = try values.decodeIfPresent(String.self, forKey: .body)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
    }
}
