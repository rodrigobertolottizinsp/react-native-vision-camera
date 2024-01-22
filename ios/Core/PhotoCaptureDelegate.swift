//
//  PhotoCaptureDelegate.swift
//  mrousavy
//
//  Created by Marc Rousavy on 15.12.20.
//  Copyright © 2020 mrousavy. All rights reserved.
//

import AVFoundation
import MobileCoreServices

// Keeps a strong reference on delegates, as the AVCapturePhotoOutput only holds a weak reference.
private var delegatesReferences: [NSObject] = []

// MARK: - PhotoCaptureDelegate

class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
  private let promise: Promise
  private let enableShutterSound: Bool
    private let filePath: String
      private let aspectRatio: Double
      private let targetWidth: Int
    required init(promise: Promise, enableShutterSound: Bool, filePath: String, targetWidth: Int, aspectRatio: Double) {
    self.promise = promise
    self.enableShutterSound = enableShutterSound
      self.filePath = filePath
        self.targetWidth = targetWidth
        self.aspectRatio = aspectRatio
    super.init()
    delegatesReferences.append(self)
  }

    func resizeImageWithCIImage(image: CIImage, targetWidth: Int) -> CIImage? {
           let size = image.extent.size
           let aspectRatio = size.width / size.height
           let newSize: CGSize

           if size.width <= size.height {
               newSize = CGSize(width: CGFloat(targetWidth) / aspectRatio, height: CGFloat(targetWidth))
           } else {
               newSize = CGSize(width: CGFloat(targetWidth), height: CGFloat(targetWidth) / aspectRatio)
           }

           let scaleX = newSize.width / size.width
           let scaleY = newSize.height / size.height
           
           let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
           let resizedImage = image.transformed(by: transform)
           return resizedImage
       }
    
    func fixOrientationOfCIImage(_ inputImage: CIImage) -> CIImage? {
           guard let orientation = inputImage.properties["Orientation"] as? Int else {
               return inputImage // No orientation information, return the original image
           }

           var transform = CGAffineTransform.identity

           switch orientation {
           case 1:
               break // No transformation needed for the default orientation (1)
           case 2:
               transform = transform.scaledBy(x: -1.0, y: 1.0)
           case 3:
               transform = transform.rotated(by: .pi)
           case 4:
               transform = transform.scaledBy(x: 1.0, y: -1.0)
           case 5:
               transform = transform.rotated(by: .pi).scaledBy(x: -1.0, y: 1.0)
           case 6:
               transform = transform.rotated(by: .pi / -2)
           case 7:
               transform = transform.rotated(by: .pi / -2).scaledBy(x: -1.0, y: 1.0)
           case 8:
               transform = transform.rotated(by: .pi / -2)
           default:
               break // Invalid orientation value, return the original image
           }

           return inputImage.transformed(by: transform)
       }
    
