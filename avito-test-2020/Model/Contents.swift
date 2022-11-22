//
//  Contents.swift
//  avito-test-2020
//
//  Created by Alebelly Nemesis on 10/26/22.
//

import Foundation

struct Contents: Codable {
    let title: String
    let actionTitle, selectedActionTitle: String
    var offers: [Offer]

    enum CodingKeys: String, CodingKey {
        case title, actionTitle, selectedActionTitle
        case offers = "list"
    }
}
