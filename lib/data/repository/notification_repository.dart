import '../database/models/NotificationModel.dart';
import '../sources/notification_source.dart';

class NotificationRepository {
  NotificationRepository(this.source);

  final NotificationSource source;

  Future<List<NotificationModel>> getNotifications() {
    return source.getNotifications();
  }
}
