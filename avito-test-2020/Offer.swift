//
//  File.swift
//  avito-test-2020
//
//  Created by Alebelly Nemesis on 10/26/22.
//

import Foundation

struct Offer: Codable {
    let id: String
    let title: String
    let description: String?
    let icon: Icon
    let price: String
    let isSelected: Bool
}

struct Icon: Codable {
    let url: String
    
    enum CodingKeys: String, CodingKey {
            case url = "52x52"
        }
}
