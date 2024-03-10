import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:swapitem/test555.dart';

import 'postSuccess_page.dart';

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

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  String timeclick = '';
  final item_name = TextEditingController();
  final brand = TextEditingController();
  final model = TextEditingController();
  final details = TextEditingController();
  final exchange_location = TextEditingController();
  late final double percentage;
  final item_name1 = TextEditingController();
  final brand1 = TextEditingController();
  final model1 = TextEditingController();
  final details1 = TextEditingController();
  late GoogleMapController mapController;

  double? latitude;
  double? longitude;
  double? selectedLatitude;
  double? selectedLongitude;
  List<File> _images = [];
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _goToUserLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  //ลบรูปภาพ
  void removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _goToUserLocation() async {
    LocationData locationData;
    var location = Location();

    try {
      locationData = await location.getLocation();
      print('Location data: $locationData');

      latitude = locationData.latitude!;
      longitude = locationData.longitude!;

      print('Latitude: $latitude');
      print('Longitude: $longitude');
    } catch (e) {
      print('ไม้มีอะไรเลย $e');
      return;
    }

    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(locationData.latitude!, locationData.longitude!),
        zoom: 15.0,
      ),
    ));
  }

  DateTime now = DateTime.now();

  String generateRandomPostNumber() {
    // สร้างตัวเลขสุ่ม 3 ตัว
    int randomNumbers =
        Random().nextInt(1000); // สามารถปรับเปลี่ยนเลขตัวเลขตามที่คุณต้องการ

    // สร้างตัวอักษรสุ่ม 2 ตัว
    String randomChars = String.fromCharCodes(List.generate(
        2, (index) => Random().nextInt(26) + 65)); // สร้างตัวอักษร A-Z

    // รวมตัวเลขและตัวอักษรเข้าด้วยกัน
    String postNumber = '$randomNumbers$randomChars';

    return postNumber;
  }

  Future<void> updateTotalPost() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').child(user!.uid);
    DatabaseEvent event = await userRef.once();
    Map<dynamic, dynamic>? datamap = event.snapshot.value as Map?;
    if (datamap != null) {
      int totalPost = int.tryParse(datamap['totalPost'].toString()) ?? 0;
      totalPost++; // Increment totalPost by 1
      await userRef.update({
        'totalPost': totalPost, // Update totalPost in Firebase
      });
    } else {
      print('User data not found');
    }
  }

  Future<void> buildPost(BuildContext context, List<File> images) async {
    try {
      bool confirmed = await _showPostConfirmationDialog();

      // Check if the user confirmed
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
                  Text("กำลังสร้างโพสต์..."),
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
        int currentPostCount =
            int.tryParse(datamap['postCount'].toString()) ?? 0;

        // ตรวจสอบว่ายังมีโอกาสโพสต์หรือไม่
        if (currentPostCount > 0 ||
            canPostAfter30Days(userRef, datamap, context)) {
          // ลดค่า postCount
          if (currentPostCount > 0) {
            await userRef.update({
              'postCount': currentPostCount - 1,
              'lastPostDate': DateTime.now().toString(),
            });
          }

          String username = datamap['username'];
          String email = datamap['email'];
          String imageUser = datamap['image_user'];
          String status_user = datamap['status_user'];
          DatabaseReference itemRef =
              FirebaseDatabase.instance.ref().child('postitem').push();
          List<String> imageUrls = await uploadImages(images);
          String postNumber = generateRandomPostNumber();
          updateTotalPost();
          // Generate uid for the post
          String? postUid = itemRef.key;
          String time =
              "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
          String date =
              "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
          Map userDataMap = {
            'timestamp': timeclick,
            //'timestamp': ServerValue.timestamp,
            'statusPosts': "สามารถยื่นข้อเสนอได้",
            'imageUser': imageUser,
            'post_uid': postUid,
            'email': email,
            'postNumber': postNumber,
            'imageUrls': imageUrls,
            'type': dropdownValue,
            'latitude': selectedLatitude.toString(),
            'longitude': selectedLongitude.toString(),
            'time': exampleUsageTime(),
            'date': exampleUsage(),
            'username': username,
            'item_name': item_name.text.trim(),
            'brand': brand.text.trim(),
            "model": model.text.trim(),
            "detail": details.text.trim(),
            "item_name1": item_name1.text.trim(),
            "brand1": brand1.text.trim(),
            "model1": model1.text.trim(),
            "details1": details1.text.trim(),
            'uid': uid,
            'status_user': status_user,
          };
          await itemRef.set(userDataMap);

          // Close the alert dialog after successfully adding data to the database
          Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => PostSuccess(
                time: time,
                date: date,
                postNumber: postNumber,
              ),
            ),
          );
        }
      }
    } catch (error) {
      print('Error in buildPost: $error');
      Navigator.pop(context);
    }
  }

  bool canPostAfter30Days(DatabaseReference userRef,
      Map<dynamic, dynamic> userData, BuildContext context) {
    // Check if last post date is available
    if (userData.containsKey('lastPostDate')) {
      DateTime lastPostDate =
          DateTime.parse(userData['lastPostDate'].toString());
      DateTime currentDate = DateTime.now();

      // Check if 30 days have passed since the last post
      if (currentDate.difference(lastPostDate).inDays >= 30) {
        // Reset post count and update last post date
        userRef.set({
          'postCount': 5,
          'lastPostDate': currentDate.toIso8601String(),
        });
        return true;
      } else {
        Duration remainingTime =
            lastPostDate.add(Duration(days: 30)).difference(currentDate);

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
              Text(' ไม่สามารถโพสต์ได้'),
            ],
          ),
          content: Text(
              'เนื่องจากครบจำนวนการโพสต์ 5 ครั้ง/เดือน \nโปรดรอ : $daysRemaining วัน $hoursRemaining ชั่วโมง $minutesRemaining นาที\nหรือสมัคร VIP เพื่อโพสต์หรือยื่นข้อเสนอได้ไม่จำกัด'),
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

  Future<List<String>> uploadImages(List<File> images) async {
    List<String> imageUrls = [];

    for (File image in images) {
      try {
        // Generate a unique ID for the image
        String imageName = DateTime.now().millisecondsSinceEpoch.toString();

        // Create a reference to the Firebase Storage path
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('post_images')
            .child('$imageName.jpg');

        // Upload the image to Firebase Storage
        await storageReference.putFile(image);

        // Get the download URL of the uploaded image
        String imageUrl = await storageReference.getDownloadURL();
        imageUrls.add(imageUrl);
      } catch (error) {
        print('Error uploading image: $error');
      }
    }

    return imageUrls;
  }

  Future<bool> _showPostConfirmationDialog() async {
    Completer<bool> completer = Completer<bool>();

    // Add input validation
    if (item_name.text.trim().isEmpty ||
        brand.text.trim().isEmpty ||
        model.text.trim().isEmpty ||
        details.text.trim().isEmpty ||
        item_name1.text.trim().isEmpty ||
        brand1.text.trim().isEmpty ||
        model1.text.trim().isEmpty ||
        details1.text.trim().isEmpty ||
        selectedLatitude == null ||
        selectedLongitude == null ||
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
      return false;
    }

    // Check if images are attached
    if (_images.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('กรุณาแนบรูปภาพ'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('ตกลง'),
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
            'ยืนยันการโพสต์',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'คุณต้องการที่ยืนยันการโพสต์หรือไม่?',
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("สร้างโพสต์"),
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
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 10, right: 2, left: 2, bottom: 5),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        onPressed: () => removeImage(index - 1),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          underline:
                              Container(), // Remove the default underline
                          items: category
                              .map<DropdownMenuItem<String>>((String value) {
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
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: item_name,
                      decoration: InputDecoration(
                        labelText: "ชื่อสิ่งของ",
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(),
                        prefixIcon:
                            Icon(Icons.shopping_bag), // Add your desired icon
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    TextField(
                      controller: brand,
                      decoration: InputDecoration(
                        label: Text(
                          "ยี่ห้อ",
                          style: TextStyle(fontSize: 20),
                        ),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.tag),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: model,
                      decoration: InputDecoration(
                          label: Text(
                            "รุ่น",
                            style: TextStyle(fontSize: 20),
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.tag)),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: details,
                      decoration: InputDecoration(
                          label: Text(
                            "รายละเอียด",
                            style: TextStyle(fontSize: 20),
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.density_medium_sharp)),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_pin),
                        Text(
                          'สถานที่แลกเปลี่ยนสิ่งของ',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        decoration: BoxDecoration(border: Border.all()),
                        height: 555,
                        width: double.infinity,
                        child: OpenStreetMapSearchAndPick(
                          buttonTextStyle: const TextStyle(
                              fontSize: 18, fontStyle: FontStyle.normal),
                          buttonColor: Colors.blue,
                          buttonText: 'Set Current Location',
                          onPicked: (pickedData) {
                            print("kok");
                            print(pickedData.latLong.latitude);
                            print(pickedData.latLong.longitude);
                            print(pickedData.address);
                            print(pickedData.addressName);
                            // double? selectedLatitude;
                            // double? selectedLongitude;
                            setState(() {
                              selectedLatitude = pickedData.latLong.latitude;
                              selectedLongitude = pickedData.latLong.longitude;
                            });
                          },
                        )
                        // child: Stack(
                        //   children: [
                        //     GoogleMap(
                        //       myLocationEnabled: true,
                        //       onMapCreated: (controller) {
                        //         mapController = controller;
                        //       },
                        //       onTap: (LatLng latLng) {
                        //         setState(() {
                        //           selectedLatitude = latLng.latitude;
                        //           selectedLongitude = latLng.longitude;
                        //         });
                        //       },
                        //       markers: selectedLatitude != null
                        //           ? {
                        //               Marker(
                        //                 markerId: MarkerId('selected-location'),
                        //                 position: LatLng(selectedLatitude!,
                        //                     selectedLongitude!),
                        //                 infoWindow: InfoWindow(
                        //                     title: 'เลือกตำแหน่งที่ต้องการ'),
                        //               ),
                        //             }
                        //           : {},
                        //       initialCameraPosition: CameraPosition(
                        //         target: LatLng(0, 0),
                        //         zoom: 2,
                        //       ),
                        //     ),
                        //     if (selectedLatitude != null)
                        //       Positioned(
                        //         top: 16,
                        //         left: 16,
                        //         child: Text(
                        //           'ตำแหน่งคือ : ${selectedLatitude!}, ${selectedLongitude!}',
                        //           style: TextStyle(fontSize: 16),
                        //         ),
                        //       ),
                        //   ],
                        // ),
                        ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(latitude.toString()),
                    Text(longitude.toString()),

                    Center(child: Image.asset('assets/images/swapIMG.png')),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: item_name1,
                      decoration: InputDecoration(
                          label: Text(
                            "ชื่อสิ่งของ",
                            style: TextStyle(fontSize: 20),
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.shopping_bag,
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: brand1,
                      decoration: InputDecoration(
                          label: Text(
                            "ยี่ห้อ",
                            style: TextStyle(fontSize: 20),
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.tag,
                          )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: model1,
                      decoration: InputDecoration(
                          label: Text(
                            "รุ่น",
                            style: TextStyle(fontSize: 20),
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.tag,
                          )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: details1,
                      decoration: InputDecoration(
                          label: Text(
                            "รายละเอียด",
                            style: TextStyle(fontSize: 20),
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.density_medium_sharp)),
                    ),
                    // Text(exampleUsageTime()),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await buildPost(context, _images);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        child: const Text(
                          "สร้างโพสต์",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  Future<void> saveTimestampToFirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').child(user!.uid);
    // Set the data with the server timestamp in the Realtime Database
    await userRef.update({
      'timestamp': ServerValue.timestamp,
    });
  }

  // Widget expTime(String current, String endtime) {
  //   DateTime currentTime = DateTime.parse(current);
  //   DateTime expirationTime = DateTime.parse(endtime);
  //   Duration difference = expirationTime.difference(currentTime);
  //
  //   return Container(
  //     child: difference.inSeconds > 0
  //         ? Text(
  //       'Time left: ${difference.inDays} days, ${difference.inHours.remainder(24)} hours, ${difference.inMinutes.remainder(60)} minutes',
  //       style: TextStyle(fontSize: 20),
  //     )
  //         : Text(
  //       'Expired!',
  //       style: TextStyle(fontSize: 20, color: Colors.red),
  //     ),
  //   );
  // }

  Widget expTime(String current, String endtime) {
    DateTime currentTime = DateTime.parse(current);
    DateTime expirationTime = DateTime.parse(endtime);
    Duration difference = expirationTime.difference(currentTime);

    Stream<DateTime> timerStream() async* {
      while (difference.inSeconds > 0) {
        await Future.delayed(Duration(seconds: 1));
        yield DateTime.now();
      }
    }

    return StreamBuilder<DateTime>(
      stream: timerStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DateTime now = snapshot.data!;
          difference = expirationTime.difference(now);
          if (difference.inSeconds <= 0) {
            return Text(
              'Expired!',
              style: TextStyle(fontSize: 20, color: Colors.red),
            );
          } else {
            return Text(
              'Time left: ${difference.inDays} days, ${difference.inHours.remainder(24)} hours, ${difference.inMinutes.remainder(60)} minutes',
              style: TextStyle(fontSize: 20),
            );
          }
        } else {
          return Container(); // สามารถแสดง Indicator หรือข้อความ "Loading" ได้ตามต้องการ
        }
      },
    );
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

  // Widget exampleUsage2() { กาก
  //   // สร้าง Timestamp จาก Firebase Firestore
  //   Timestamp firestoreTimestamp = Timestamp.now();
  //   DateTime dateTime = firestoreTimestamp.toDate();
  //
  //   // แปลงเวลาไปยังโซนเวลาของเอเชีย (Asia/Bangkok)
  //   DateTime asiaTime = dateTime.toLocal();
  //
  //   // สร้างรูปแบบการแสดงเวลา
  //   DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  //   String formattedTime = formatter.format(asiaTime);
  //
  //   // แสดงผลลัพธ์เป็น Widget Text
  //   return Text(
  //     formattedTime,
  //     // กําหนดขนาดตัวอักษร
  //     style: TextStyle(fontSize: 16),
  //   );
  // }

  Future<void> fetchTimestampFromFirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    DatabaseReference timeRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(user!.uid)
        .child('timestamp');

    // Listen for changes on the "Time" node in Firebase Realtime Database
    timeRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        // Convert the server timestamp to a String
        String timestamp = event.snapshot.value.toString();

        // Remove non-numeric characters
        String numericTimestamp = timestamp.replaceAll(RegExp(r'[^0-9]'), '');

        // Convert to integer
        int numericValue = int.parse(numericTimestamp);

        // Store the numeric timestamp in the 'timeclick' variable
        setState(() {
          timeclick =
              numericValue.toString(); // บันทึกจาก Firebase ในเครื่องเรา
        });

        // Use the 'timeclick' variable as needed
        print('Numeric Timestamp from Firebase: $timeclick');
      }
    });
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
}
