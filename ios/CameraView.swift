//
//  CameraView.swift
//  mrousavy
//
//  Created by Marc Rousavy on 09.11.20.
//  Copyright © 2020 mrousavy. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit
import CoreMotion

// TODOs for the CameraView which are currently too hard to implement either because of AVFoundation's limitations, or my brain capacity
//
// CameraView+RecordVideo
// TODO: Better startRecording()/stopRecording() (promise + callback, wait for TurboModules/JSI)
//
// CameraView+TakePhoto
// TODO: Photo HDR

// MARK: - CameraView

public final class CameraView: UIView, CameraSessionDelegate {
  // pragma MARK: React Properties
  // props that require reconfiguring
  @objc var cameraId: NSString?
  @objc var enableDepthData = false
  @objc var enableHighQualityPhotos = false
  @objc var enablePortraitEffectsMatteDelivery = false
  @objc var enableBufferCompression = false
  // use cases
  @objc var photo = false
  @objc var video = false
  @objc var audio = false
  @objc var enableFrameProcessor = false
  @objc var codeScannerOptions: NSDictionary?
  @objc var pixelFormat: NSString?
  // props that require format reconfiguring
  @objc var format: NSDictionary?
  @objc var fps: NSNumber?
  @objc var videoHdr = false
  @objc var photoHdr = false
  @objc var lowLightBoost = false
  @objc var orientation: NSString?
  // other props
  @objc var isActive = false
  @objc var torch = "off"
  @objc var zoom: NSNumber = 1.0 // in "factor"
  @objc var exposure: NSNumber = 1.0
  @objc var enableFpsGraph = false
    @objc var videoMode = false
  @objc var videoStabilizationMode: NSString?
    @objc var onZoomChanged: RCTDirectEventBlock?
    let motionManager = CMMotionManager()
  @objc var maxFileSize = 2000000
  @objc var resizeMode: NSString = "cover" {
    didSet {
      let parsed = try? ResizeMode(jsValue: resizeMode as String)
      previewView.resizeMode = parsed ?? .cover
    }
  }
    var tapGestureRecognizer: UITapGestureRecognizer?

  // events
  @objc var onInitialized: RCTDirectEventBlock?
  @objc var onError: RCTDirectEventBlock?
  @objc var onViewReady: RCTDirectEventBlock?
  @objc var onCodeScanned: RCTDirectEventBlock?
  // zoom
  @objc var enableZoomGesture = false {
    didSet {
      if enableZoomGesture {
        addPinchGestureRecognizer()
      } else {
        removePinchGestureRecognizer()
      }
    }
  }

  // pragma MARK: Internal Properties
  var cameraSession: CameraSession
  var isMounted = false
  var isReady = false
  #if VISION_CAMERA_ENABLE_FRAME_PROCESSORS
    @objc public var frameProcessor: FrameProcessor?
  #endif
  // CameraView+Zoom
  var pinchGestureRecognizer: UIPinchGestureRecognizer?
  var pinchScaleOffset: CGFloat = 1.0

  var previewView: PreviewView
  #if DEBUG
    var fpsGraph: RCTFPSGraph?
  #endif

  // pragma MARK: Setupx

