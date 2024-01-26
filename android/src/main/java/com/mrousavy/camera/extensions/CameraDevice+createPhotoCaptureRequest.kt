package com.mrousavy.camera.extensions

import android.content.Context
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraDevice
import android.hardware.camera2.CameraManager
import android.hardware.camera2.CaptureRequest
import android.view.Display
import android.view.OrientationEventListener
import android.view.Surface
import android.view.WindowManager
import androidx.core.content.ContextCompat.getSystemService
import com.mrousavy.camera.types.Flash
import com.mrousavy.camera.types.Orientation
import com.mrousavy.camera.types.QualityPrioritization


private fun supportsSnapshotCapture(cameraCharacteristics: CameraCharacteristics): Boolean {
  // As per CameraDevice.TEMPLATE_VIDEO_SNAPSHOT in documentation:
  val hardwareLevel = cameraCharacteristics.get(CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL)!!
  if (hardwareLevel == CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL_LEGACY) return false

  val capabilities = cameraCharacteristics.get(CameraCharacteristics.REQUEST_AVAILABLE_CAPABILITIES)!!
  val hasDepth = capabilities.contains(CameraCharacteristics.REQUEST_AVAILABLE_CAPABILITIES_DEPTH_OUTPUT)
  val isBackwardsCompatible = !capabilities.contains(CameraCharacteristics.REQUEST_AVAILABLE_CAPABILITIES_BACKWARD_COMPATIBLE)
  if (hasDepth && !isBackwardsCompatible) return false

  return true
}

private fun getJpegOrientation(c: CameraCharacteristics, deviceOrientation: Int): Int {
  //0 : portrait
  //1 : landscape left
  //2 :
  //3 : landscape right
  var deviceOrientation = deviceOrientation
  if (deviceOrientation == OrientationEventListener.ORIENTATION_UNKNOWN) return 0
  if (deviceOrientation == 1) return -90
  if (deviceOrientation == 3) return 180
  val sensorOrientation = c.get(CameraCharacteristics.SENSOR_ORIENTATION)!!

  // Round device orientation to a multiple of 90
  deviceOrientation = (deviceOrientation + 45) / 90 * 90

  // Reverse device orientation for front-facing cameras
  val facingFront = c.get(CameraCharacteristics.LENS_FACING) == CameraCharacteristics.LENS_FACING_FRONT
  if (facingFront) deviceOrientation = -deviceOrientation

  // Calculate desired JPEG orientation relative to camera orientation to make
  // the image upright relative to the device orientation
  return (sensorOrientation + deviceOrientation + 360) % 360
}

fun CameraDevice.createPhotoCaptureRequest(
  cameraManager: CameraManager,
  surface: Surface,
  zoom: Float,
  qualityPrioritization: QualityPrioritization,
  flashMode: Flash,
  enableRedEyeReduction: Boolean,
  enableAutoStabilization: Boolean,
  enableHdr: Boolean,
  context: Context
): CaptureRequest {
  val cameraCharacteristics = cameraManager.getCameraCharacteristics(this.id)

  val template = if (qualityPrioritization == QualityPrioritization.SPEED && supportsSnapshotCapture(cameraCharacteristics)) {
    CameraDevice.TEMPLATE_VIDEO_SNAPSHOT
  } else {
    CameraDevice.TEMPLATE_STILL_CAPTURE
  }
  val captureRequest = this.createCaptureRequest(template)
  captureRequest.addTarget(surface)

  // TODO: Maybe we can even expose that prop directly?
  val jpegQuality = when (qualityPrioritization) {
    QualityPrioritization.SPEED -> 85
    QualityPrioritization.BALANCED -> 92
    QualityPrioritization.QUALITY -> 100
  }
  captureRequest.set(CaptureRequest.JPEG_QUALITY, jpegQuality.toByte())

  // TODO: Use the same options as from the preview request. This is duplicate code!

  when (flashMode) {
    // Set the Flash Mode
    Flash.OFF -> {
      captureRequest.set(CaptureRequest.CONTROL_AE_MODE, CaptureRequest.CONTROL_AE_MODE_ON)
      captureRequest.set(CaptureRequest.FLASH_MODE, CaptureRequest.FLASH_MODE_OFF)
    }
    Flash.ON -> {
      captureRequest.set(CaptureRequest.CONTROL_AE_MODE, CaptureRequest.CONTROL_AE_MODE_ON)
      captureRequest.set(CaptureRequest.FLASH_MODE, CaptureRequest.FLASH_MODE_TORCH)
    }
    Flash.AUTO -> {
      if (enableRedEyeReduction) {
        captureRequest.set(CaptureRequest.CONTROL_AE_MODE, CaptureRequest.CONTROL_AE_MODE_ON_AUTO_FLASH_REDEYE)
      } else {
        captureRequest.set(CaptureRequest.CONTROL_AE_MODE, CaptureRequest.CONTROL_AE_MODE_ON_AUTO_FLASH)
      }
    }
  }

  if (enableAutoStabilization) {
    // Enable optical or digital image stabilization
    val digitalStabilization = cameraCharacteristics.get(CameraCharacteristics.CONTROL_AVAILABLE_VIDEO_STABILIZATION_MODES)
    val hasDigitalStabilization = digitalStabilization?.contains(CameraCharacteristics.CONTROL_VIDEO_STABILIZATION_MODE_ON) ?: false

    val opticalStabilization = cameraCharacteristics.get(CameraCharacteristics.LENS_INFO_AVAILABLE_OPTICAL_STABILIZATION)
    val hasOpticalStabilization = opticalStabilization?.contains(CameraCharacteristics.LENS_OPTICAL_STABILIZATION_MODE_ON) ?: false
    if (hasOpticalStabilization) {
      captureRequest.set(CaptureRequest.CONTROL_VIDEO_STABILIZATION_MODE, CaptureRequest.CONTROL_VIDEO_STABILIZATION_MODE_OFF)
      captureRequest.set(CaptureRequest.LENS_OPTICAL_STABILIZATION_MODE, CaptureRequest.LENS_OPTICAL_STABILIZATION_MODE_ON)
    } else if (hasDigitalStabilization) {
      captureRequest.set(CaptureRequest.CONTROL_VIDEO_STABILIZATION_MODE, CaptureRequest.CONTROL_VIDEO_STABILIZATION_MODE_ON)
    } else {
      // no stabilization is supported. ignore it
    }
  }

  // TODO: Check if that zoom value is even supported.
  captureRequest.setZoom(zoom, cameraCharacteristics)

  // Set HDR
  // TODO: Check if that value is even supported
  if (enableHdr) {
    captureRequest.set(CaptureRequest.CONTROL_SCENE_MODE, CaptureRequest.CONTROL_SCENE_MODE_HDR)
  }

  val wm = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
  val display = wm.defaultDisplay
  var rotVal = getJpegOrientation(cameraCharacteristics, display.rotation)

  captureRequest.set(CaptureRequest.JPEG_ORIENTATION, rotVal)

  return captureRequest.build()
}
