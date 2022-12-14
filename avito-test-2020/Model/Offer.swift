//
//  File.swift
//  avito-test-2020
//
//  Created by Irek Khabibullin on 10/26/22.
//

import Foundation

typealias Offers = [Offer]

struct Offer: Codable {
    var id, title: String
    let description: String?
    var icon: Icon
    let price: String
    var isSelected: Bool
}

struct Icon: Codable {
    let url: String
    var image: Data?

    enum CodingKeys: String, CodingKey {
        case url = "52x52"
        case image
    }
}
