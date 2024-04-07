import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final String id;
  final String imageUser;
  late final String creditPostSuccess;
  late final String creditOfferSuccess;
  late final String totalOffer;
  late final String totalPost;

  ProfileScreen({
    Key? key,
    required this.username,
    required this.id,
    required this.imageUser,
    required this.creditPostSuccess,
    required this.creditOfferSuccess,
    required this.totalOffer,
    required this.totalPost,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map postData = {};

  @override
  void initState() {
    fetchUserData();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("โปรไฟล์ผู้ใช้"),
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 3.0,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    widget.imageUser,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.tag, color: Colors.blue),
                      const SizedBox(width: 5),
                      Text('หมายเลขผู้ใช้ : ${widget.id}',
                          style: const TextStyle(fontSize: 19)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.blue),
                      const SizedBox(width: 5),
                      Text('ชื่อผู้ใช้: ${widget.username}',
                          style: const TextStyle(fontSize: 19)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'เครดิตของผู้ใช้งาน',
                    style: TextStyle(
                        fontSize: 19,
                        color: Color.fromARGB(255, 124, 1, 124),
                        decoration: TextDecoration.underline),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'จำนวนการโพสต์ฺ : ${widget.totalPost}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Text(
                    'อัตราการแลกเปลี่ยนสำเร็จ',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  widget.totalPost == '0'
                      ? Container(
                          height: 30,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Text(
                              "ไม่มีข้อมูล",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      : slideBar(int.parse(widget.totalPost),
                          int.parse(widget.creditPostSuccess)),
                  const SizedBox(height: 30),
                  Text(
                    'จำนวนการยื่นข้อเสนอ : ${widget.totalOffer}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Text(
                    'อัตราการแลกเปลี่ยนสำเร็จ',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  widget.totalOffer == '0'
                      ? Container(
                          height: 30,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Text(
                              "ไม่มีข้อมูล",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      : slideBar(int.parse(widget.totalOffer),
                          int.parse(widget.creditOfferSuccess)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void fetchUserData() {
    FirebaseDatabase.instance
        .ref('users/${widget.id}')
        .once()
        .then((databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(databaseEvent.snapshot.value as Map);
        String id = userData['id'];
        String creditPostSuccess = userData['creditPostSuccess'].toString();
        String creditOfferSuccess = userData['creditOfferSuccess'].toString();
        String totalOffer = userData['totalOffer'].toString();
        String totalPost = userData['totalPost'].toString();
        widget.creditPostSuccess = creditPostSuccess;
        widget.creditOfferSuccess = creditOfferSuccess;
        widget.totalOffer = totalOffer;
        widget.totalPost = totalPost;
      } else {
        print('ไม่พบข้อมูลผู้ใช้');
      }
    }).catchError((error) {
      print('เกิดข้อผิดพลาดในการดึงข้อมูลผู้ใช้: $error');
    });
  }

  Widget slideBar(int totalPost, int creditPostSuccess) {
    double percentage = creditPostSuccess / totalPost;
    double containerWidth = 300;

    return Container(
      height: 40.0,
      width: containerWidth,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
          width: 1,
        ),
        color: Colors.grey[200],
      ),
      child: Stack(
        children: [
          Positioned(
            child: Container(
              width: containerWidth * percentage,
              color: Colors.green,
            ),
          ),
          Center(
            child: Text(
              '${(percentage * 100).toStringAsFixed(2)}%', // แก้ไขตรงนี้
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
