import 'package:firebase_auth/firebase_auth.dart';
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
  final user = FirebaseAuth.instance.currentUser!;

  bool isTextFieldEnabled = false;
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: Image.asset("assets/images/pramepree.png"),
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
                        controller: TextEditingController(text: "0001"),
                        decoration: const InputDecoration(
                            label: Text(
                              "หมายเลขผู้ใช้งาน",
                              style: TextStyle(fontSize: 20),
                            ),
                            border: OutlineInputBorder(),
                            enabled: false,
                            prefixIcon: Icon(Icons.tag)),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: TextEditingController(text: "เปรมปรี"),
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
                        controller: TextEditingController(text: "เวินไธสง"),
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
                        controller: TextEditingController(text: "ชาย"),
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
                        controller:
                            TextEditingController(text: "14 กันยายน 2566"),
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
                        controller: TextEditingController(text: "Pramepree"),
                        decoration: InputDecoration(
                            label: Text(
                              "ชื่อผู้ใช้",
                              style: TextStyle(fontSize: 20),
                            ),
                            border: OutlineInputBorder(),
                            enabled: false,
                            prefixIcon: Icon(Icons.person)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: TextEditingController(text: user.email!),
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
                      TextField(
                        controller: TextEditingController(text: "+5fsdfdsf*-0"),
                        decoration: InputDecoration(
                            label: Text(
                              "รหัสผ่าน",
                              style: TextStyle(fontSize: 20),
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.password)),
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
                                    showSaveSuccessDialog(
                                        context); // แสดงหน้าต่างบันทึกสำเร็จ
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 1, 135, 6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize
                                        .min, // กำหนดให้ Row มีขนาดเท่ากับเนื้อหา
                                    children: [
                                      Icon(
                                        Icons.save,
                                        color: Colors.white,
                                      ), // ไอคอน "บันทึก"
                                      SizedBox(
                                          width:
                                              8), // ระยะห่างระหว่างไอคอนและข้อความ
                                      Text(
                                        'บันทึกการแก้ไข',
                                        style: TextStyle(
                                          fontSize: 18,
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
                                        builder: (context) => OfferRequest(),
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
                                        builder: (context) => HistoryPost(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
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
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'ประวัติการยื่นข้อเสนอ',
                                          style: TextStyle(
                                              fontSize: 18,
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
                                        builder: (context) => HistoryPayment(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                  ),
                                  child: Text(
                                    'ประวัติการชำระเงิน',
                                    style: TextStyle(fontSize: 18,color: Colors.white,),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 14,
                              ),
                              Container(
                                width: 250,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.logout,color: Colors.white,),
                                  onPressed: () {
                                    _showSignOutConfirmationDialog();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    
                                  ),
                                  label: Text(
                                    'ออกจากระบบ',
                                    style: TextStyle(fontSize: 18,color: Colors.white,),
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
          ),
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
