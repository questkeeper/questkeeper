import 'dart:async';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Stream controller to broadcast messages
  final _messageController = StreamController<String>.broadcast();
  Stream<String> get messageStream => _messageController.stream;

  // Method to add new messages
  void showMessage(String message) {
    _messageController.add(message);
  }

  void dispose() {
    _messageController.close();
  }
}
