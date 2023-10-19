//
//  CameraView+Orientation.swift
//  VisionCamera
//
//  Created by Marc Rousavy on 04.01.22.
//  Copyright © 2022 mrousavy. All rights reserved.
//

import Foundation
import UIKit

extension CameraView {
  /// Orientation of the input connection (preview)
  private var inputOrientation: UIInterfaceOrientation {
    return .portrait
  }

  // Orientation of the output connections (photo, video, frame processor)
  var UIOrientation: UIInterfaceOrientation {
    if let userOrientation = orientation as String?,
       let parsedOrientation = try? UIInterfaceOrientation(withString: userOrientation) {
      // user is overriding output orientation
      return parsedOrientation
    } else {
      // use same as input orientation
      return inputOrientation
    }
  }

    func startOrientationListener() {
            // Default to .up if gravity data is not available
            var orientation: UIInterfaceOrientation = .portrait
            
            // Check if device motion data is available
            if motionManager.isDeviceMotionAvailable {
                motionManager.deviceMotionUpdateInterval = 0.2
                // Start receiving device motion updates
                motionManager.startDeviceMotionUpdates(to: OperationQueue()) { [weak self] (data, error) in
                    guard let self = self else { return }
                    if let gravity = data?.gravity {
                        if abs(gravity.y) < abs(gravity.x) {
                            orientation = gravity.x > 0 ? .landscapeLeft : .landscapeRight
                        } else {
                            orientation = gravity.y > 0 ? .portraitUpsideDown : .portrait
                        }
                    }
                    
                    if self.outputOrientation != orientation{
                        self.outputOrientation = orientation
                        self.updateOrientation()
                        print("Physical Orientation: \(orientation.rawValue)")
                    }
                }
            }
        }
    
    func stopOrientationListener() {
        motionManager.stopDeviceMotionUpdates();
      }
    
    func updateOrientation() {
    // Updates the Orientation for all rotable
    let isMirrored = videoDeviceInput?.device.position == .front
//    self.previewView.videoPreviewLayer.connection?.videoOrientation = .portraitUpsideDown
    let connectionOrientation = outputOrientation
        self.previewView.videoPreviewLayer.connection?.setInterfaceOrientation(UIOrientation)
    captureSession.outputs.forEach { output in
      output.connections.forEach { connection in
        if connection.isVideoMirroringSupported {
          connection.automaticallyAdjustsVideoMirroring = false
          connection.isVideoMirrored = isMirrored
        }
        connection.setInterfaceOrientation(connectionOrientation)
      }
    }
  }
}
