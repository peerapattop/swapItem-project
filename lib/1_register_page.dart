import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:swapitem/_login_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';

class RegisPage extends StatefulWidget {
  const RegisPage({Key? key}) : super(key: key);

  @override
  _RegisPageState createState() => _RegisPageState();
}

class _RegisPageState extends State<RegisPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  String selectedGender = '';
  final _birthdayController = TextEditingController();
  final _usernameController = TextEditingController();
  int monthlyPostLimit = 5;
  int makeofferCount = 5;

  XFile? _imageFile;
  String? imageUrl;
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _birthdayController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  registerNewUser(BuildContext context) async {
    if (_firstnameController.text.trim().isEmpty ||
        _lastnameController.text.trim().isEmpty ||
        selectedGender.isEmpty ||
        _usernameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                SizedBox(
                  height: 39,
                ),
                Text(
                  'ข้อมูลไม่ครบถ้วน',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            content: Text('โปรดกรอกข้อมูลให้ครบทุกช่อง'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'รับทราบ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16), // Add some spacing
              Text(
                'กำลังสมัครสมาชิก...',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
      barrierDismissible: false,
    );

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      String uid = userCredential.user!.uid;

      //สุ่มไอดีผู้ใช้งาน
      String generateRandomId() {
        Random random = Random();
        int randomNumber =
            random.nextInt(90000) + 10000; // สร้างตัวเลขสุ่ม 5 ตัว
        return randomNumber.toString();
      }

      Future<bool> checkIfIdExists(String userId) async {
        try {
          // สร้าง reference ไปยังโหนดข้อมูลของผู้ใช้ใน Firebase Realtime Database
          DatabaseReference reference =
              FirebaseDatabase.instance.ref().child('users');

          // ดึงข้อมูลจาก Firebase Realtime Database
          DatabaseEvent snapshot = await reference.child(userId).once();

          // ตรวจสอบว่าข้อมูลที่ได้มีค่าหรือไม่
          return snapshot.snapshot.value != null;
        } catch (error) {
          print("เกิดข้อผิดพลาดในการตรวจสอบ ID: $error");
          return false; // หรือตอบ false ในกรณีที่เกิดข้อผิดพลาด
        }
      }

      Future<String> generateUniqueRandomId() async {
        String userId = generateRandomId();

        // ตรวจสอบว่า ID ที่สร้างไม่ซ้ำกับที่มีอยู่ในระบบแล้ว
        bool isDuplicate = await checkIfIdExists(userId);

        // ถ้า ID ซ้ำให้ทำการสร้างใหม่
        while (isDuplicate) {
          userId = generateRandomId();
          isDuplicate = await checkIfIdExists(userId);
        }

        return userId;
      }

      String userId = await generateUniqueRandomId();

      // Upload image to Firebase Storage
      if (_imageFile != null) {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('user_images/${userCredential.user!.uid}.jpg');
        await storageReference.putFile(File(_imageFile!.path));
        imageUrl = await storageReference.getDownloadURL();

        // เพิ่ม URL ของรูปภาพลง Realtimedatabase
        DatabaseReference userRef = FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(userCredential.user!.uid);
        await userRef.child('image_user').set(imageUrl);
      }

      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userCredential.user!.uid);

      Map userDataMap = {
        'uid':uid,
        'makeofferCount': makeofferCount,
        'postCount': monthlyPostLimit,
        'status_user': 'ผู้ใช้ทั่วไป',
        'image_user': imageUrl,
        "id": userId,
        "firstname": _firstnameController.text.trim(),
        "lastname": _lastnameController.text.trim(),
        "gender": selectedGender,
        "username": _usernameController.text.trim(),
        "email": _emailController.text.trim(),
        "birthday": _birthdayController.text.trim(),
      };

      await userRef.set(userDataMap);

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                Text('สมัครสมาชิกสำเร็จ'),
              ],
            ),
            content: Text('คุณได้ทำการสมัครสมาชิกเรียบร้อยแล้ว'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => Login()));
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
    } catch (error) {
      Navigator.pop(context);

      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ลงทะเบียน"),
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
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                imgPost(),
                textField('ชื่อ', Icons.person, _firstnameController),
                textField('นามสกุล', Icons.person, _lastnameController),
                choseGender(),
                choseBirthDay(Icons.date_range, _birthdayController),
                textField('ชื่อผู้ใช้', Icons.person, _usernameController),
                textField('อีเมล', Icons.email, _emailController),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 15),
                  child: TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'รหัสผ่าน',
                      labelStyle: TextStyle(fontSize: 20),
                      prefixIcon: Icon(
                          Icons.password), // Use prefixIcon for adding an icon
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      registerNewUser(context);
                    },
                    child: const Text(
                      'ลงทะเบียน',
                      style: TextStyle(
                        color: Colors.white, // Change text color as needed
                        fontSize: 18, // Change font size as needed
                      ),
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

  Widget textField(
      String labelText, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: '$labelText',
          labelStyle: const TextStyle(fontSize: 20),
          prefixIcon: Icon(icon), // Use prefixIcon for adding an icon
        ),
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final dynamic pickedFile = await ImagePicker().pickImage(
      source: source,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });

      // Close the file selection window
      Navigator.pop(context);
    }
  }

  Widget imgPost() {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 60.0,
          backgroundImage: _imageFile != null
              ? FileImage(File(_imageFile!.path))
              : AssetImage('assets/icons/Person-icon.jpg')
                  as ImageProvider<Object>,
        ),
        Positioned(
          bottom: 10.0,
          right: 10.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context, builder: ((Builder) => bottomSheet()));
            },
            child: const Icon(
              Icons.camera_alt,
              color: const Color.fromARGB(255, 52, 0, 150),
              size: 28,
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

  Widget choseGender() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 15),
      child: Row(
        children: <Widget>[
          Row(
            children: [
              Image.asset(
                'assets/icons/gender.png',
                width: 29,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'เพศ',
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),
          const SizedBox(
            width: 15,
          ),
          Radio(
            activeColor: Colors.green,
            value: "ชาย",
            groupValue: selectedGender,
            onChanged: (value) {
              setState(() {
                selectedGender = value.toString();
              });
            },
          ),
          const Text("ชาย", style: TextStyle(fontSize: 18)),
          const SizedBox(width: 20),
          Radio(
            activeColor: Colors.green,
            value: "หญิง",
            groupValue: selectedGender,
            onChanged: (value) {
              setState(() {
                selectedGender = value.toString();
              });
            },
          ),
          const Text("หญิง", style: TextStyle(fontSize: 18)),
          Radio(
            activeColor: Colors.green,
            value: "อื่น ๆ",
            groupValue: selectedGender,
            onChanged: (value) {
              setState(() {
                selectedGender = value.toString();
              });
            },
          ),
          const Text("อื่น ๆ", style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget choseBirthDay(IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: TextField(
        controller: controller,
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
            prefixIcon: Icon(icon),
            suffixIcon: Icon(Icons.arrow_drop_down)),
      ),
    );
  }
}
