//
//  UIImageExtension.swift
//  testApp
//
//  Created by Ammad Tariq on 03/10/2021.
//

import UIKit

extension UIImage {
    
    static var noUserImage: UIImage? {
        return UIImage(named: "no_user_image")
    }
    
    func inverseImage() -> UIImage {
        
        guard let cgImage = self.cgImage else { return self }
        let coreImage = CIImage(cgImage: cgImage)
        guard let filter = CIFilter(name: "CIColorInvert", parameters: ["inputImage" : coreImage]) else { return self }
        filter.setValue(coreImage, forKey: kCIInputImageKey)
        guard let result = filter.value(forKey: kCIOutputImageKey) as? UIKit.CIImage else { return self }
        return UIImage(ciImage: result)
    }
}
