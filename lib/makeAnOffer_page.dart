import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swapitem/13_MakeAnOfferSuccess.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class MakeAnOffer extends StatefulWidget {
  final String postUid;
  final String username;
  final String imageUser;
  const MakeAnOffer(
      {Key? key,
      required this.postUid,
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
  final _nameItem1 = TextEditingController();
  final _brand1 = TextEditingController();
  final _model1 = TextEditingController();
  final _detail1 = TextEditingController();
  final picker = ImagePicker();
  DateTime now = DateTime.now();
  String? username;

  bool _isSubmitting = false;
  List<File> _images = [];

  @override
  void initState() {
    super.initState();
    dropdownValue = category.first; // Initialize in initState
  }

  @override
  Widget build(BuildContext context) {
    void removeImage(int index) {
      setState(() {
        _images.removeAt(index);
      });
    }

    String date1 = now.year.toString() +
        "-" +
        now.month.toString().padLeft(2, '0') +
        "-" +
        now.day.toString().padLeft(2, '0');
    String time1 = now.hour.toString().padLeft(2, '0') +
        ":" +
        now.minute.toString().padLeft(2, '0') +
        ":" +
        now.second.toString().padLeft(2, '0');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("ยื่นข้อเสนอ"),
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
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 17),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 17),
                TextField(
                  controller: _nameItem1,
                  decoration: InputDecoration(
                    labelText: 'ชื่อสิ่งของ', // Label text
                    border:
                        OutlineInputBorder(), // Creates a rounded border around the TextField
                    prefixIcon:
                        Icon(Icons.shopping_bag), // Icon inside the TextField
                  ),
                ),
                SizedBox(
                  height: 17,
                ),
                TextField(
                  controller: _brand1,
                  decoration: InputDecoration(
                    labelText: 'ยี่ห้อ', // Label text
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.branding_watermark),
                  ),
                ),
                SizedBox(
                  height: 17,
                ),
                TextField(
                  controller: _model1,
                  decoration: InputDecoration(
                    labelText: 'รุ่น', // Label text
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.model_training),
                  ),
                ),
                SizedBox(
                  height: 17,
                ),
                TextField(
                  controller: _detail1,
                  decoration: InputDecoration(
                    labelText: 'รายละเอียด', // Label text
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.details),
                  ),
                  maxLines: null, // Allows for multi-line input
                ),
                SizedBox(height: 17),
                SizedBox(height: 7),
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

                                  // Show a loading indicator here, such as CircularProgressIndicator

                                  String? offerId = await _submitOffer();

                                  if (offerId != null) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MakeAnOfferSuccess(
                                          offer_id: offerId,
                                          date: date1,
                                          time: time1,
                                          offerNumber: generateRandomNumber(),
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Handle the case where offerId is null before navigation
                                  }
                                } catch (e) {
                                  print(e);
                                } finally {
                                  // Hide the loading indicator here

                                  setState(() {
                                    _isSubmitting = false;
                                  });
                                }
                              }
                            }
                          : null,
                      child: _isSubmitting
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
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

  Future<String?> _submitOffer() async {
    try {
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
                    backgroundColor:
                        Colors.green, // Set the button color to green
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
        return null; // Prevent further processing
      }
      User? user = FirebaseAuth.instance.currentUser;
     

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
      
        String postUid = widget.postUid;
        String imageUser = widget.imageUser;

// Use the `username` variable as needed

        String uid = FirebaseAuth.instance.currentUser!.uid;
        DatabaseReference itemRef =
            FirebaseDatabase.instance.ref().child('offer').push();
        String? offerUid = itemRef.key;
        // First, upload images and collect their URLs.
        List<String> imageUrls = await _uploadImages();
        // Then, set the data with image URLs in the Realtime Database.
        Map<String, dynamic> dataRef = {
          'username': username,
          'imageUser': imageUser,
          'status': 'รอการยืนยัน',
          'offer_uid': offerUid,
          'offerNumber': generateRandomNumber(),
          'uid': uid,
          'type1': dropdownValue,
          'nameitem1': _nameItem1.text.trim(),
          'brand1': _brand1.text.trim(),
          'model1': _model1.text.trim(),
          'detail1': _detail1.text.trim(),
          'imageUrls': imageUrls,
          'post_uid': postUid,
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

        await itemRef.set(dataRef);
        return itemRef.key;
      }
    } catch (error) {
      Navigator.pop(context);
    }
    return null;
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
                  Text(
                    ' ไม่สามารถยื่นข้อเสนอได้',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              content: Text(
                'เนื่องจากครบจำนวนการยื่นข้อเสนอ 5 ครั้ง/เดือน \nโปรดรอ : $daysRemaining วัน $hoursRemaining ชั่วโมง $minutesRemaining นาที\nหรือสมัคร VIP เพื่อโพสต์หรือยื่นข้อเสนอได้ไม่จำกัด',
                style: TextStyle(fontSize: 18),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
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

    return false;
  }

  // A helper method to upload images and get their URLs.
  Future<List<String>> _uploadImages() async {
    List<String> imageUrls = [];

    for (File image in _images) {
      String imageName =
          DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
      Reference storageRef =
          FirebaseStorage.instance.ref().child('images/$imageName');

      await storageRef.putFile(image);
      String imageUrl = await storageRef.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    return imageUrls;
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
              child: Text(
                "ยกเลิก",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                "ยืนยัน",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
