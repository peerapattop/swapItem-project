import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '17_PaymentSuccess.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//หน้าแนปสลิปการโอนเงิน

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String? imageUrl;
  XFile? _imageFile;
  late List<String> package;
  late String dropdownValue;
  String status = 'รอการตรวจสอบ';
  String? paymentNumber;

  String generateFourDigitNumber() {
    var random = Random();
    int number = random.nextInt(10000); // สุ่มตัวเลขระหว่าง 0 ถึง 9999
    return number.toString().padLeft(4, '0'); // จัดรูปแบบให้เป็นสี่หลัก
  }

  void createRequestVip() async {
    
    // ดึง UID ของผู้ใช้ที่ล็อกอินอยู่
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DateTime now = DateTime.now();

    // ดึงข้อมูลผู้ใช้จาก Realtime Database
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').child(uid);
    DatabaseEvent userDataSnapshot = await userRef.once();

    //ตรวจสอบว่ามีข้อมูลผู้ใช้หรือไม่
    if (userDataSnapshot.snapshot.value != null) {
      Map<dynamic, dynamic> Datamap =
          userDataSnapshot.snapshot.value as Map<dynamic, dynamic>;
      String? firstname = Datamap['firstname'];
      String? lastname = Datamap['lastname'];
      String? email = Datamap['email'];
      String? username = Datamap['username'];
      String? id = Datamap['id'];

      // (เลือกแพ็คเก็จ)
      String selectedPackage = package.first;

      // ตรวจสอบว่า dropdownValue ไม่ใช่ null
      selectedPackage = dropdownValue;
      String fileName = 'payment_${DateTime.now().millisecondsSinceEpoch}.png';

      // อัปโหลดรูปภาพไปยัง Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('payment_images')
          .child(fileName);
      await storageRef.putFile(File(_imageFile?.path ?? ''));

      // ดึง UID ของเอกสารที่สร้างขึ้น
      DatabaseReference requestVipRef =
          FirebaseDatabase.instance.ref().child('requestvip');
      DatabaseReference newRequestRef = requestVipRef.push();
      String? documentId = newRequestRef.key;

      // ดึง URL ของรูปภาพที่อัปโหลด
      String imageUrl = await storageRef.getDownloadURL();
      String paymentNumber = generateFourDigitNumber();
      Map<String, dynamic> requestData = {
        'user_uid': uid,
        'status': status,
        'image_payment': imageUrl,
        'packed': selectedPackage,
        'PaymentNumber': paymentNumber,
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'username': username,
        'email': email,
        'vipuid': documentId,
        "date": now.year.toString() +
            "-" +
            now.month.toString().padLeft(2, '0') +
            "-" +
            now.day.toString().padLeft(2, '0'),
        "time": now.hour.toString().padLeft(2, '0') +
            ":" +
            now.minute.toString().padLeft(2, '0') +
            ":" +
            now.second.toString().padLeft(2, '0'),
      };

      // ทำการส่งข้อมูลไปยัง "requestvip" ใน Realtime Database
      await newRequestRef.set(requestData);

      print('UID ของเอกสารที่สร้าง: $documentId');
    } else {
      print('ไม่พบข้อมูลชื่อผู้ใช้');
    }
  }

  Future<void> _showPaymentConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text(
            'ยืนยันการชำระเงิน',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'คุณต้องการที่จะชำระเงินหรือไม่?',
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
                      createRequestVip();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentSuccess(
                                    date: DateTime.now(),
                                    time: DateTime.now(),
                                    
                                  )));
                    },
                    child: const Text(
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
  void initState() {
    super.initState();
    package = [
      'แพ็คเก็จ 1 เดือน : 50 บาท',
      'แพ็คเก็จ 2 เดือน : 100 บาท',
      'แพ็คเก็จ 3 เดือน : 150 บาท',
    ];
    dropdownValue = package.first;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("ชำระเงิน"),
          toolbarHeight: 40,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/image 40.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: Image.asset(
                    "assets/images/qrcodepromptpay.jpeg",
                    width: 225,
                    height: 225,
                  ),
                ),
              ),
              Text(
                'บริษัท ????????????? จำกัด',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              DropdownMenu<String>(
                width: 280,
                initialSelection: package.first,
                onSelected: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                dropdownMenuEntries:
                    package.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
              const SizedBox(
                height: 15,
              ),
              imgPayment(),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    _showPaymentConfirmationDialog(context);
                  },
                  child: Text(
                    "ชำระเงิน",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: source,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });

      Navigator.pop(context);
    }
  }

  Widget imgPayment() {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
                context: context, builder: ((Builder) => bottomSheet()));
          },
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(border: Border.all()),
            child: Center(
              child: _imageFile != null
                  ? Image.file(
                      File(_imageFile?.path ?? ''),
                      width: 350,
                      height: 350,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      'assets/images/add_slip.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "เลือกรูปภาพของคุณ",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: Icon(Icons.camera),
                label: Text('กล้อง'),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: Icon(Icons.camera),
                label: Text('แกลลอรี่'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
