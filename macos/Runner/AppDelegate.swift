import Cocoa
import FlutterMacOS
import UserNotifications

@main
class AppDelegate: FlutterAppDelegate, UNUserNotificationCenterDelegate {
  override func applicationDidFinishLaunching(_ notification: Notification) {
    // Set UNUserNotificationCenter delegate for notification handling
    UNUserNotificationCenter.current().delegate = self
    
    // Request authorization for notifications
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (granted, error) in
      if let error = error {
        print("Authorization failed: \(error.localizedDescription)")
      } else {
        print("Notification permission granted: \(granted)")
      }
    }

    super.applicationDidFinishLaunching(notification)
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  // Handle incoming notifications
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
    completionHandler([.banner, .sound, .badge])
  }
}