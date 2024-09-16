import 'package:flutter_background_sync/utils/constant.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BeaconNotificationService {

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  AndroidNotificationChannel get _androidChannel => const AndroidNotificationChannel(
    Constant.channelId,
    Constant.channelName,
    description: Constant.channelDescription,
    importance: Importance.low, // importance must be at low or higher level
  );

  Future<void> createChannel() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
  }

  void show({String? title, String? body}) {
    _flutterLocalNotificationsPlugin.show(
      Constant.notificationId,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          Constant.channelId,
          Constant.channelName,
          channelDescription: Constant.channelDescription,
          icon: 'ic_bg_service_small',
          ongoing: true,
        ),
      ),
    );
  }
}