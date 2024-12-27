import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
          _ application: UIApplication,
          didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
      ) -> Bool {
          let controller = window?.rootViewController as! FlutterViewController
          let channel = FlutterMethodChannel(name: "heic_converter", binaryMessenger: controller.binaryMessenger)

          channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
              if call.method == "convertHeicToJpeg" {
                  guard let args = call.arguments as? [String: String],
                        let heicPath = args["heicPath"],
                        let jpegPath = args["jpegPath"] else {
                      result(FlutterError(code: "INVALID_ARGUMENTS", message: "HEIC or JPEG path missing", details: nil))
                      return
                  }

                  let success = HeicConverter.convertHeicToJpeg(heicPath: heicPath, jpegPath: jpegPath)
                  result(success)
              } else {
                  result(FlutterMethodNotImplemented)
              }
          }

          GeneratedPluginRegistrant.register(with: self)
          return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      }
}

@objc class HeicConverter: NSObject {
    static func convertHeicToJpeg(heicPath: String, jpegPath: String) -> Bool {
        do {
            // Load the HEIC image
            guard let image = UIImage(contentsOfFile: heicPath) else {
                print("Failed to load HEIC image.")
                return false
            }

            // Convert to JPEG data
            guard let jpegData = image.jpegData(compressionQuality: 0.9) else {
                print("Failed to convert HEIC to JPEG.")
                return false
            }

            // Write the JPEG data to the specified path
            try jpegData.write(to: URL(fileURLWithPath: jpegPath))
            return true
        } catch {
            print("Error during HEIC to JPEG conversion: \(error)")
            return false
        }
    }
}