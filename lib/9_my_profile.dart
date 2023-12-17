import '5_his_post.dart';
import '7_first_offer.dart';
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
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _genderController;
  late TextEditingController _birthdayController;
  late String status_user;
  late String remainingTime;
  Map dataUser = {};
  late User _user;
  late DatabaseReference _userRef;
  DateTime? selectedDate;

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

        // Save the updated birthday data to the database
        _userRef.update({'birthday': _birthdayController.text});
      });
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
                      status_user = dataUser['status_user'];
                      remainingTime = dataUser['remainingTime'];
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.topCenter,
                                  child: imgPost(),
                                ),
                                SizedBox(
                                  width: 60,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'สถานะ : $status_user',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      'ใช้ได้อีก : $remainingTime',
                                      style: TextStyle(fontSize: 7),
                                    )
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
                                          ),
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
                                          ),
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
                                  text: 'บันทึกการแก้ไข',
                                  onPressed: () {
                                    _userRef.update({
                                      'firstname': _firstNameController.text,
                                      'lastname': _lastNameController.text,
                                      'gender': _genderController.text,
                                      'birthday': _birthdayController.text,
                                    }).then((value) {
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
                                                  Navigator.of(context)
                                                      .pop(); // ปิด AlertDialog
                                                },
                                                child: Text(
                                                  'ตกลง',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    });
                                  },
                                ),
                                GradientButton(
                                    text: 'ช้อเสนอที่เข้ามา',
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => OfferRequest(),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GradientButton(
                                    text: 'ประวัติการโพสต์',
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => HistoryPost(),
                                        ),
                                      );
                                    }),
                                GradientButton(
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GradientButton(
                                    text: 'ประวัติการชำระเงิน',
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              HistoryPayment(),
                                        ),
                                      );
                                    }),
                                GradientButton(
                                    text: 'ออกจากระบบ',
                                    onPressed: () {
                                      _showSignOutConfirmationDialog();
                                    }),
                              ],
                            ),
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

  void takePhoto(ImageSource source) async {
    final dynamic pickedFile = await ImagePicker().pickImage(
      source: source,
    );

    if (pickedFile != null) {
      setState(() {});

      Navigator.pop(context);
    }
  }

  Widget imgPost() {
    return StreamBuilder(
      stream: _userRef.child('image_user').onValue,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
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
                    color: Color.fromARGB(255, 52, 0, 150),
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
