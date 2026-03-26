import Flutter
import UIKit
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GeneratedPluginRegistrant.register(with: self)

    // Get Flutter controller
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

    // Create MethodChannel
    let channel = FlutterMethodChannel(
        name: "music_widget",
        binaryMessenger: controller.binaryMessenger
    )

    // Listen for Flutter calls
    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in

        if call.method == "updateWidget" {

            if let args = call.arguments as? [String: Any] {

              
                let title = args["title"] as? String ?? ""
                let artist = args["artist"] as? String ?? ""
                let art = args["art"] as? String ?? ""

                // Shared storage (App Groups)
                let defaults = UserDefaults(
                    suiteName: "group.MusixWidget"
                )

                defaults?.set(title, forKey: "title")
                defaults?.set(artist, forKey: "artist")
                defaults?.set(art, forKey: "art")

                // Refresh widget
                if #available(iOS 14.0, *) {
                    WidgetCenter.shared.reloadAllTimelines()
                } else {
                    // Fallback on earlier versions
                }

                result(true)
            }

        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
