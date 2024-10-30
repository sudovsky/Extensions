//
//  UIImage.swift
//  Extensions
//
//  Created by Sudovsky on 15.05.2020.
//

import UIKit

public extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        
//        if #available(iOS 13.0, *) {
//            return self.withTintColor(color, renderingMode: UIImage.RenderingMode.alwaysTemplate)
//        } else {
            let maskImage = cgImage!
            
            let width = size.width
            let height = size.height
            let bounds = CGRect(x: 0, y: 0, width: width * scale, height: height * scale)
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
            let context = CGContext(data: nil, width: Int(width * scale), height: Int(height * scale), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
            
            context.clip(to: bounds, mask: maskImage)
            context.setFillColor(color.cgColor)
            context.fill(bounds)
            
            if let cgImage = context.makeImage() {
                let coloredImage = UIImage(cgImage: cgImage)
                return coloredImage
            } else {
                return nil
            }
//        }
        
    }
    

    func blurEffect() -> UIImage {
        
        let context = CIContext(options: nil)

        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(cgImage: self.cgImage!)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(10, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CIGaussianBlur")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        return processedImage
        
    }
    
    func blurEffect(radius: CGFloat = 0.0) -> UIImage {
        
        let context = CIContext(options: nil)
        
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(cgImage: self.cgImage!)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(radius, forKey: kCIInputRadiusKey)
        
        let output = currentFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        return processedImage
    }
    
    func applyBlurEffect() -> UIImage {
        let imageToBlur = CIImage(image: self)
        let blurfilter = CIFilter(name: "CIGaussianBlur")
        blurfilter?.setValue(imageToBlur, forKey: "inputImage")
        let resultImage = blurfilter?.value(forKey: "outputImage") as! CIImage
        let blurredImage = UIImage(ciImage: resultImage)
        return blurredImage
        
    }
    
    func overlayWith(image: UIImage) -> UIImage {

        let newSize = CGSize(width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: image.size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
        
    }

    var png: Data? {
        guard let flattened = flattened else { return nil }
        return flattened.pngData()  // Swift 4.2 or later
        // return UIImagePNGRepresentation(flattened)  // Swift 4.1  or earlier
    }
    
    var jpg: Data? {
        guard let flattened = flattened else { return nil }
        return flattened.jpegData(compressionQuality: 0.8)  // Swift 4.2 or later
    }
    
    var flattened: UIImage? {
        if imageOrientation == .up { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func toBase64() -> String? {
        guard let imageData = self.jpg else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
        func resize(targetSize: CGSize, scale: CGFloat? = nil) -> UIImage {
            if targetSize.width >= size.width || targetSize.height >= size.height {
                return self
            }
            
            let widthRatio  = targetSize.width  / size.width
            let heightRatio = targetSize.height / size.height

            // Figure out what our orientation is, and use that to form the rectangle
            var newSize: CGSize
            if(widthRatio < heightRatio) {
                newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            } else {
                newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
            }

            // This is the rect that we've calculated out and this is what is actually used below
            let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

            // Actually do the resizing to the rect using the ImageContext stuff
    //        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    //        draw(in: rect)
    //        let newImage = UIGraphicsGetImageFromCurrentImageContext()
    //        UIGraphicsEndImageContext()
    //
    //        return newImage!
            let format = UIGraphicsImageRendererFormat()
            format.scale = scale ?? self.scale

            let renderer = UIGraphicsImageRenderer(size: rect.size, format: format)
            return renderer.image { (context) in
                self.draw(in: CGRect(origin: .zero, size: rect.size))
            }
            
        }
        
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }

}

