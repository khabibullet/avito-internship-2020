//
//  Contents.swift
//  avito-test-2020
//
//  Created by Irek Khabibullin on 10/26/22.
//

import Foundation

struct Contents: Codable {
    let title: String
    let actionTitle, selectedActionTitle: String
    var offers: Offers

    enum CodingKeys: String, CodingKey {
        case title, actionTitle, selectedActionTitle
        case offers = "list"
    }
}
