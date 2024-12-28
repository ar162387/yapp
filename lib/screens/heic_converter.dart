import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class HeicToJpegConverter {
  static const MethodChannel _channel = MethodChannel('heic_converter');

  /// Converts a HEIC file to JPEG and rotates it to correct orientation if needed.
  static Future<File?> convert(File heicFile) async {
    try {
      // Convert HEIC to JPEG using native code
      final tmpDir = (await getTemporaryDirectory()).path;
      final jpegPath = '$tmpDir/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final bool success = await _channel.invokeMethod('convertHeicToJpeg', {
        'heicPath': heicFile.path,
        'jpegPath': jpegPath,
      });

      if (!success) {
        return null;
      }

      // Load the converted JPEG
      final jpegFile = File(jpegPath);
      final img.Image? originalImage = img.decodeImage(jpegFile.readAsBytesSync());

      if (originalImage == null) {
        print("Error decoding JPEG image.");
        return null;
      }

      // Rotate the image 90 degrees counterclockwise
      final img.Image correctedImage = img.copyRotate(originalImage,  angle: 90);

      // Save the rotated image back to the file
      jpegFile.writeAsBytesSync(img.encodeJpg(correctedImage));

      return jpegFile;
    } catch (e) {
      print("Error converting HEIC to JPEG: $e");
      return null;
    }
  }
}
