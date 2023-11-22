import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:swapitem/14_HistroryMakeOffer.dart';
import 'package:swapitem/18_HistoryPayment.dart';

import '5_his_post.dart';
import '7_first_offer.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _genderController;
  late TextEditingController _birthdayController;
  Map dataUser = {};
  late User _user;
  late DatabaseReference _userRef;

  bool isTextFieldEnabled = false;
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _userRef = FirebaseDatabase.instance.ref().child('users').child(_user.uid);
    _firstNameController =
        TextEditingController(text: dataUser['firstname'].toString());
    _lastNameController =
        TextEditingController(text: dataUser['lastname'].toString());
    _genderController =
        TextEditingController(text: dataUser['gender'].toString());
    _birthdayController =
        TextEditingController(text: dataUser['birthday'].toString());
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _showSignOutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text(
            'ยืนยันการออกจากระบบ',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'คุณต้องการที่จะออกจากระบบหรือไม่?',
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'ยกเลิก',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      signOut();
                    },
                    child: Text(
                      'ยืนยัน',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ข้อมูลของฉัน"),
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
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder(
                  stream: _userRef.onValue,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 350,
                            ),
                            CircularProgressIndicator(),
                            Text('กำลังโหลดข้อมูล...')
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      DataSnapshot dataSnapshot = snapshot.data!.snapshot;
                      Map dataUser = dataSnapshot.value as Map;
                      _firstNameController.text =
                          dataUser['firstname'].toString();
                      _lastNameController.text =
                          dataUser['lastname'].toString();
                      _genderController.text = dataUser['gender'].toString();
                      _birthdayController.text =
                          dataUser['birthday'].toString();
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              child: ClipOval(
                                child: Image.network(
                                  dataUser['image_user'],
                                  width: 130,
                                  height: 130,
                                  fit: BoxFit
                                      .cover, // ให้รูปภาพปรับตามขนาดของ Container
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text: dataUser['id'].toString()),
                                    decoration: const InputDecoration(
                                        label: Text(
                                          "หมายเลขผู้ใช้งาน",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.tag)),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextField(
                                    controller: _firstNameController,
                                    decoration: const InputDecoration(
                                        label: Text(
                                          "ชื่อ",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.person)),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextField(
                                    controller: _lastNameController,
                                    decoration: InputDecoration(
                                        label: Text(
                                          "นามสกุล",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.person)),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextField(
                                    controller: _genderController,
                                    decoration: InputDecoration(
                                        label: Text(
                                          "เพศ",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.male)),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextField(
                                    controller: _birthdayController,
                                    decoration: InputDecoration(
                                        label: Text(
                                          "วันเกิด",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.date_range)),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text: dataUser['username'].toString()),
                                    decoration: InputDecoration(
                                        label: Text(
                                          "ชื่อผู้ใช้",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.person)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text: _user.email!),
                                    decoration: InputDecoration(
                                        label: Text(
                                          'อีเมล',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.email)),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Center(
                                    child: Container(
                                      width: 200,
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          Container(
                                            width: 250,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                _userRef.update({
                                                  'firstname':
                                                      _firstNameController.text,
                                                  'lastname':
                                                      _lastNameController.text,
                                                  'gender':
                                                      _genderController.text,
                                                  'birthday':
                                                      _birthdayController.text,
                                                }).then((value) {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'บันทึกข้อมูลสำเร็จ'),
                                                        actions: [
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: Colors.green,
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // ปิด AlertDialog
                                                            },
                                                            child: Text('ตกลง',style: TextStyle(color: Colors.white),),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 1, 135, 6),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize
                                                    .min, // กำหนดให้ Row มีขนาดเท่ากับเนื้อหา
                                                children: [
                                                  Icon(
                                                    Icons.save,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          8), // ระยะห่างระหว่างไอคอนและข้อความ
                                                  Text(
                                                    'บันทึกการแก้ไข',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 14,
                                          ),
                                          Container(
                                            width: 250,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OfferRequest(),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                              ),
                                              child: Text(
                                                'ข้อเสนอที่เข้ามา',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 14,
                                          ),
                                          Container(
                                            width: 250,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        HistoryPost(),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                              ),
                                              child: Text(
                                                'ประวัติการโพสต์',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 14,
                                          ),
                                          Container(
                                            width: 500,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        HistoryMakeOffer(),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                              ),
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'ประวัติการยื่นข้อเสนอ',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 14,
                                          ),
                                          Container(
                                            width: 250,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        HistoryPayment(),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                              ),
                                              child: Text(
                                                'ประวัติการชำระเงิน',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 14,
                                          ),
                                          Container(
                                            width: 250,
                                            child: ElevatedButton.icon(
                                              icon: const Icon(
                                                Icons.logout,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                _showSignOutConfirmationDialog();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              ),
                                              label: Text(
                                                'ออกจากระบบ',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSaveSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('บันทึกสำเร็จ')),
          content: Image.asset(
            'assets/images/checked.png',
            width: 50,
            height: 100,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิดหน้าต่าง
              },
              child: Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }
}
