//
//  Response.swift
//  avito-test-2020
//
//  Created by Ирек Хабибуллин on 17.11.2022.
//

import Foundation

struct Response: Codable {
    let status: String
    let contents: Contents
    
    enum CodingKeys: String, CodingKey {
        case status
        case contents = "result"
    }
}
