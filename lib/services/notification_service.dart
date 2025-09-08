import '../models/products/product.dart';
import '../models/Notification/otification.dart';

class NotificationService {
  static List<AppNotification> getExpiringProductNotifications(
    List<Product> products, {
    int days = 3,
  }) {
    final now = DateTime.now();
    return products
        .where((product) {
          final daysSinceExpired = now
              .difference(product.expirationDate)
              .inDays;
          return product.expirationDate.isBefore(now) &&
              daysSinceExpired <= days &&
              daysSinceExpired >= 0;
        })
        .map(
          (product) => AppNotification(
            title: "Expiration Alert",
            body:
                "המוצר '${product.name}' עומד לפוג תוקף בעוד ${product.expirationDate.difference(now).inDays} ימים.",
            message:
                "תוקף עד: ${product.expirationDate.toLocal().toString().split(' ')[0]}",
          ),
        )
        .toList();
  }
}
