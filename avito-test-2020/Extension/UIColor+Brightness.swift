//
//  UIColor+Brightness.swift
//  avito-test-2020
//
//  Created by Ирек Хабибуллин on 22.11.2022.
//

import UIKit

extension UIColor {
    func withBrightnessAdjustedTo(constant: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        self.getHue(
            &hue,
            saturation: &saturation,
            brightness: &brightness,
            alpha: &alpha
        )
        return UIColor(
            hue: hue,
            saturation: saturation,
            brightness: min((brightness + constant), 1.0),
            alpha: alpha
        )
    }
}
