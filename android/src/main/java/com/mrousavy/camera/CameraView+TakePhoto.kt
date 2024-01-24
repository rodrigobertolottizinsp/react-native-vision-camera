package com.mrousavy.camera

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.ImageFormat
import android.graphics.Matrix
import android.hardware.camera2.*
import android.util.Log
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableMap
import com.mrousavy.camera.core.CameraSession
import com.mrousavy.camera.types.Flash
import com.mrousavy.camera.types.Orientation
import com.mrousavy.camera.types.QualityPrioritization
import com.mrousavy.camera.utils.*
import java.io.File
import java.io.FileOutputStream
import kotlinx.coroutines.*

private const val TAG = "CameraView.takePhoto"

@SuppressLint("UnsafeOptInUsageError")
suspend fun CameraView.takePhoto(optionsMap: ReadableMap): WritableMap {
  val options = optionsMap.toHashMap()
  Log.i(TAG, "Taking photo... Options: $options")

  val qualityPrioritization = options["qualityPrioritization"] as? String ?: "balanced"
  val flash = options["flash"] as? String ?: "off"
  val enableAutoRedEyeReduction = options["enableAutoRedEyeReduction"] == true
  val enableAutoStabilization = options["enableAutoStabilization"] == true
  val enableShutterSound = options["enableShutterSound"] as? Boolean ?: true
  val filePath = options["filePath"] as? String ?: ""
  val targetWidth = options["targetWidth"] as? Int ?: 0
  val aspectRatio = options["aspectRatio"] as? Double ?: 4/3

  val flashMode = Flash.fromUnionValue(flash)
  val qualityPrioritizationMode = QualityPrioritization.fromUnionValue(qualityPrioritization)

  val photo = cameraSession.takePhoto(
    qualityPrioritizationMode,
    flashMode,
    enableShutterSound,
    enableAutoRedEyeReduction,
    enableAutoStabilization,
    orientation,
    targetWidth,
    aspectRatio as Double
  )

  photo.use {
    Log.i(TAG, "Successfully captured ${photo.image.width} x ${photo.image.height} photo!")

    val cameraCharacteristics = cameraManager.getCameraCharacteristics(cameraId!!)

    val path = savePhotoToFile(context, cameraCharacteristics, photo, filePath)

    Log.i(TAG, "Successfully saved photo to file! $path")

    val map = Arguments.createMap()
    map.putString("path", path)
    map.putInt("width", photo.image.width)
    map.putInt("height", photo.image.height)
    map.putString("orientation", photo.orientation.unionValue)
    map.putBoolean("isRawPhoto", photo.format == ImageFormat.RAW_SENSOR)
    map.putBoolean("isMirrored", photo.isMirrored)

    return map
  }
}
private fun resizeBitmap(bitmap: Bitmap, maxWidth: Int, maxHeight: Int): Bitmap {
  val width = bitmap.width
  val height = bitmap.height
  val scaleWidth = maxWidth.toFloat() / width
  val scaleHeight = maxHeight.toFloat() / height
  val scale = minOf(scaleWidth, scaleHeight)

  val matrix = Matrix()
  matrix.postScale(scale, scale)

  return Bitmap.createBitmap(bitmap, 0, 0, width, height, matrix, false)
}

private fun writePhotoToFile(photo: CameraSession.CapturedPhoto, file: File,         cameraCharacteristics: CameraCharacteristics
, context: Context) {
  val byteBuffer = photo.image.planes[0].buffer
  if (false) {
    val imageBytes = ByteArray(byteBuffer.remaining()).apply { byteBuffer.get(this) }
    val bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)
    val matrix = Matrix()

    matrix.preScale(-1f, 1f)

    val processedBitmap =
      Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, false)

    FileOutputStream(file).use { stream ->
      processedBitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream)
    }
  } else {
    val channel = FileOutputStream(file).channel
    channel.write(byteBuffer)
    channel.close()
  }
}

private suspend fun savePhotoToFile(
        context: Context,
        cameraCharacteristics: CameraCharacteristics,
        photo: CameraSession.CapturedPhoto,
        filePath: String
): String = withContext(Dispatchers.IO) {
  when (photo.format) {
    ImageFormat.JPEG, ImageFormat.DEPTH_JPEG -> {
      val file = createCustomFile(filePath, ".jpg")
      writePhotoToFile(photo, file, cameraCharacteristics, context)
      return@withContext file.absolutePath
    }
    ImageFormat.RAW_SENSOR -> {
      val dngCreator = DngCreator(cameraCharacteristics, photo.metadata)
      val file = createCustomFile(filePath, ".dng")
      FileOutputStream(file).use { stream ->
        dngCreator.writeImage(stream, photo.image)
      }
      return@withContext file.absolutePath
    }
    else -> {
      throw Error("Failed to save Photo to file, image format is not supported! ${photo.format}")
    }
  }
}

//private fun createFile(context: Context, extension: String): File =
//  File.createTempFile("mrousavy", extension, context.cacheDir).apply {
//    deleteOnExit()
//  }

private fun createFile(context: Context, extension: String): File =
        createCustomFile(context.cacheDir.absolutePath, extension)

private fun createCustomFile(filePath: String, extension: String): File =
        File(filePath).apply {
          // Ensure the directory exists
          parentFile?.mkdirs()
          deleteOnExit()
        }