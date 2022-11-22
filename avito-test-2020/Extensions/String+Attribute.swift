//
//  String+Attributes.swift
//  avito-test-2020
//
//  Created by Ирек Хабибуллин on 22.11.2022.
//

import UIKit

extension String {
    func attributed(by attributes: [NSAttributedString.Key : Any]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let range = NSMakeRange(0, attributedString.length)
        attributedString.addAttributes(attributes, range: range)
        return attributedString
    }
}
