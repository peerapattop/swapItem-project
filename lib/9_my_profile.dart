import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' as io;

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

  Map dataUser = {};
  late User _user;
  late DatabaseReference _userRef;
  DateTime? selectedDate;
  PickedFile? _image;

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

        _userRef.update({'birthday': _birthdayController.text});
      });
    }
  }

  Future<void> _updateUserData() async {
    try {
      // Update text-based user data
      await _userRef.update({
        'firstname': _firstNameController.text,
        'lastname': _lastNameController.text,
        'gender': _genderController.text,
        'birthday': _birthdayController.text,
      });

      // Check if a new image is selected
      if (_image != null) {
        // Get the UID of the currently logged-in user
        final String uid = FirebaseAuth.instance.currentUser!.uid;

        // Upload the new image to Firebase Storage
        final storageRef = FirebaseStorage.instance.ref().child('images_user');
        final uploadTask =
            storageRef.child('$uid.jpg').putFile(io.File(_image!.path));

        // Await the upload task directly
        final TaskSnapshot taskSnapshot = await uploadTask;

        // Get the download URL
        final imageUrl = await taskSnapshot.ref.getDownloadURL();

        // Update the user's image URL in Firebase Realtime Database
        _userRef.child('image_user').set(imageUrl);
      }

      // Show success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('บันทึกข้อมูลสำเร็จ'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the AlertDialog
                },
                child: Text(
                  'ตกลง',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Handle errors, such as network issues, permission denied, etc.
      print('Error updating user data: $error');
      // Show an error message to the user or handle it appropriately
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
                      statusUser = dataUser['status_user'];
                      remainingTime = dataUser['remainingTime'];
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
                                    Text(
                                      'ถึงวันที่ : $remainingTime',
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
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
                                      const SizedBox(
                                          width:
                                              15), // Adds space between the two TextFields
                                      Expanded(
                                        child: TextField(
                                          readOnly: true,
                                          controller: TextEditingController(
                                              text: dataUser['username']
                                                  .toString()),
                                          decoration: InputDecoration(
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
                                  const SizedBox(
                                    height: 15,
                                  ),
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
                                      const SizedBox(
                                          width:
                                              15), // Space between the two TextFields
                                      Expanded(
                                        child: TextField(
                                          controller: _lastNameController,
                                          decoration: InputDecoration(
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
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: TextField(
                                          readOnly: true,
                                          controller: _genderController,
                                          decoration: InputDecoration(
                                            label: Text(
                                              "เพศ",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(Icons.male),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          width:
                                              15), // Space between the two TextFields
                                      Expanded(
                                        child: TextField(
                                          controller: _birthdayController,
                                          style: TextStyle(fontSize: 15),
                                          onTap: () => _selectDate(context),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'วันเกิด',
                                            labelStyle: const TextStyle(
                                              fontSize: 20,
                                            ),
                                            hintStyle: const TextStyle(
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
                                  SizedBox(
                                    height: 15,
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
                                    colors: [
                                      Color(0xFFf6a5c1),
                                      Color(0xFF5fadcf)
                                    ],
                                    text: 'ช้อเสนอที่เข้ามา',
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => OfferCome(),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GradientButton(
                                    colors: [
                                      Color(0xFFf6a5c1),
                                      Color(0xFF5fadcf)
                                    ],
                                    text: 'ประวัติการโพสต์',
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => HistoryPost(),
                                        ),
                                      );
                                    }),
                                GradientButton(
                                    colors: [
                                      Color(0xFFf6a5c1),
                                      Color(0xFF5fadcf)
                                    ],
                                    text: 'ประวัติการยื่นข้อเสนอ',
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              HistoryMakeOffer(),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                GradientButton(
                                  colors: [
                                    Color(0xFFf6a5c1),
                                    Color(0xFF5fadcf)
                                  ],
                                  text: 'ประวัติการชำระเงิน',
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => HistoryPayment(),
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
                                Icon(
                                  Icons.email,
                                  color: Color.fromARGB(255, 191, 19, 243),
                                  size: 25,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'peerapatza401@gmail.com',
                                  style: TextStyle(fontSize: 17),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 101, 191, 247),
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
                                    ))
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
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl)
                    : AssetImage('assets/icons/Person-icon.jpg')
                        as ImageProvider<Object>,
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
