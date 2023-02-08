import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    UMConfigure.setLogEnabled(true)
    UMConfigure.initWithAppkey("62a0045088ccdf4b7e8b255f", channel: "keysight")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        UMessage.registerDeviceToken(deviceToken);
        print("the UMeng token is \(deviceToken.map({String(format: "%02x", $0)}).joined())")
    }
}
