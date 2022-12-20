//
//  UIImage+Insets.swift
//  avito-test-2020
//
//  Created by Ирек Хабибуллин on 22.11.2022.
//

import UIKit

extension UIImage {
    func withInset(_ insets: UIEdgeInsets) -> UIImage? {
        let cgSize = CGSize(
            width: self.size.width
                    + insets.left * self.scale
                    + insets.right * self.scale,
            height: self.size.height
                    + insets.top * self.scale
                    + insets.bottom * self.scale
        )

        UIGraphicsBeginImageContextWithOptions(cgSize, false, self.scale)
        defer { UIGraphicsEndImageContext() }

        let origin = CGPoint(
            x: insets.left * self.scale,
            y: insets.top * self.scale
        )
        self.draw(at: origin)

        return UIGraphicsGetImageFromCurrentImageContext()?
            .withRenderingMode(self.renderingMode)
    }
}
