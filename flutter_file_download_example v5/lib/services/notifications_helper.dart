import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';

class NotificationsService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initializeNotifs() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android, iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification);
  }

  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    }
    // else {
    //   showDialog(
    //     context: context,
    //     builder: (_) => AlertDialog(
    //       title: Text('Error'),
    //       content: Text('${obj['error']}'),
    //     ),
    //   );
    // }
  }

  Future<void> showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: Priority.High, importance: Importance.Max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android, iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'File has been downloaded successfully!'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
  }
}
