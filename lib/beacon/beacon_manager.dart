import 'dart:async';
import 'dart:io';

import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:flutter/foundation.dart';

class BeaconManager {

  final StreamController<String> _beaconEventsController = StreamController<String>.broadcast();

  Future<void> startMonitoring() async {
    if (Platform.isAndroid) {
      BeaconsPlugin.channel.setMethodCallHandler((call) async {
        if (call.method == 'scannerReady') {
          await BeaconsPlugin.startMonitoring();
        }
      });
    } else if (Platform.isIOS) {
      await BeaconsPlugin.startMonitoring();
    }
  }

  void startListening(Function(String data) callback){
    BeaconsPlugin.listenToBeacons(_beaconEventsController);
    _beaconEventsController.stream.listen((data) {
        if (data.isNotEmpty) {
          callback(data);
          if (kDebugMode) {
            print("Beacons Data Received: $data");
          }
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print("Error: $error");
        }
      },
    );
  }

  Future<void> enableBackgroundScan() async {
    // Enable beacon scanning in the background
    await BeaconsPlugin.runInBackground(true);
  }

  Future<void> disableBackgroundScan() async {
    // Disable beacon scanning in the background
    await BeaconsPlugin.runInBackground(false);
  }

  void stopListening(){
    _beaconEventsController.close();
  }
}