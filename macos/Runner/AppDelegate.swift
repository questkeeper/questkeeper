import Cocoa
import FlutterMacOS
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: FlutterAppDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
  override func applicationDidFinishLaunching(_ notification: Notification) {
    // Initialize Firebase
    FirebaseApp.configure()

    // Register for remote notifications
    NSApplication.shared.registerForRemoteNotifications()

    // Set UNUserNotificationCenter delegate for notification handling
    UNUserNotificationCenter.current().delegate = self
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (granted, error) in
      if let error = error {
        print("Authorization failed: \(error.localizedDescription)")
      } else {
        print("Notification permission granted: \(granted)")
      }
    }

    Messaging.messaging().delegate = self

    super.applicationDidFinishLaunching(notification)
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  // Handle APNS token registration
  override func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  // Handle incoming remote notifications
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    print("Notification received: \(response.notification.request.content.userInfo)")
    completionHandler()
  }

  // Handle foreground notifications
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    print("Foreground notification received: \(notification.request.content.userInfo)")
    completionHandler([.banner, .sound, .badge])  // Make sure to use macOS-specific options
  }

  // Handle FCM token updates
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("FCM Token: \(fcmToken ?? "No Token")")
    // Optionally, send the token back to Flutter via a MethodChannel
  }
}