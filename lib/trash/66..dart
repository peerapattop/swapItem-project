import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';

class DetailItem extends StatelessWidget {
  final String postId;
  final DatabaseReference _postRef =
      FirebaseDatabase.instance.ref().child('postitem');

  DetailItem({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("รายละเอียดสินค้า"),
          // ... ส่วนที่เหลือของ UI ...
        ),
        body: FutureBuilder<DatabaseEvent>(
          future: _getPostData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (snapshot.hasData) {
              // ใช้ข้อมูลที่ดึงมาที่นี่
              // ตัวอย่าง: แสดงข้อมูลของสินค้า
              return Text("ข้อมูลสินค้า: ${snapshot.data!.snapshot.value}");
            }
            return Center(child: Text("ไม่พบข้อมูล"));
          },
        ),
      ),
    );
  }

  Future<DatabaseEvent> _getPostData() async {
    return await _postRef.orderByChild("postId").equalTo(postId).once();
  }
}