  override public init(frame: CGRect) {
    // Create CameraSession 
    cameraSession = CameraSession()
    previewView = cameraSession.createPreviewView(frame: frame)
    super.init(frame: frame)
    cameraSession.delegate = self
      addTapGestureRecognizer()
    addSubview(previewView)
//      startOrientationListener()
      NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
 
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) is not implemented.")
  }

  override public func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)

    if newSuperview != nil {
      if !isMounted {
        isMounted = true
        onViewReady?(nil)
      }
    }
  }

    // This method will be called when the device orientation changes
    @objc func orientationChanged() {
        let orientation = UIDevice.current.orientation
        var deviceOrientation: UIInterfaceOrientation = .portrait
        switch orientation {
        case .portrait:
            deviceOrientation = .portrait
            break
        case .portraitUpsideDown:
            deviceOrientation = .portrait
            break
        case .landscapeLeft:
            deviceOrientation = .landscapeRight
            break
        case .landscapeRight:
            deviceOrientation = .landscapeLeft
            break
        default:
            deviceOrientation = .portrait
            break
        }
        if (cameraSession.configuration?.videoMode == false) {
            self.previewView.videoPreviewLayer.session?.outputs.forEach { output in
                output.connections.forEach { connection in
                    if connection.isVideoMirroringSupported {
                        connection.automaticallyAdjustsVideoMirroring = false
                        connection.setInterfaceOrientation(deviceOrientation)
                    }
                    self.previewView.videoPreviewLayer.connection?.setInterfaceOrientation(deviceOrientation)
                }}
        } else {
            self.previewView.videoPreviewLayer.connection?.setInterfaceOrientation(deviceOrientation)
        }
    }

  override public func layoutSubviews() {
    previewView.frame = frame
    previewView.bounds = bounds
  }

  func getPixelFormat() -> PixelFormat {
    // TODO: Use ObjC RCT enum parser for this
    if let pixelFormat = pixelFormat as? String {
      do {
        return try PixelFormat(jsValue: pixelFormat)
      } catch {
        if let error = error as? CameraError {
          onError(error)
        } else {
          onError(.unknown(message: error.localizedDescription, cause: error as NSError))
        }
      }
    }
    return .native
  }

  func getTorch() -> Torch {
    // TODO: Use ObjC RCT enum parser for this
    if let torch = try? Torch(jsValue: torch) {
      return torch
    }
    return .off
  }

  // pragma MARK: Props updating
  override public final func didSetProps(_ changedProps: [String]!) {
    ReactLogger.log(level: .info, message: "Updating \(changedProps.count) props: [\(changedProps.joined(separator: ", "))]")

    cameraSession.configure { config in
      // Input Camera Device
      config.cameraId = cameraId as? String

      // Photo
      if photo {
        config.photo = .enabled(config: CameraConfiguration.Photo(enableHighQualityPhotos: enableHighQualityPhotos,
                                                                  enableDepthData: enableDepthData,
                                                                  enablePortraitEffectsMatte: enablePortraitEffectsMatteDelivery))
      } else {
        config.photo = .disabled
      }

      // Video/Frame Processor
      if video || enableFrameProcessor {
        config.video = .enabled(config: CameraConfiguration.Video(pixelFormat: getPixelFormat(),
                                                                  enableBufferCompression: enableBufferCompression,
                                                                  enableHdr: videoHdr,
                                                                  enableFrameProcessor: enableFrameProcessor))
      } else {
        config.video = .disabled
      }

      // Audio
      if audio {
        config.audio = .enabled(config: CameraConfiguration.Audio())
      } else {
        config.audio = .disabled
      }

      // Code Scanner
      if let codeScannerOptions {
        let options = try CodeScannerOptions(fromJsValue: codeScannerOptions)
        config.codeScanner = .enabled(config: CameraConfiguration.CodeScanner(options: options))
      } else {
        config.codeScanner = .disabled
      }

      // Video Stabilization
      if let jsVideoStabilizationMode = videoStabilizationMode as? String {
        let videoStabilizationMode = try VideoStabilizationMode(jsValue: jsVideoStabilizationMode)
        config.videoStabilizationMode = videoStabilizationMode
      } else {
        config.videoStabilizationMode = .off
      }

      // Orientation
      if let jsOrientation = orientation as? String {
        let orientation = try Orientation(jsValue: jsOrientation)
        config.orientation = orientation
      } else {
        config.orientation = .portrait
      }

      // Format
      if let jsFormat = format {
        let format = try CameraDeviceFormat(jsValue: jsFormat)
        config.format = format
      } else {
        config.format = nil
      }

      // Side-Props
      config.fps = fps?.int32Value
      config.enableLowLightBoost = lowLightBoost
      config.torch = getTorch()

      // Zoom
      config.zoom = zoom.doubleValue

      // Exposure
      config.exposure = exposure.floatValue

      // isActive
      config.isActive = isActive
        
        config.maxFileSize = maxFileSize
        config.videoMode = videoMode
    }

    // Store `zoom` offset for native pinch-gesture
    if changedProps.contains("zoom") {
      pinchScaleOffset = zoom.doubleValue
    }

    // Set up Debug FPS Graph
    if changedProps.contains("enableFpsGraph") {
      DispatchQueue.main.async {
        self.setupFpsGraph()
      }
    }
  }

  func setupFpsGraph() {
    #if DEBUG
      if enableFpsGraph {
        if fpsGraph != nil { return }
        fpsGraph = RCTFPSGraph(frame: CGRect(x: 10, y: 54, width: 75, height: 45), color: .red)
        fpsGraph!.layer.zPosition = 9999.0
        addSubview(fpsGraph!)
      } else {
        fpsGraph?.removeFromSuperview()
        fpsGraph = nil
      }
    #endif
  }

  // pragma MARK: Event Invokers

  func onError(_ error: CameraError) {
    ReactLogger.log(level: .error, message: "Invoking onError(): \(error.message)")
    guard let onError = onError else {
      return
    }

    var causeDictionary: [String: Any]?
    if case let .unknown(_, cause) = error,
       let cause = cause {
      causeDictionary = [
        "code": cause.code,
        "domain": cause.domain,
        "message": cause.description,
        "details": cause.userInfo,
      ]
    }
    onError([
      "code": error.code,
      "message": error.message,
      "cause": causeDictionary ?? NSNull(),
    ])
  }

  func onSessionInitialized() {
    ReactLogger.log(level: .info, message: "Camera initialized!")
    guard let onInitialized = onInitialized else {
      return
    }
    onInitialized([String: Any]())
  }

  func onFrame(sampleBuffer: CMSampleBuffer) {
    #if VISION_CAMERA_ENABLE_FRAME_PROCESSORS
      if let frameProcessor = frameProcessor {
        // Call Frame Processor
        let frame = Frame(buffer: sampleBuffer, orientation: bufferOrientation)
        frameProcessor.call(frame)
      }
    #endif

    #if DEBUG
      if let fpsGraph {
        DispatchQueue.main.async {
          fpsGraph.onTick(CACurrentMediaTime())
        }
      }
    #endif
  }

  func onCodeScanned(codes: [CameraSession.Code], scannerFrame: CameraSession.CodeScannerFrame) {
    guard let onCodeScanned = onCodeScanned else {
      return
    }
    onCodeScanned([
      "codes": codes.map { $0.toJSValue() },
      "frame": scannerFrame.toJSValue(),
    ])
  }

    //ztesting focus
    @objc final func onTap(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: self.previewView)
        do {
            let normalized = self.previewView.captureDevicePointConverted(fromLayerPoint: tapLocation)
            try cameraSession.focus(point: normalized)

        showFocusIndicator(at: tapLocation)

        } catch {
            
        }
        // Handle tap gesture logic here
    }
    
    func showFocusIndicator(at point: CGPoint) {
          // Remove any existing focus indicator
          // Create a new focus indicator view
          let focusIndicatorSize: CGFloat = 60.0
          let focusIndicatorFrame = CGRect(x: point.x - focusIndicatorSize/2, y: point.y - focusIndicatorSize/2, width: focusIndicatorSize, height: focusIndicatorSize)
          let newFocusIndicatorView = UIView(frame: focusIndicatorFrame)
          newFocusIndicatorView.layer.borderColor = UIColor(red: 242/255, green: 166/255, blue: 27/255, alpha: 0.5).cgColor
          newFocusIndicatorView.layer.borderWidth = 3.0
          newFocusIndicatorView.layer.cornerRadius = 7.5

          // Add the focus indicator to the camera view
          self.previewView.addSubview(newFocusIndicatorView)

          // Animate the focus indicator
          UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
              newFocusIndicatorView.alpha = 0.0
          }) { _ in
              newFocusIndicatorView.removeFromSuperview()
          }

          // Save the reference to the new focus indicator view
      }
      
      func addTapGestureRecognizer() {
          removeTapGestureRecognizer()
          tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
          
          addGestureRecognizer(tapGestureRecognizer!)
      }

      func removeTapGestureRecognizer() {
          if let tapGestureRecognizer = tapGestureRecognizer {
              removeGestureRecognizer(tapGestureRecognizer)
              self.tapGestureRecognizer = nil
          }
      }
    
    //end ztesting focus
  /**
   Gets the orientation of the CameraView's images (CMSampleBuffers).
   */
  private var bufferOrientation: UIImage.Orientation {
    guard let cameraPosition = cameraSession.videoDeviceInput?.device.position else {
      return .up
    }
    let orientation = cameraSession.configuration?.orientation ?? .portrait

    // TODO: I think this is wrong.
    switch orientation {
    case .portrait:
      return cameraPosition == .front ? .leftMirrored : .right
    case .landscapeLeft:
      return cameraPosition == .front ? .downMirrored : .up
    case .portraitUpsideDown:
      return cameraPosition == .front ? .rightMirrored : .left
    case .landscapeRight:
      return cameraPosition == .front ? .upMirrored : .down
    }
  }
}
