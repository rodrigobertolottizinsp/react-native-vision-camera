//
//  PhotoCaptureDelegate.swift
//  mrousavy
//
//  Created by Marc Rousavy on 15.12.20.
//  Copyright © 2020 mrousavy. All rights reserved.
//

import AVFoundation

private var delegatesReferences: [NSObject] = []

// MARK: - PhotoCaptureDelegate

class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
  private let promise: Promise
  private let enableShutterSound: Bool
  private let filePath: String
    private let targetWidth: Int
    required init(promise: Promise, enableShutterSound: Bool, filePath: String, targetWidth: Int) {
    self.promise = promise
    self.enableShutterSound = enableShutterSound
    self.filePath = filePath  
      self.targetWidth = targetWidth
    super.init()
    delegatesReferences.append(self)
  }

  func photoOutput(_: AVCapturePhotoOutput, willCapturePhotoFor _: AVCaptureResolvedPhotoSettings) {
    if !enableShutterSound {
      // disable system shutter sound (see https://stackoverflow.com/a/55235949/5281431)
      AudioServicesDisposeSystemSoundID(1108)
    }
  }
    
    func resizeImage(image: UIImage, targetWidth: Int) -> UIImage? {
//        let targetSize = CGSize(width: size, height: size)

        let size = image.size
        let aspectRatio = size.width / size.height;
        let newSize = CGSize(width: CGFloat(targetWidth), height: CGFloat(targetWidth)/aspectRatio)
        
//        let widthRatio  = targetSize.width  / size.width
//        let heightRatio = targetSize.height / size.height
//        
//        // Figure out what our orientation is, and use that to form the rectangle
//        var newSize: CGSize
//        if(widthRatio > heightRatio) {
//            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
//        } else {
//            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
//        }
//        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    func convertToJPEGData(image: UIImage, compressionQuality: CGFloat = 1.0) -> Data? {
        return image.jpegData(compressionQuality: compressionQuality)
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
            promise.reject(error: .capture(.createTempFileError), cause: error?.pointee)
            return
        }
        
        let url: URL
        if !filePath.isEmpty {
            url = URL(fileURLWithPath: filePath)
        } else {
            url = URL(string: "file://\(tempFilePath)")!
        }
        
        guard let data = photo.fileDataRepresentation() else {
            promise.reject(error: .capture(.fileError))
            return
        }
              
    do {         
        if (targetWidth > 0){
            // 1. Check if data can be converted to UIImage
            guard let image = UIImage(data: data) else {
                promise.reject(error: .capture(.fileError))
                return
            }
            
            // 2. Resize the image
            guard let resized = resizeImage(image: image, targetWidth: targetWidth ) else {
                promise.reject(error: .capture(.fileError))
                return
            }
            
            // 3. Convert the resized image to JPEG data
            if let dataResized = convertToJPEGData(image: resized) {
                
                // 4. Write the resized image data to the specified URL
                try dataResized.write(to: url)
            } else {
                promise.reject(error: .capture(.fileError))
                return
            }
        }else{
            try data.write(to: url)
        }
      let exif = photo.metadata["{Exif}"] as? [String: Any]
      let width = exif?["PixelXDimension"]
      let height = exif?["PixelYDimension"]
    
      let exifOrientation = photo.metadata[String(kCGImagePropertyOrientation)] as? UInt32 ?? CGImagePropertyOrientation.up.rawValue
      let cgOrientation = CGImagePropertyOrientation(rawValue: exifOrientation) ?? CGImagePropertyOrientation.up
      let orientation = getOrientation(forExifOrientation: cgOrientation)
      let isMirrored = getIsMirrored(forExifOrientation: cgOrientation)

        //TODO zTest: Trying things 

        //STARTS NEW EXIF IMP
//        var existingMetadata = photo.metadata
//
//        // Create a new mutable metadata dictionary
//        var newMetadata = NSMutableDictionary(dictionary: existingMetadata)
//        let newPropertyKey = "NewPropertyKey"
//        let newPropertyValue = "NewPropertyValue"
//        newMetadata[newPropertyKey] = newPropertyValue
//
//        // Assign the new metadata dictionary to the photo
//        photo.metadata = (newMetadata as NSDictionary) as! [String : Any]
        //FINISHES NEW EXIF IMP

      promise.resolve([
        "path": filePath,
        "width": width as Any,
        "height": height as Any,
        "orientation": orientation,
        "isMirrored": isMirrored,
        "isRawPhoto": photo.isRawPhoto,
        "metadata": photo.metadata,
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
