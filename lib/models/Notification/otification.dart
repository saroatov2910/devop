// This class represents a notification for products in the app.
// Use this model to store and manage product-related notifications,
// such as expiration alerts or status updates.
class AppNotification {
  final String title; // Notification title (e.g., "Expiration Alert")
  final String body; // Main notification content/message
  final String message; // Additional details or custom message

  AppNotification({
    required this.title,
    required this.body,
    required this.message,
  });
}
