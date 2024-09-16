import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_sync/beacon/beacon_manager.dart';
import 'package:flutter_background_sync/service/beacon_background_service.dart';
import 'package:flutter_background_sync/service/beacon_notification_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.location.request();
  await Permission.notification.request();
  await requestBluetoothPermissions();
  runApp(const MyApp());
}

Future<void> requestBluetoothPermissions() async {
  if (await Permission.bluetooth.isDenied) {
    await Permission.bluetooth.request();
  }
  if (await Permission.bluetoothScan.isDenied) {
    await Permission.bluetoothScan.request();
  }
  if (await Permission.bluetoothConnect.isDenied) {
    await Permission.bluetoothConnect.request();
  }
  if (await Permission.location.isDenied) {
    await Permission.location.request();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Background Sync',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final BeaconBackgroundService beaconBackgroundService = BeaconBackgroundService(
    notificationService: BeaconNotificationService(),
    beaconManager: BeaconManager(),
  );

  @override
  void initState() {
    super.initState();
    configureService();
  }

  void configureService() async {
    await beaconBackgroundService.configure();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Beacon Scanning")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Stop Service"),
          onPressed: () {
            beaconBackgroundService.stop();
          },
        ),
      ),
    );
  }
}

