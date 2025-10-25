import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant_app/utils/notification_helper.dart';

class ReminderProvider extends ChangeNotifier {
  static const _prefKey = 'isReminderActive';
  bool _isReminderActive = false;
  final NotificationHelper _notificationHelper = NotificationHelper();

  bool get isReminderActive => _isReminderActive;

  ReminderProvider() {
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isReminderActive = prefs.getBool(_prefKey) ?? false;

    if (_isReminderActive) {
      _notificationHelper.showDailyAt11AM();
    }
    notifyListeners();
  }

  Future<void> toggleReminder(bool value) async {
    _isReminderActive = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, _isReminderActive);

    if (_isReminderActive) {
      await _notificationHelper.showDailyAt11AM();
    } else {
      await _notificationHelper.cancelAll();
    }

    notifyListeners();
  }
}
