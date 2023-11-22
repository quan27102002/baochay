import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseReference _databaseReference1 =
      FirebaseDatabase.instance.ref().child('/nhietdo');
  final DatabaseReference _databaseReference2 =
      FirebaseDatabase.instance.ref().child('/doam');
  final DatabaseReference _databaseReference3 =
      FirebaseDatabase.instance.ref().child('/statusFire');

  int? statusFire;
  int? nhietdo;
  int? doam;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() {
    _databaseReference1.onValue.listen((event) {
      final dynamic data1 = event.snapshot.value;

      if (data1 != null) {
        setState(() {
          nhietdo = data1;
        });
      }
    });

    _databaseReference2.onValue.listen((event) {
      final dynamic data2 = event.snapshot.value;
      setState(() {
        doam = data2;
      });
    });
    _databaseReference3.onValue.listen((event) {
      final dynamic data3 = event.snapshot.value;
      setState(() {
        statusFire = data3;
        if (statusFire == 0) {
          _showFire;
          // Hiển thị dialog khi gas = 1
        }
      });
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

  void _showDialogC0() {
    _sound();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content: const Text('Phát hiện có cháy!!'),
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
    String t = nhietdo.toString();
    String h = doam.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quản lý hệ thống',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            // Màu chữ
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [
            0.1,
            0.4,
            0.6,
            0.9,
          ],
          colors: [
            Colors.yellow,
            Colors.red,
            Colors.indigo,
            Colors.teal,
          ],
        )),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Nhiệt độ: $t" + "°C",
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      // Màu chữ
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Độ ẩm : $h" + "%",
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      // Màu chữ
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
