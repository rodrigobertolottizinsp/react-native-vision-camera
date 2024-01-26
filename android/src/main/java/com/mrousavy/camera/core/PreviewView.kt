package com.mrousavy.camera.core

import android.annotation.SuppressLint
import android.content.Context
import android.content.res.Configuration
import android.hardware.camera2.CameraManager
import android.util.Log
import android.util.Size
import android.view.*
import android.widget.FrameLayout
import com.mrousavy.camera.extensions.bigger
import com.mrousavy.camera.extensions.getMaximumPreviewSize
import com.mrousavy.camera.extensions.getPreviewTargetSize
import com.mrousavy.camera.extensions.smaller
import com.mrousavy.camera.types.CameraDeviceFormat
import com.mrousavy.camera.types.ResizeMode
import kotlin.math.roundToInt

@SuppressLint("ViewConstructor")
class PreviewView(context: Context, callback: SurfaceHolder.Callback) : SurfaceView(context) {
  var size: Size = getMaximumPreviewSize()
    set(value) {
      Log.i(TAG, "Resizing PreviewView to ${value.width} x ${value.height}...")
      holder.setFixedSize(value.width, value.height)
      requestLayout()
      invalidate()
      field = value
    }
  var resizeMode: ResizeMode = ResizeMode.COVER
    set(value) {
      if (value != field) {
        requestLayout()
        invalidate()
      }
      field = value
    }

  init {
    Log.i(TAG, "Creating PreviewView...")
    layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT,
            Gravity.CENTER
    )
    holder.addCallback(callback)

  }

  fun resizeToInputCamera(cameraId: String, cameraManager: CameraManager, format: CameraDeviceFormat?) {
    val characteristics = cameraManager.getCameraCharacteristics(cameraId)

    val targetPreviewSize = format?.videoSize
    val formatAspectRatio = if (targetPreviewSize != null) targetPreviewSize.bigger.toDouble() / targetPreviewSize.smaller else null
    size = characteristics.getPreviewTargetSize(formatAspectRatio)
  }

  fun getSize(contentSize: Size, containerSize: Size, resizeMode: ResizeMode): Size {
    var contentAspectRatio = contentSize.height.toDouble() / contentSize.width
    val containerAspectRatio = containerSize.width.toDouble() / containerSize.height

    Log.d(TAG, "coverSize :: $contentSize ($contentAspectRatio), ${containerSize.width}x${containerSize.height} ($containerAspectRatio)")

    val widthOverHeight = when (resizeMode) {
      ResizeMode.COVER -> contentAspectRatio > containerAspectRatio
      ResizeMode.CONTAIN -> contentAspectRatio < containerAspectRatio
    }

    return if (widthOverHeight) {
      // Scale by width to cover height
      val scaledWidth = containerSize.height * contentAspectRatio
      Size(scaledWidth.roundToInt(), containerSize.height)
    } else {
      // Scale by height to cover width
      val scaledHeight = containerSize.width / contentAspectRatio
      Size(containerSize.width, scaledHeight.roundToInt())
    }
  }


  @SuppressLint("DrawAllocation")
  override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
    super.onMeasure(widthMeasureSpec, heightMeasureSpec)

    val viewSize = Size(MeasureSpec.getSize(widthMeasureSpec), MeasureSpec.getSize(heightMeasureSpec))
    val fittedSize = getSize(size, viewSize, resizeMode)
    val wm = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    val isLandscape = wm.defaultDisplay.rotation != 0
    Log.i(TAG, "PreviewView is $viewSize, rendering $size content. Resizing to: $fittedSize ($resizeMode)")
    if (isLandscape) {
      Log.i(TAG, "Setting landscape dimensions: $size")
      setMeasuredDimension(1920, 1080)
    }else{
      Log.i(TAG, "Setting portrait dimensions: $fittedSize")
      setMeasuredDimension(1080, 1920)
    }
  }

  companion object {
    private const val TAG = "PreviewView"
  }
}
