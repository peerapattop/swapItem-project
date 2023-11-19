import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  final _genderController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _usernameController = TextEditingController();

  XFile? _imageFile;
  String? imageUrl;

  registerNewUser(BuildContext context) async {
  // Check if all required fields are filled
  if (_firstnameController.text.trim().isEmpty ||
      _lastnameController.text.trim().isEmpty ||
      _genderController.text.trim().isEmpty ||
      _usernameController.text.trim().isEmpty ||
      _emailController.text.trim().isEmpty ||
      _passwordController.text.trim().isEmpty) {
    // Show an error dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error,
              color: Colors.red,),
              SizedBox(height: 39,),
              Text('ข้อมูลไม่ครบถ้วน',style: TextStyle(fontSize: 20),),
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
              child: Text('รับทราบ',style: TextStyle(color: Colors.white),),
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
            Text('กำลังสมัครสมาชิก...',style: TextStyle(fontWeight: FontWeight.bold),),
          ],
        ),
      );
    },
    barrierDismissible: false,
  );

  try {
    final UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
       // Upload image to Firebase Storage
    if (_imageFile != null) {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('user_images/${userCredential.user!.uid}.jpg');
      await storageReference.putFile(File(_imageFile!.path));
      String imageUrl = await storageReference.getDownloadURL();
      
      // Store the image URL in the Realtime Database
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userCredential.user!.uid);
      await userRef.child('image_url').set(imageUrl);
    }

    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(userCredential.user!.uid);

    Map userDataMap = {
      'image_url': imageUrl?.toString(),
      "id": userCredential.user!.uid,
      "firstname": _firstnameController.text.trim(),
      "lastname": _lastnameController.text.trim(),
      "gender": _genderController.text.trim(),
      "username": _usernameController.text.trim(),
      "email": _emailController.text.trim(),
    };

    await userRef.set(userDataMap);

    Navigator.pop(context);

    // Show a success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('สมัครสมาชิกสำเร็จ'),
          content: Text('คุณได้ทำการสมัครสมาชิกเรียบร้อยแล้ว'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                // Close the success dialog
                Navigator.pop(context);

                // Close registration screen
                Navigator.pop(context);

                // Navigate to the login screen or any other screen
                Navigator.push(context, MaterialPageRoute(builder: (c) => Login()));
              },
              child: Text('ยืนยัน',style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  } catch (error) {
    // Close the loading dialog
    Navigator.pop(context);

    print(error.toString());
    // Handle error (show a message, etc.)
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
                textField('เพศ', Icons.male, _genderController),
                textField('วันเกิด', Icons.date_range, _birthdayController),
                textField('ชื่อผู้ใช้', Icons.person, _usernameController),
                textField('อีเมล', Icons.email, _emailController),
                textField('รหัสผ่าน', Icons.key, _passwordController),
                textField('ยืนยันรหัสผ่าน', Icons.key, _passwordController),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 219,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 2, 173, 82),
                    ),
                    child: TextButton(
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
              : AssetImage('assets/images/profile_defalt.jpg')
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
}
