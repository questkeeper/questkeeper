import Cocoa
import FlutterMacOS
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: FlutterAppDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
  override func applicationDidFinishLaunching(_ notification: Notification) {
    // Initialize Firebase first
    FirebaseApp.configure()
    
    // Set up messaging delegate before requesting permissions
    Messaging.messaging().delegate = self
    print("Firebase Messaging delegate set")

    // Set UNUserNotificationCenter delegate for notification handling
    UNUserNotificationCenter.current().delegate = self
    
    // Request authorization for notifications
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (granted, error) in
      if let error = error {
        print("Authorization failed: \(error.localizedDescription)")
      } else {
        print("Notification permission granted: \(granted)")
        // Only register for remote notifications if authorization was granted
        if granted {
          DispatchQueue.main.async {
            NSApplication.shared.registerForRemoteNotifications()
          }
        }
      }
    }

    super.applicationDidFinishLaunching(notification)
  }

  // Handle APNS registration failure
  override func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register for remote notifications: \(error.localizedDescription)")
  }

  // Handle APNS token registration
  override func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
    let token = tokenParts.joined()
    print("APNS token: \(token)")
    
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
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