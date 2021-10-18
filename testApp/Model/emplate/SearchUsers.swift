//
//  SearchUsers.swift
//  testApp
//
//  Created by Ammad Tariq on 14/10/2021.
//

import Foundation

struct SearchUsers : Codable {
    
    let totalCount: Int?
    let incompleteResults: Bool?
    var items = [User]()

    enum CodingKeys: String, CodingKey {

        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items = "items"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
        incompleteResults = try values.decodeIfPresent(Bool.self, forKey: .incompleteResults)
        items = try values.decodeIfPresent([User].self, forKey: .items) ?? []
    }
}
