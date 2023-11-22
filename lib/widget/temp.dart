import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TabTemperature extends StatefulWidget {
  @override
  _TabTemperatureState createState() => _TabTemperatureState();
}

class _TabTemperatureState extends State<TabTemperature> {
  DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('/nhietdo');

  double? nhietdo;

  final DatabaseReference _databaseReference1 =
      FirebaseDatabase.instance.ref().child('/statusFire');

  int? statusFire;

  @override
  void initState() {
    super.initState();
    _setupStream();
  }

  void _setupStream() {
    _databaseReference.onValue.listen((event) {
      final dynamic data = event.snapshot.value;

      if (data != null) {
        setState(() {
          nhietdo = data.toDouble();
        });
      }
    });

    _databaseReference1.onValue.listen((event) {
      final dynamic data = event.snapshot.value;

      if (data == 0) {
        setState(() {
          _showFire();
        });
      }
    });
  }

  Future<void> _sound() async {
    Soundpool pool = Soundpool(streamType: StreamType.notification);

    int soundId = await rootBundle
        .load("assets/music/coi.mp3")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    int streamId = await pool.play(soundId);
  }

  void _showFire() {
    _sound();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content: const Text('Phát hiện rò rỉ khí gas!!'),
          actions: [
            TextButton(
              child: const Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double temperature = nhietdo ?? 0.0;

    return Column(
      children: [
        SizedBox(height: 24),
        SfLinearGauge(
          labelFormatterCallback: (label) {
            if (label == 0) {
              return 'Start';
            }
            if (label == 15) {
              return 'Cold';
            }
            if (label == 25) {
              return 'Cool';
            }
            if (label == 35) {
              return 'High';
            }
            if (label == 50) {
              return 'Very High';
            }
            return label.toString();
          },
          minimum: 0,
          maximum: 50,
          axisTrackStyle: LinearAxisTrackStyle(
            thickness: 20,
            edgeStyle: LinearEdgeStyle.bothCurve,
          ),
          markerPointers: [
            LinearShapePointer(
              shapeType: LinearShapePointerType.diamond,
              height: 25,
              width: 25,
              value: temperature,
            )
          ],
          orientation: LinearGaugeOrientation.vertical,
          ranges: <LinearGaugeRange>[
            LinearGaugeRange(startValue: 0, endValue: 15, color: Colors.green),
            LinearGaugeRange(startValue: 15, endValue: 25, color: Colors.blue),
            LinearGaugeRange(
                startValue: 25, endValue: 35, color: Colors.orange),
            LinearGaugeRange(startValue: 35, endValue: 50, color: Colors.red),
          ],
        ),
        SizedBox(height: 16),
        Text(
          'Nhiệt kế',
          style: TextStyle(
            color: Color.fromARGB(255, 128, 97, 4),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text('Temperature: $temperature'),
      ],
    );
  }
}
