package com.example.yapp

import io.flutter.embedding.android.FlutterActivity
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Environment
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream


class MainActivity: FlutterActivity()
{
    private val CHANNEL = "heic_converter"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "convertHeicToJpeg") {
                val heicPath = call.argument<String>("heicPath")
                val jpegPath = call.argument<String>("jpegPath")

                if (heicPath != null && jpegPath != null) {
                    val success = convertHeicToJpeg(heicPath, jpegPath)
                    if (success) {
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                } else {
                    result.error("INVALID_ARGUMENTS", "HEIC or JPEG path is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun convertHeicToJpeg(heicPath: String, jpegPath: String): Boolean {
        return try {
            val sourceFile = File(heicPath)
            val bitmap = BitmapFactory.decodeFile(sourceFile.absolutePath)

            val targetFile = File(jpegPath)
            val outputStream = FileOutputStream(targetFile)
            bitmap.compress(Bitmap.CompressFormat.JPEG, 90, outputStream)
            outputStream.flush()
            outputStream.close()

            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}
