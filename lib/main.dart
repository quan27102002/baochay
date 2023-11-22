import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ptit/alert.dart';
import 'package:ptit/firebase_options.dart';
import 'package:ptit/widget/hum.dart';
import 'package:ptit/widget/temp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.thermostat)),
                Tab(icon: Icon(Icons.thunderstorm_outlined)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
            title: const Text('Quản lý hệ thống'),
          ),
          body: TabBarView(
            children: [
              TabTemperature(),
              wigetWet(),
              Setting(),
            ],
          ),
        ),
      ),
    );
  }
}
