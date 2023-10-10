//
//  PreviewView.swift
//  VisionCamera
//
//  Created by Marc Rousavy on 30.11.22.
//  Copyright © 2022 mrousavy. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit
import AVKit

class PreviewView: UIView {
  /**
   Convenience wrapper to get layer as its statically known type.
   */
  var videoPreviewLayer: AVCaptureVideoPreviewLayer {
    // swiftlint:disable force_cast
    //TODO zTest: Trying things out. Use videoOrientationAngle for iOS 17
    let previewLayer = layer as! AVCaptureVideoPreviewLayer
    return previewLayer
    // swiftlint:enable force_cast
  }

  /**
   Gets or sets the resize mode of the PreviewView.
   */
  var resizeMode: ResizeMode = .cover {
    didSet {
      switch resizeMode {
      case .cover:
        videoPreviewLayer.videoGravity = .resizeAspectFill
      case .contain:
        videoPreviewLayer.videoGravity = .resizeAspect
      }
    }
  }

  override public class var layerClass: AnyClass {
    return AVCaptureVideoPreviewLayer.self
  }

  init(frame: CGRect, session: AVCaptureSession) {
    super.init(frame: frame)
    videoPreviewLayer.session = session
    videoPreviewLayer.videoGravity = .resizeAspectFill
      //TODO: zTesting
    videoPreviewLayer.connection?.videoOrientation = .landscapeRight
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) is not implemented!")
  }
}
