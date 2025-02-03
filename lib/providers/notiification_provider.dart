
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waw/models/notification/notification_model.dart';

import '../../rest/rest_client_provider.dart';

final notificationProvider = ChangeNotifierProvider<NotificationProvider>(
      (ref) => NotificationProvider(ref),
);

class NotificationProvider extends ChangeNotifier {
  NotificationProvider(this._ref)
      : _restClient = _ref.read(restClientProvider) {
    // getDepartmentList();
  }

  final Ref _ref;
  final RestClient _restClient;


  List<NotificationModel> _notificationList = [];
  List<NotificationList> _allNotificationList = [];

  List<NotificationList> get allNotificationListState => _allNotificationList;

  Future<NotificationModel> getAllNotification() async {
    try {
      final response = await _restClient.getAllNotifications();
      if (kDebugMode) {
        print("API Response: $response");
      }

      final allNotification = NotificationModel.fromJson(response);

      _allNotificationList = allNotification.data ?? [];
      notifyListeners();

      return allNotification;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error occurred: $e");
        print("StackTrace: $stackTrace");
      }

      return NotificationModel(data: []);
    }
  }
}