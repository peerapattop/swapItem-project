import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(
            title: Text("โปรไฟล์ผู้ใช้"),
            toolbarHeight: 40,
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/image 40.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        body: Center(
          child: Text('Username: ${widget.username}'),
        ),
      ),
    );
  }
}
