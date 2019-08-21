//
//  UIImage+Ex.swift
//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import UIKit

public extension UIImage {
  
  convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    guard let cgImage: CGImage = image?.cgImage else { return nil }
    self.init(cgImage: cgImage)
  }
}
