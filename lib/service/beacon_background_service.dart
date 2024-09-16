import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_sync/beacon/beacon_manager.dart';
import 'package:flutter_background_sync/service/beacon_notification_service.dart';
import 'package:flutter_background_sync/utils/constant.dart';

class BeaconBackgroundService {

  final BeaconNotificationService notificationService;

  final BeaconManager beaconManager;

  BeaconBackgroundService({required this.notificationService, required this.beaconManager});

  final _service = FlutterBackgroundService();

  Timer? _timer;

  int _timerDuration = 10;

  bool _enablePeriodic = false;

  bool _isRunning = false;

  Future<void> configure({int timerDuration = 10, bool enablePeriodic = false}) async {
    _timerDuration = timerDuration;
    _enablePeriodic = enablePeriodic;

    // create notification channel
    await notificationService.createChannel();
    _isRunning = await _service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: _onStart,
        // auto start service
        autoStart: true,
        isForegroundMode: true,
        foregroundServiceTypes: [
          AndroidForegroundType.location,
        ],
        notificationChannelId: Constant.channelId,
        initialNotificationTitle: Constant.channelName,
        initialNotificationContent: 'Scanning for beacons...',
        foregroundServiceNotificationId: Constant.notificationId,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: _onStart,
        onBackground: _onIosBackground,
      ),
    );
  }

  void _onStart(ServiceInstance service) async {

    service.on('stopService').listen((event) {
      if (_timer != null){
        _timer?.cancel();
      }
      service.stopSelf();
      _isRunning = false;
    });

    // Set periodic actions if needed
    if (_enablePeriodic) {
      _timer = Timer.periodic(Duration(seconds: _timerDuration), (timer) async {
        // Perform your periodic task here (e.g., update UI or scan beacons)
        _startBeacon();
        /*if (service is AndroidServiceInstance) {
          if (await service.isForegroundService()) {

          }
        }*/
      });
    } else {
      _startBeacon();
    }
  }

  void _startBeacon() async {
    beaconManager.enableBackgroundScan();
    await beaconManager.startMonitoring();
    beaconManager.startListening((data) {
      notificationService.show(
        title: data,
        body: "Updated at ${DateTime.now()}",
      );
    });
  }

  @pragma('vm:entry-point')
  Future<bool> _onIosBackground(ServiceInstance service) async {
    // Beacon scanning logic for iOS
    return true;
  }

  void stop(){
    _service.invoke("stopService");
  }

  bool isServiceRunning() => _isRunning;
}