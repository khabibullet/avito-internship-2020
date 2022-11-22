//
//  UIColor+Brightness.swift
//  avito-test-2020
//
//  Created by Ирек Хабибуллин on 22.11.2022.
//

import UIKit

extension UIColor {
    func withBrightnessAdjustedTo(constant: CGFloat) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s,
                       brightness: min((b + constant), 1.0), alpha: a)
    }
}
