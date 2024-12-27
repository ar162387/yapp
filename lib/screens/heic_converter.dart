import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class HeicToJpegConverter {
  static const MethodChannel _channel = MethodChannel('heic_converter');

  static Future<File?> convert(File heicFile) async {
    try {
      final tmpDir = (await getTemporaryDirectory()).path;
      final jpegPath = '$tmpDir/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final bool success = await _channel.invokeMethod('convertHeicToJpeg', {
        'heicPath': heicFile.path,
        'jpegPath': jpegPath,
      });

      if (success) {
        return File(jpegPath);
      } else {
        return null;
      }
    } catch (e) {
      print("Error converting HEIC to JPEG: $e");
      return null;
    }
  }
}
