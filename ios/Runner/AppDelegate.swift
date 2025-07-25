import FirebaseCore
import FirebaseMessaging
import Flutter
import UIKit
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var flutterChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
    }

    application.registerForRemoteNotifications()
    Messaging.messaging().delegate = self

    // Set up method channel to communicate with Flutter
    let controller = window?.rootViewController as! FlutterViewController
    flutterChannel = FlutterMethodChannel(
      name: "app.questkeeper/data",
      binaryMessenger: controller.binaryMessenger
    )

    // Handle method calls from Flutter
    flutterChannel?.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "reloadWidgets" {
        if #available(iOS 14.0, *) {
          WidgetCenter.shared.reloadAllTimelines()
        }
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Handle data-only messages
  override func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    // Forward the message to Flutter
    if let messageData = userInfo as? [String: Any] {
      flutterChannel?.invokeMethod("onDataMessage", arguments: messageData)
    }

    Messaging.messaging().appDidReceiveMessage(userInfo)
    completionHandler(.newData)
  }
}

extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    flutterChannel?.invokeMethod("onToken", arguments: fcmToken)
  }
}