//    func cropImageVertically(image: CIImage, aspectRatio: CGFloat ) -> CIImage? {
//            // Calculate the target width based on the aspect ratio
//            let orientation = image.properties["Orientation"] as? Int
//            var targetHeight = image.extent.width;
//            var targetWidth = image.extent.height
//            let parsedWidth = CGFloat(image.extent.width)
//            let parsedHeight = CGFloat(image.extent.height)
//            var verticalCropStartPoint = 0.0
//            var horizontalCropStartPoint = 0.0
//            if (image.extent.width < image.extent.height){
//                targetHeight =  parsedWidth * aspectRatio
//                targetWidth = image.extent.width
//                verticalCropStartPoint = image.extent.height - ((image.extent.height - targetHeight)/2)
//            }else{
//                targetWidth = parsedHeight * aspectRatio
//                targetHeight = image.extent.height
//                if (orientation == 3){
//                    horizontalCropStartPoint = -image.extent.width
//                    verticalCropStartPoint = image.extent.height
//                }else{
//                    horizontalCropStartPoint = (image.extent.width - targetWidth)/2
//                }
//            }
//
//            // Calculate the crop rectangle
//            let cropRect = CGRect(x: horizontalCropStartPoint, y: -verticalCropStartPoint, width: targetWidth, height: targetHeight)
//            
//            // Apply the crop using CIFilter
//            let croppedImage = image.cropped(to: cropRect)
//            
//            return croppedImage
//        }
    
    func cropImageVertically(image: CIImage, aspectRatio: CGFloat ) -> CIImage? {
            // Calculate the target width based on the aspect ratio
            let orientation = image.properties["Orientation"] as? Int
            var targetHeight = image.extent.height;
            var targetWidth = image.extent.width
            let parsedWidth = CGFloat(image.extent.width)
            let parsedHeight = CGFloat(image.extent.height)
            var verticalCropStartPoint = 0.0
            var horizontalCropStartPoint = 0.0
            let isSquare = aspectRatio == 1.0
            let is169 = aspectRatio == 16.0/9.0
        if (aspectRatio == 4.0/3.0){
            return image
        }
        if (isSquare){
            if (image.extent.width < image.extent.height){
                targetHeight =  parsedWidth * aspectRatio
                targetWidth = image.extent.width
                verticalCropStartPoint = image.extent.height - ((image.extent.height - targetHeight)/2)
            }else{
                targetWidth = parsedHeight * aspectRatio
                targetHeight = image.extent.height
                horizontalCropStartPoint = (image.extent.width - targetWidth)/2
                if (orientation == 3){
                    horizontalCropStartPoint = -image.extent.width
                    verticalCropStartPoint = image.extent.height
                }
            }
        }
        if (is169){
            if (image.extent.width < image.extent.height){
                targetWidth = parsedHeight / aspectRatio
                targetHeight = image.extent.height
                horizontalCropStartPoint = (image.extent.width - targetWidth)/2
                verticalCropStartPoint = image.extent.height
            }else{
                targetHeight =  parsedWidth / aspectRatio
                targetWidth = parsedWidth
                verticalCropStartPoint = -(image.extent.height - (image.extent.height - ((image.extent.height - targetHeight)/2)))
                if (orientation == 3){
                    horizontalCropStartPoint = -image.extent.width
                    verticalCropStartPoint = image.extent.height
                }
            }
        }

            // Calculate the crop rectangle
//            let cropRect = CGRect(x: horizontalCropStartPoint, y: verticalCropStartPoint, width: targetWidth, height: targetHeight)
        let cropRect = CGRect(x: horizontalCropStartPoint, y: -verticalCropStartPoint, width: targetWidth, height: targetHeight)
            // Apply the crop using CIFilter
            let croppedImage = image.cropped(to: cropRect)
            
            return croppedImage
        }
        

    
    func convertCIImageToJPEG(ciImage: CIImage, compressionQuality: CGFloat) -> Data? {
            let context = CIContext(options: [
                .highQualityDownsample: true,
                .useSoftwareRenderer: false  // Set this to true if you need software rendering
            ])
            
            if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
                if let mutableData = CFDataCreateMutable(kCFAllocatorDefault, 0) {
                    if let destination = CGImageDestinationCreateWithData(mutableData, kUTTypeJPEG, 1, nil) {
                        let options: [AnyHashable: Any] = [kCGImageDestinationLossyCompressionQuality: compressionQuality]
                        CGImageDestinationAddImage(destination, cgImage, options as CFDictionary)
                        CGImageDestinationFinalize(destination)
                        return mutableData as Data
                    }
                }
            }
            return nil
        }
    
  func photoOutput(_: AVCapturePhotoOutput, willCapturePhotoFor _: AVCaptureResolvedPhotoSettings) {
    if !enableShutterSound {
      // disable system shutter sound (see https://stackoverflow.com/a/55235949/5281431)
      AudioServicesDisposeSystemSoundID(1108)
    }
  }

  func photoOutput(_: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    defer {
      delegatesReferences.removeAll(where: { $0 == self })
    }
    if let error = error as NSError? {
      promise.reject(error: .capture(.unknown(message: error.description)), cause: error)
      return
    }

    let error = ErrorPointer(nilLiteral: ())
    guard let tempFilePath = RCTTempFilePath("jpeg", error)
    else {
      let message = error?.pointee?.description
      promise.reject(error: .capture(.createTempFileError(message: message)), cause: error?.pointee)
      return
    }
      var url = URL(string: "file://\(tempFilePath)")!
//      var url = URL(string: tempFilePath)!
      if !filePath.isEmpty {
          url = URL(fileURLWithPath: filePath)
      }
      
    guard let data = photo.fileDataRepresentation() else {
      promise.reject(error: .capture(.fileError))
      return
    }

    do {
        if (targetWidth > 0){
                    //-------START CI IMAGE-------
                    guard var image = CIImage(data: data) else {
                        promise.reject(error: .capture(.fileError))
                        return
                    }
        
                    // 2. Resize the image
                    guard let resized = resizeImageWithCIImage(image: image, targetWidth: targetWidth) else {
                        promise.reject(error: .capture(.fileError))
                        return
                    }
        
                guard let fixRotation = fixOrientationOfCIImage(resized)
                    else {
                    promise.reject(error: .capture(.fileError))
                    return
                }
                
                guard let croppedImage = cropImageVertically(image: fixRotation, aspectRatio: aspectRatio) else { return }

                if let dataResized =  convertCIImageToJPEG(ciImage: croppedImage, compressionQuality: 0.9)
                {
                    // 5. Write the resized image data to the specified URL
                    try dataResized.write(to: url)
                } else {
                    promise.reject(error: .capture(.fileError))
                    return
                }
                    //-------END CI IMAGE-------
            }else{
                guard let image = CIImage(data: data) else {
                    promise.reject(error: .capture(.fileError))
                    return
                }
                guard let fixRotation = fixOrientationOfCIImage(image)
                    else {
                    promise.reject(error: .capture(.fileError))
                    return
                }
                guard let croppedImage = cropImageVertically(image: fixRotation, aspectRatio: aspectRatio) else { return }
                if let dataResized =  convertCIImageToJPEG(ciImage: croppedImage, compressionQuality: 0.9)
                {
                    // 5. Write the resized image data to the specified URL
                    try dataResized.write(to: url)
                }
            }
        
      let exif = photo.metadata["{Exif}"] as? [String: Any]
      let width = exif?["PixelXDimension"]
      let height = exif?["PixelYDimension"]
      let exifOrientation = photo.metadata[String(kCGImagePropertyOrientation)] as? UInt32 ?? CGImagePropertyOrientation.up.rawValue
      let cgOrientation = CGImagePropertyOrientation(rawValue: exifOrientation) ?? CGImagePropertyOrientation.up
      let orientation = getOrientation(forExifOrientation: cgOrientation)
      let isMirrored = getIsMirrored(forExifOrientation: cgOrientation)
        let exifMetadata = photo.metadata["{Exif}"] as? [String: Any] ?? [:]
        let tiffMetadata = photo.metadata["{TIFF}"] as? [String: Any] ?? [:]

        // Merge Exif and TIFF metadata into the existing metadata
        let mergedMetadata = photo.metadata
            .merging(exifMetadata) { (_, new) in new }
            .merging(tiffMetadata) { (_, new) in new }


      promise.resolve([
        "path": filePath,
        "width": width as Any,
        "height": height as Any,
        "orientation": orientation,
        "isMirrored": isMirrored,
        "isRawPhoto": photo.isRawPhoto,
        "metadata": mergedMetadata,
        "thumbnail": photo.embeddedThumbnailPhotoFormat as Any,
      ])
    } catch {
      promise.reject(error: .capture(.fileError), cause: error as NSError)
    }
  }

  func photoOutput(_: AVCapturePhotoOutput, didFinishCaptureFor _: AVCaptureResolvedPhotoSettings, error: Error?) {
    defer {
      delegatesReferences.removeAll(where: { $0 == self })
    }
    if let error = error as NSError? {
      promise.reject(error: .capture(.unknown(message: error.description)), cause: error)
      return
    }
  }

  private func getOrientation(forExifOrientation exifOrientation: CGImagePropertyOrientation) -> String {
    switch exifOrientation {
    case .up, .upMirrored:
      return "portrait"
    case .down, .downMirrored:
      return "portrait-upside-down"
    case .left, .leftMirrored:
      return "landscape-left"
    case .right, .rightMirrored:
      return "landscape-right"
    default:
      return "portrait"
    }
  }

  private func getIsMirrored(forExifOrientation exifOrientation: CGImagePropertyOrientation) -> Bool {
    switch exifOrientation {
    case .upMirrored, .rightMirrored, .downMirrored, .leftMirrored:
      return true
    default:
      return false
    }
  }
}