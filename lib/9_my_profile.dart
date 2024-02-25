import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:swapitem/CheckOffercome.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' as io;
import 'dart:io';

import '19_offer_come.dart';
import '5_his_post.dart';
import 'package:intl/intl.dart';
import 'widget/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapitem/18_HistoryPayment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swapitem/14_HistroryMakeOffer.dart';
import 'package:firebase_database/firebase_database.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController _firstNameController,
      _lastNameController,
      _genderController,
      _birthdayController;
  late String statusUser, remainingTime;
  late final double percentage;
  Map dataUser = {};
  late User _user;
  late DatabaseReference _userRef;
  DateTime? selectedDate;
  PickedFile? _image;
  int? creditOfferSuccess;
  int? totalOffer;
  int? creditPostSuccess;
  int? totalPost;

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

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _birthdayController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _updateUserData() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return FutureBuilder<void>(
          future: _performUpdate(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while waiting for the update to complete
              return const AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text("กำลังบันทึกข้อมูล..."),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              // Display an error message if the update encounters an error
              return AlertDialog(
                title: const Text('เกิดข้อผิดพลาด'),
                content:
                    Text('เกิดข้อผิดพลาดในการบันทึกข้อมูล: ${snapshot.error}'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the AlertDialog
                    },
                    child: const Text('ตกลง'),
                  ),
                ],
              );
            } else {
              // Display a success message when the update is successful
              return AlertDialog(
                title: const Text('บันทึกข้อมูลสำเร็จ'),
                actions: [
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the AlertDialog
                    },
                    child: const Text(
                      'ตกลง',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  Future<void> _performUpdate() async {
    try {
      // Your existing update logic
      await _userRef.update({
        'firstname': _firstNameController.text,
        'lastname': _lastNameController.text,
        'gender': _genderController.text,
        'birthday': _birthdayController.text,
      });

      if (_image != null) {
        final String uid = FirebaseAuth.instance.currentUser!.uid;
        final storageRef = FirebaseStorage.instance.ref().child('images_user');
        final uploadTask =
            storageRef.child('$uid.jpg').putFile(io.File(_image!.path));
        final TaskSnapshot taskSnapshot = await uploadTask;
        final imageUrl = await taskSnapshot.ref.getDownloadURL();
        _userRef.child('image_user').set(imageUrl);
      }
    } catch (error) {
      throw error; // Rethrow the error to be caught by the FutureBuilder
    }
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
                      statusUser = dataUser['status_user'];
                      remainingTime = dataUser['remainingTime'];
                      creditOfferSuccess = dataUser['creditOfferSuccess'];
                      totalOffer = dataUser['totalOffer'];
                      creditPostSuccess = dataUser['creditPostSuccess'];
                      totalPost = dataUser['totalPost'];
                      bool isPremiumUser =
                          (statusUser == 'ผู้ใช้พรีเมี่ยม') ? true : false;
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.topCenter,
                                  child: imageProfile(),
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'สถานะ : ',
                                          style: TextStyle(fontSize: 21),
                                        ),
                                        if (statusUser == 'ผู้ใช้พรีเมี่ยม')
                                          Image.asset(
                                              'assets/images/vipbar.png',
                                              width: 30,
                                              height: 30),
                                        Text(
                                          statusUser,
                                          style: const TextStyle(fontSize: 21),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    isPremiumUser
                                        ? Text(
                                            'ใช้ได้ถึงวันที่ : ${formatExpiryDate(remainingTime)}',
                                            style:
                                                const TextStyle(fontSize: 18),
                                          )
                                        : const SizedBox(),
                                    const SizedBox(height: 10),
                                    buttonShowCredit(),
                                  ],
                                )
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     (totalOffer.toString() != "0" ||
                            //             totalPost.toString() != "0")
                            //         ? pieChart(creditOfferSuccess!, totalOffer!,
                            //             creditPostSuccess!, totalPost!)
                            //         : Row(
                            //             children: [
                            //               Image.network(
                            //                   'https://cdn-icons-png.flaticon.com/128/3476/3476248.png',
                            //                   width: 40),
                            //               Text(
                            //                 'ไม่มีเครดิตการโพสต์และการยื่นข้อเสนอ',
                            //                 style: TextStyle(
                            //                     fontSize: 18,
                            //                     fontWeight: FontWeight.bold),
                            //               ),
                            //             ],
                            //           )
                            //   ],
                            // ),
                            const Divider(),
                            const SizedBox(height: 20),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: TextField(
                                          readOnly: true,
                                          controller: TextEditingController(
                                              text: dataUser['id'].toString()),
                                          decoration: const InputDecoration(
                                            label: Text(
                                              "หมายเลขผู้ใช้งาน",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(Icons.tag),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: TextField(
                                          readOnly: true,
                                          controller: TextEditingController(
                                              text: dataUser['username']
                                                  .toString()),
                                          decoration: const InputDecoration(
                                            label: Text(
                                              "ชื่อผู้ใช้",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(Icons.person),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: TextField(
                                          controller: _firstNameController,
                                          decoration: const InputDecoration(
                                              label: Text(
                                                "ชื่อ",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              border: OutlineInputBorder(),
                                              prefixIcon: Icon(Icons.person),
                                              suffixIcon: Icon(Icons
                                                  .drive_file_rename_outline)),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: TextField(
                                          controller: _lastNameController,
                                          decoration: const InputDecoration(
                                              label: Text(
                                                "นามสกุล",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              border: OutlineInputBorder(),
                                              prefixIcon: Icon(Icons.person),
                                              suffixIcon: Icon(Icons
                                                  .drive_file_rename_outline)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: TextField(
                                          readOnly: true,
                                          controller: _genderController,
                                          decoration: const InputDecoration(
                                            label: Text(
                                              "เพศ",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(Icons.male),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: TextField(
                                          controller: _birthdayController,
                                          style: const TextStyle(fontSize: 15),
                                          onTap: () => _selectDate(context),
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'วันเกิด',
                                            labelStyle: TextStyle(
                                              fontSize: 20,
                                            ),
                                            hintStyle: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                            fillColor: Colors.white,
                                            filled: true,
                                            prefixIcon: Icon(Icons.date_range),
                                            suffixIcon:
                                                Icon(Icons.arrow_drop_down),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  TextField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text: _user.email!),
                                    decoration: const InputDecoration(
                                        label: Text(
                                          'อีเมล',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.email)),
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GradientButton(
                                  colors: const [
                                    Color.fromARGB(255, 66, 206, 11),
                                    Color.fromARGB(255, 43, 248, 64)
                                  ],
                                  text: 'บันทึกการแก้ไข',
                                  onPressed: () {
                                    _updateUserData();
                                  },
                                ),
                                GradientButton(
                                    colors: const [
                                      Color(0xFFf6a5c1),
                                      Color(0xFF5fadcf)
                                    ],
                                    text: 'ข้อเสนอที่เข้ามา',
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => offerCome(
                                            postUid: _user.uid,
                                          ),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GradientButton(
                                    colors: const [
                                      Color(0xFFf6a5c1),
                                      Color(0xFF5fadcf)
                                    ],
                                    text: 'ประวัติการโพสต์',
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HistoryPost(),
                                        ),
                                      );
                                    }),
                                GradientButton(
                                    colors: const [
                                      Color(0xFFf6a5c1),
                                      Color(0xFF5fadcf)
                                    ],
                                    text: 'ประวัติการยื่นข้อเสนอ',
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const His_Makeoffer(),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                GradientButton(
                                  colors: const [
                                    Color(0xFFf6a5c1),
                                    Color(0xFF5fadcf)
                                  ],
                                  text: 'ประวัติการชำระเงิน',
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const HistoryPayment(),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 15),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  label: const Text('ออกจากระบบ',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                  icon: const Icon(Icons.logout,
                                      color: Colors.white),
                                  onPressed: () {
                                    _showSignOutConfirmationDialog();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.email,
                                  color: Color.fromARGB(255, 191, 19, 243),
                                  size: 25,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'peerapatza401@gmail.com',
                                  style: TextStyle(fontSize: 17),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 101, 191, 247),
                                  ),
                                  onPressed: () async {
                                    encodeQueryParameters(
                                        Map<String, String> params) {
                                      return params.entries
                                          .map((MapEntry<String, String> e) =>
                                              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                          .join('&');
                                    }

                                    final Uri emailUri = Uri(
                                      scheme: 'mailto',
                                      path: 'smith@example.com',
                                      query: encodeQueryParameters(<String,
                                          String>{
                                        'subject':
                                            'Example Subject & Symbols are allowed!',
                                        'body': 'test1'
                                      }),
                                    );
                                    if (await canLaunchUrl(emailUri)) {
                                      launchUrl(emailUri);
                                    } else {
                                      throw Exception(
                                          'Could not launch $emailUri');
                                    }
                                  },
                                  child: const Text(
                                    'ติดต่อเรา',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
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
          title: const Center(child: Text('บันทึกสำเร็จ')),
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

  Future<void> takePhoto(ImageSource source) async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: source,
    );

    if (pickedFile != null) {
      setState(() {
        _image = PickedFile(pickedFile.path); // Convert XFile to PickedFile
      });

      Navigator.pop(context); // Close the bottom sheet
    }
  }

  String formatExpiryDate(String remainingTime) {
    List<String> parts =
        remainingTime.split(' '); // แยกส่วนของวัน เดือน ชั่วโมง นาที วินาที
    int days = int.parse(parts[0]);
    int hours = int.parse(parts[2]);
    int minutes = int.parse(parts[4]);
    int seconds = int.parse(parts[6]);

    Duration duration = Duration(
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );

    // นับถอยหลังจากเวลาปัจจุบัน
    DateTime now = DateTime.now();
    DateTime expiryDate = now.add(duration);

    // แปลงเวลาให้อยู่ในรูปแบบ "วันที่หมดอายุ"
    String formattedExpiryDate =
        '${expiryDate.day}/${expiryDate.month}/${expiryDate.year}';

    return formattedExpiryDate;
  }

  Widget imageProfile() {
    return StreamBuilder(
      stream: _userRef.child('image_user').onValue,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String? imageUrl = snapshot.data.snapshot.value;

          return Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 60.0,
                backgroundImage: _image != null
                    ? FileImage(File(_image!.path))
                    : (imageUrl != null
                        ? NetworkImage(imageUrl)
                        : AssetImage('assets/icons/Person-icon.jpg')
                            as ImageProvider<Object>),
              ),
              Positioned(
                bottom: 10.0,
                right: 10.0,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => bottomSheet(),
                    );
                  },
                  child: const Icon(
                    Icons.camera_alt,
                    color: Color.fromARGB(255, 0, 188, 251),
                    size: 28,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "เลือกรูปภาพของคุณ",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: const Icon(Icons.camera),
                label: const Text('กล้อง'),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: const Icon(Icons.camera),
                label: const Text('แกลลอรี่'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget slideBar(int totalPost, int creditPostSuccess) {
    double percentage = creditPostSuccess / totalPost;
    double containerWidth = 100.0;

    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: containerWidth,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: Container(
              width: containerWidth * percentage,
              color: Colors.green,
            ),
          ),
          Center(
            child: Text(
              '${(percentage * 100)}%',
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


  Widget buttonShowCredit() {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("เครดิตของฉัน"),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'จำนวนการโพสต์ฺ : $totalPost',
                      style: TextStyle(fontSize: 18),
                    ),
                    const Text(
                      'อัตราการแลกเปลี่ยนสำเร็จ',
                      style: TextStyle(fontSize: 18),
                    ),
                    slideBar(totalPost!, creditPostSuccess!),
                    const SizedBox(height: 30),
                    Text(
                      'จำนวนการยื่นข้อเสนอ : $totalOffer',
                      style: TextStyle(fontSize: 18),
                    ),
                    const Text(
                      'อัตราการแลกเปลี่ยนสำเร็จ',
                      style: TextStyle(fontSize: 18),
                    ),
                    slideBar(totalOffer!, creditOfferSuccess!),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("ปิด"),
                ),
              ],
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(80, 30),
        backgroundColor: Colors.blue,
      ),
      child: const Text(
        'เครดิตของฉัน',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

//   Widget pieChart(String creditOfferSuccess, String totalOffer,
//       String creditPostSuccess, String totalPost) {
//     return Row(
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'เครดิตการยื่นข้อเสนอ',
//               style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               width: 120,
//               height: 120,
//               child: PieChart(
//                 PieChartData(
//                   sections: [
//                     PieChartSectionData(
//                       value: double.tryParse(creditOfferSuccess),
//                       color: Colors.green,
//                       title:
//                           '${(100 - double.parse(creditOfferSuccess)).toStringAsFixed(2)}%',
//                       radius: 50,
//                       titleStyle: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     PieChartSectionData(
//                       value: double.tryParse((double.parse(totalOffer) -
//                               double.parse(creditOfferSuccess))
//                           .toString()),
//                       color: Colors.red,
//                       title: '$creditOfferSuccess%',
//                       radius: 50,
//                       titleStyle: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(width: 10),
//         Column(
//           children: [
//             const Text('เครดิตการโพสต์',
//                 style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             SizedBox(
//               width: 120,
//               height: 120,
//               child: PieChart(
//                 PieChartData(
//                   sections: [
//                     PieChartSectionData(
//                       value: double.tryParse(creditPostSuccess),
//                       color: Colors.green,
//                       title:
//                           '${(100 - double.parse(creditPostSuccess)).toStringAsFixed(2)}%',
//                       radius: 50,
//                       titleStyle: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     PieChartSectionData(
//                       value: double.tryParse((double.parse(totalPost) -
//                               double.parse(creditPostSuccess))
//                           .toString()),
//                       color: Colors.red,
//                       title: '$creditPostSuccess%',
//                       radius: 50,
//                       titleStyle: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(width: 1),
//         const Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   Icons.circle,
//                   size: 20,
//                   color: Colors.green,
//                 ),
//                 SizedBox(width: 5),
//                 Text(
//                   'สำเร็จ',
//                   style: TextStyle(
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Icon(
//                   Icons.circle,
//                   size: 20,
//                   color: Colors.red,
//                 ),
//                 SizedBox(width: 5),
//                 Text(
//                   'ไม่สำเร็จ',
//                   style: TextStyle(
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ],
//     );
//   }
}
