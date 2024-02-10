import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final String id;
  final String imageUser;
  final String creditPostSuccess;
  final String creditOfferSuccess;
  final String creditOfferFailure;

  const ProfileScreen(
      {Key? key,
      required this.username,
      required this.id,
      required this.imageUser,
      required this.creditPostSuccess,
      required this.creditOfferSuccess,
      required this.creditOfferFailure})
      : super(key: key);

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
                    color: Colors.black, // สีของเส้นกรอบ
                    width: 3.0, // ความกว้างของเส้นกรอบ
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
                          style: TextStyle(fontSize: 19)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.blue),
                      const SizedBox(width: 5),
                      Text('ชื่อผู้ใช้: ${widget.username}',
                          style: TextStyle(fontSize: 19)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text('เครดิตการโพสต์',
                      style: TextStyle(
                          fontSize: 19,
                          color: Color.fromARGB(255, 124, 1, 124),
                          decoration: TextDecoration.underline)),
                  Text(
                    'แลกเปลี่ยนสำเร็จ : ${widget.creditPostSuccess}',
                    style: TextStyle(fontSize: 19),
                  ),
                  SizedBox(height: 20),
                  Text('เครดิตการยื่นข้อเสนอ',
                      style: TextStyle(
                          fontSize: 19,
                          color: Color.fromARGB(255, 124, 1, 124),
                          decoration: TextDecoration.underline)),
                  Text('แลกเปลี่ยนสำเร็จ : ${widget.creditOfferSuccess}',
                      style: TextStyle(fontSize: 19)),
                  Text('ถูกปฎิเสธ : ${widget.creditOfferFailure}', style: TextStyle(fontSize: 19)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
