//
//  UIColor+CustomColor.swift
//  avito-test-2020
//
//  Created by Ирек Хабибуллин on 22.11.2022.
//

import UIKit

extension UIColor {
    struct Avito {
        static var blue: UIColor {
            return UIColor(red: 1/255, green: 172/255,
                           blue: 1, alpha: 1)
        }
        static var cellGray: UIColor {
            return UIColor(red: 240/255, green: 240/255,
                           blue: 240/255, alpha: 1)
        }
        static var lightBlue: UIColor {
            return UIColor(red: 200/255, green: 231/255,
                           blue: 1, alpha: 1)
        }
    }
}
