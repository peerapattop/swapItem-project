import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('gg'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('gg'),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0, right: 24.0),
            child: Text('gg'),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 16.0, 24.0, 32.0),
            child: Text('gg'),
          )
        ],
      ),
    );
  }
}


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('TextButton Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  // การกด TextButton จะเรียกฟังก์ชันนี้
                  print('TextButton Pressed');
                },
                child: Text(
                  'กดที่นี่',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
