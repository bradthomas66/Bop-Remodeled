//
//  UIImage+Color.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-24.
//

import Foundation
import SwiftUI

extension UIImage {
    func createImageFromColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
