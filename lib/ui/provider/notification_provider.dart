import 'package:flutter/material.dart';

import '../../data/database/models/NotificationModel.dart';
import '../../data/repository/notification_repository.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationProvider(this.repository);

  final NotificationRepository repository;

  bool isLoading = false;
  String? errorMessage;
  List<NotificationModel> notifications = [];

  Future<void> loadNotifications() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      notifications = await repository.getNotifications();
    } catch (e) {
      errorMessage = 'Không thể tải thông báo';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
