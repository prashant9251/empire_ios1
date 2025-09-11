import UIKit
import Flutter
import flutter_sharing_intent

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let methodChannel = FlutterMethodChannel(name: "shareIosUnique",
                           binaryMessenger: controller.binaryMessenger)
      methodChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
        if call.method == "shareToDirectWhatsappNo" {
          // Handle the method call from Flutter here
          guard
            let args = call.arguments as? [String: Any],
            let path = args["path"] as? String,
            let mobile = args["mobile"] as? String
          else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing path or mobile", details: nil))
            return
          }

          let fileURL = URL(fileURLWithPath: path)
          self.shareFileToWhatsApp(fileURL: fileURL, mobile: mobile, result: result)
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func shareFileToWhatsApp(fileURL: URL, mobile: String, result: @escaping FlutterResult) {
    let whatsappURLString = "whatsapp://send?phone=\(mobile)"
    guard let whatsappURL = URL(string: whatsappURLString) else {
      result(FlutterError(code: "INVALID_URL", message: "Cannot create WhatsApp URL", details: nil))
      return
    }

    let documentController = UIDocumentInteractionController(url: fileURL)
    documentController.uti = "net.whatsapp.image"
    documentController.annotation = ["WhatsAppCaption": ""]

    if documentController.presentOpenInMenu(from: CGRect.zero, in: UIApplication.shared.keyWindow!.rootViewController!.view, animated: true) {
      result(true)
    } else if UIApplication.shared.canOpenURL(whatsappURL) {
      UIApplication.shared.open(whatsappURL, options: [:], completionHandler: { success in
        result(success)
      })
    } else {
      result(FlutterError(code: "WHATSAPP_NOT_INSTALLED", message: "WhatsApp is not installed on this device", details: nil))
    }
    }
        
        
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

         let sharingIntent = SwiftFlutterSharingIntentPlugin.instance
         /// if the url is made from SwiftFlutterSharingIntentPlugin then handle it with plugin [SwiftFlutterSharingIntentPlugin]
         if sharingIntent.hasSameSchemePrefix(url: url) {
             return sharingIntent.application(app, open: url, options: options)
         }

         // Proceed url handling for other Flutter libraries like uni_links
         return super.application(app, open: url, options:options)
       }
}
