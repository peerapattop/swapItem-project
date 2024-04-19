import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:swapitem/13_MakeAnOfferSuccess.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class MakeAnOffer extends StatefulWidget {
  final String postUid;
  final String username;
  final String imageUser;
  final String uidUserpost;
  const MakeAnOffer(
      {Key? key,
      required this.postUid,
      required this.uidUserpost,
      required this.username,
      required this.imageUser})
      : super(key: key);

  @override
  State<MakeAnOffer> createState() => _MakeAnOfferState();
}

List<String> category = <String>[
  'กรุณาเลือกชนิดสิ่งของ',
  'เสื้อผ้าแฟชั่นผู้ชาย',
  'เสื้อผ้าแฟชั่นผู้หญิง',
  'กระเป๋า',
  'รองเท้าผู้ชาย',
  'รองเท้าผู้หญิง',
  'นาฬิกาและแว่นตา',
  'เครื่องใช้ในบ้าน',
  'มือถือและอุปกรณ์เสริม',
  'เครื่องใช้ไฟฟ้าภายในบ้าน',
  'กล้องและอุปกรณ์ถ่ายภาพ',
  'คอมพิวเตอร์และอุปกรณ์เสริม',
  'ของเล่น สินค้าแม่และเด็ก',
  'เครื่องเขียน หนังสือ และงานอดิเรก',
  'อุปกรณ์กีฬา',
  'อื่นๆ',
];
String dropdownValue = category.first;

class _MakeAnOfferState extends State<MakeAnOffer> {
  String timeclick = '';
  final _nameItem1 = TextEditingController();
  final _brand1 = TextEditingController();
  final _model1 = TextEditingController();
  final _detail1 = TextEditingController();
  final picker = ImagePicker();
  DateTime now = DateTime.now();
  String? username;
  late int offerNumber;
  String date1 ='';
  String time1 ='';

  List<File> _images = [];

  @override
  void initState() {
    super.initState();
    dropdownValue = category.first;
    fetchTimestampFromFirebase();
    saveTimestampToFirebase(); //ให้ firsebase เอาเวลามาให้
  }

