import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../database/models/NotificationModel.dart';

class NotificationSource {
  Future<List<NotificationModel>> getNotifications() async {
    final Database db = await DatabaseHelper.instance.database;
    final result = await db.query('Notification', orderBy: 'id DESC');
    return result.map(NotificationModel.fromMap).toList();
  }
}
