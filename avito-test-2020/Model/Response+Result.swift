//
//  Response.swift
//  avito-test-2020
//
//  Created by Ирек Хабибуллин on 17.11.2022.
//

import Foundation

struct Response: Codable {
    let status: String
    let result: Result
}

struct Result: Codable {
    let title: String
    let actionTitle, selectedActionTitle: String
    var list: Offers
}
