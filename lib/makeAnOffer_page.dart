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
  'เสื้อผ้า',
  'รองเท้า',
  'ของใช้ทั่วไป',
  'อุปกรณ์อิเล็กทรอนิกส์',
  'ของใช้ในบ้าน',
  'อุปกรณ์กีฬา',
  'เครื่องใช้ไฟฟ้า',
  'ของเบ็ดเตล็ด',
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

  bool _isSubmitting = false;
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
                Center(
                  child: Container(
                    width: 360,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: !_isSubmitting
                          ? () async {
                              bool? confirmed = await _showConfirmationDialog();
                              if (confirmed ?? false) {
                                try {
                                  setState(() {
                                    _isSubmitting = true;
                                  });


                                  String? offerId = await _submitOffer();

                                  if (offerId != null) {
                                    // Close the loading dialog
                                    Navigator.pop(context);

                                    // Navigate to MakeAnOfferSuccess page

                                  } else {
                                    // Handle the case where offerId is null before navigation
                                  }
                                } catch (e) {
                                  print(e);
                                } finally {
                                  setState(() {
                                    _isSubmitting = false;
                                  });
                                }
                              }
                            }
                          : null,
                      child: const Text(
                        "ยื่นข้อเสนอ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
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
    return completer.future;
  }

  Future<String?> _submitOffer() async {
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
        updateTotalOffer();

        if (currentOfferCount > 0 || canPostAfter30Days(userRef, datamap)) {
          // ลดค่า postCount
          if (currentOfferCount > 0) {
            await userRef.update({
              'makeofferCount': currentOfferCount - 1,
              'lastOfferDate': DateTime.now().toString(),
            });
          }

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
            'statusOffers': 'รอการยืนยัน',
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
            'timestamp': timeclick, //เอาเวลาขึ้น
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
          return itemRef.key;
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

        showPostErrorDialog(
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

  Future<bool?> _showConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ยืนยันการยื่นข้อเสนอ"),
          content: Text("คุณแน่ใจหรือไม่ที่ต้องการยื่นข้อเสนอนี้?"),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.of(context).pop(false); // ยกเลิก
              },
              child: const Text(
                "ยกเลิก",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                saveTimestampToFirebase();
                fetchTimestampFromFirebase();
                Navigator.of(context).pop(true);
              },
              child: const Text(
                "ยืนยัน",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showPostErrorDialog(BuildContext context, int daysRemaining,
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
              Text(' ไม่สามารถยื่นข้อเสนอได้'),
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