  @override
  Widget build(BuildContext context) {
    void removeImage(int index) {
      setState(() {
        _images.removeAt(index);
      });
    }

     date1 =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
     time1 =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ยื่นข้อเสนอ"),
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
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, right: 2, left: 2, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    width: 370,
                    height: 280,
                    child: Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.camera_alt),
                                            onPressed: _images.length < 5
                                                ? takePicture
                                                : null,
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.image),
                                            onPressed: _images.length < 5
                                                ? chooseImages
                                                : null,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Stack(
                                      children: [
                                        Image.file(
                                          _images[index - 1],
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () =>
                                                removeImage(index - 1),
                                          ),
                                        ),
                                      ],
                                    ); // Display the selected images with delete button
                            },
                            itemCount: _images.length + 1,
                          ),
                        ),
                        Text(
                          '${_images.length}/5',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 17),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Colors.grey,
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    underline: Container(),
                    items:
                        category.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 17),
                TextField(
                  controller: _nameItem1,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อสิ่งของ',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.shopping_bag),
                  ),
                ),
                const SizedBox(height: 17),
                TextField(
                  controller: _brand1,
                  decoration: const InputDecoration(
                    labelText: 'ยี่ห้อ',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.branding_watermark),
                  ),
                ),
                const SizedBox(height: 17),
                TextField(
                  controller: _model1,
                  decoration: const InputDecoration(
                    labelText: 'รุ่น', // Label text
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.model_training),
                  ),
                ),
                const SizedBox(height: 17),
                TextField(
                  controller: _detail1,
                  decoration: const InputDecoration(
                    labelText: 'รายละเอียด', // Label text
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.details),
                  ),
                  maxLines: null, // Allows for multi-line input
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await submitOffer();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    child: const Text(
                      "ยิ่นข้อเสนอ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  takePicture() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  chooseImages() async {
    List<XFile> pickedFiles = await picker.pickMultiImage();
    setState(() {
      _images.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
    });
  }

  int generateRandomNumber() {
    Random random = Random();
    String randomNumber = '';

    for (int i = 0; i < 5; i++) {
      randomNumber += random.nextInt(10).toString();
    }

    return int.parse(randomNumber);
  }

  Future<void> updateTotalOffer() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').child(user!.uid);
    DatabaseEvent event = await userRef.once();
    Map<dynamic, dynamic>? datamap = event.snapshot.value as Map?;
    if (datamap != null) {
      int totalOffer = int.tryParse(datamap['totalOffer'].toString()) ?? 0;
      totalOffer++;
      await userRef.update({
        'totalOffer': totalOffer,
      });
    } else {
      print('User data not found');
    }
  }

  Future<bool> _showOfferConfirmationDialog() async {
    Completer<bool> completer = Completer<bool>();

    if (_nameItem1.text.isEmpty ||
        _brand1.text.isEmpty ||
        _model1.text.isEmpty ||
        _detail1.text.isEmpty ||
        _images.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'แจ้งเตือน',
              style: TextStyle(color: Colors.red),
            ),
            content: const Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'ตกลง',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
      return false;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text(
            'ยืนยันการยื่นข้อเสนอ',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'คุณต้องการที่ยืนยันการยื่นข้อเสนอหรือไม่?',
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
                      completer.complete(false); // User canceled
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
                      saveTimestampToFirebase();
                      fetchTimestampFromFirebase();
                      completer.complete(true);
                      Navigator.pop(context);
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

    return completer.future;
  }

  Future<void> submitOffer() async {
    try {
      bool confirmed = await _showOfferConfirmationDialog();

      if (confirmed) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("กำลังยื่นข้อเสนอ..."),
                ],
              ),
            );
          },
        );

        String uid = FirebaseAuth.instance.currentUser!.uid;
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child('users').child(uid);
        DatabaseEvent userDataSnapshot = await userRef.once();
        Map<dynamic, dynamic> datamap =
            userDataSnapshot.snapshot.value as Map<dynamic, dynamic>;
        int currentOfferCount = datamap['makeofferCount'] as int? ?? 0;
        String? username = datamap['username'];

        if (currentOfferCount > 0 || canPostAfter30Days(userRef, datamap)) {
          // ลดค่า postCount
          if (currentOfferCount > 0) {
            await userRef.update({
              'makeofferCount': currentOfferCount - 1,
              'lastOfferDate': DateTime.now().toString(),
            });
          }
        updateTotalOffer();



          String postUid = widget.postUid;
          String imageUser = widget.imageUser;

          String uid = FirebaseAuth.instance.currentUser!.uid;
          DatabaseReference itemRef =
              FirebaseDatabase.instance.ref().child('offer').push();
          String? offerUid = itemRef.key;
          // First, upload images and collect their URLs.
          List<String> imageUrls = await _uploadImages();
          offerNumber = generateRandomNumber();
          Map<String, dynamic> dataRef = {
            'username': username,
            'imageUser': imageUser,
            'statusOffers': 'ยังไม่ถูกเลือก',
            'offer_uid': offerUid,
            'offerNumber': offerNumber,
            'uid': uid,
            'time': exampleUsageTime(),
            'date': exampleUsage(),
            'uidUserpost': widget.uidUserpost,
            'type1': dropdownValue,
            'nameitem1': _nameItem1.text.trim(),
            'brand1': _brand1.text.trim(),
            'model1': _model1.text.trim(),
            'detail1': _detail1.text.trim(),
            'imageUrls': imageUrls,
            'timestamp': timeclick,
            'post_uid': postUid,
          };

          await itemRef.set(dataRef);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  MakeAnOfferSuccess(
                    date: date1,
                    time: time1,
                    offerNumber: offerNumber,
                  ),
            ),
          );

        }
      }
    } catch (error) {
      Navigator.pop(context);
    }
  }

  String exampleUsage() {
    // สร้าง Timestamp จาก Firebase Firestore
    Timestamp firestoreTimestamp = Timestamp.now();
    DateTime dateTime = firestoreTimestamp.toDate();
    print('ghjo');
    print(dateTime);
    // สร้างโซนเวลาของเอเชีย (Asia/Bangkok)
    DateTime asiaTime = dateTime.toUtc().add(Duration(hours: 7));

    // สร้างรูปแบบการแสดงวันที่และเวลาภาษาไทย
    var formatter = DateFormat('EEEE, dd MMMM yyyy', 'th_TH');
    String formattedDate = formatter.format(asiaTime);

    // แสดงผลลัพธ์เป็น Widget Text
    return formattedDate;
  }

  String exampleUsageTime() {
    // สร้าง Timestamp จาก Firebase Firestore
    Timestamp firestoreTimestamp = Timestamp.now();
    DateTime dateTime = firestoreTimestamp.toDate();
    print('ghjo');
    print(dateTime);
    // สร้างโซนเวลาของเอเชีย (Asia/Bangkok)
    DateTime asiaTime = dateTime.toUtc().add(Duration(hours: 7));

    // สร้างรูปแบบการแสดงวันที่และเวลาภาษาไทย
    var formatter = DateFormat('EEEE, dd MMMM yyyy HH:mm:ss', 'th_TH');

    String formattedTime = formatter.format(asiaTime);
    var formattedDate1 = formattedTime.split(' ');
    // แสดงผลลัพธ์เป็น Widget Text
    return formattedDate1[4];
  }

  bool canPostAfter30Days(
      DatabaseReference userRef, Map<dynamic, dynamic> userData) {
    // Check if last post date is available
    if (userData.containsKey('lastOfferDate')) {
      DateTime lastOfferDate =
          DateTime.parse(userData['lastOfferDate'].toString());
      DateTime currentDate = DateTime.now();

      // Check if 30 days have passed since the last post
      if (currentDate.difference(lastOfferDate).inDays >= 30) {
        // Reset post count and update last post date
        userRef.set({
          'makeofferCount': 5,
          'lastOfferDate': currentDate.toIso8601String(),
        });
        return true;
      } else {
        Duration remainingTime =
            lastOfferDate.add(Duration(days: 30)).difference(currentDate);

        // Extract days, hours, minutes, and seconds from the remaining time
        int daysRemaining = remainingTime.inDays;
        int hoursRemaining = remainingTime.inHours % 24;
        int minutesRemaining = remainingTime.inMinutes % 60;

        showOfferErrorDialog(
            context, daysRemaining, hoursRemaining, minutesRemaining);
      }
    }

    return false;
  }

  // A helper method to upload images and get their URLs.
  Future<List<String>> _uploadImages() async {
    List<String> imageUrls = [];

    for (File image in _images) {
      String imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef =
          FirebaseStorage.instance.ref().child('images/$imageName');

      await storageRef.putFile(image);
      String imageUrl = await storageRef.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    return imageUrls;
  }

  Future<void> fetchTimestampFromFirebase() async {
    DatabaseReference timeRef = FirebaseDatabase.instance.ref().child('Time');

    timeRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        // Convert the server timestamp to a String
        String timestamp = event.snapshot.value.toString();

        String numericTimestamp = timestamp.replaceAll(RegExp(r'[^0-9]'), '');

        int numericValue = int.parse(numericTimestamp);

        setState(() {
          timeclick = numericValue.toString();
        });
      }
    });
  }

  Future<void> saveTimestampToFirebase() async {
    DatabaseReference reference = FirebaseDatabase.instance.ref().child('Time');

    // Set the data with the server timestamp in the Realtime Database
    await reference.set({
      'timestamp': ServerValue.timestamp,
    });
  }


  Future<void> showOfferErrorDialog(BuildContext context, int daysRemaining,
      int hoursRemaining, int minutesRemaining) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Image.network(
                'https://cdn-icons-png.flaticon.com/128/9068/9068699.png',
                width: 40,
              ),
              const Text(' ไม่สามารถยื่นข้อเสนอได้',style: TextStyle(fontSize: 20),),
            ],
          ),
          content: Text(
              'เนื่องจากครบจำนวนการยื่นข้อเสนอ 5 ครั้ง/เดือน \nโปรดรอ : $daysRemaining วัน $hoursRemaining ชั่วโมง $minutesRemaining นาที\nหรือสมัคร VIP เพื่อโพสต์หรือยื่นข้อเสนอได้ไม่จำกัด'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text(
                'ยืนยัน',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
