import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: Icon(
                Icons.check,
                size: 40,
                color: Colors.green,
              ),
              content: Text('ลิงก์รีเซ็ทรหัสผ่านถูกส่งไปยังอีเมลของคุณแล้ว !!'),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green
                  ),
                  onPressed: () {
                    // ปิด AlertDialog
                    Navigator.pop(context);

                    // กลับไปที่หน้าก่อนหน้านี้
                    Navigator.pop(context);
                  },
                  child: Text('ตกลง',style: TextStyle(color: Colors.white),),
                ),
              ],
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: Icon(
                Icons.close,
                size: 40,
                color: Colors.red,
              ),
              content: Text(
                  'เกิดข้อผิดพลาด, อาจไม่มีอีเมลนี้ในระบบหรือป้อนอีเมลไม่ถูกต้อง'),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("รีเซ็ตรหัสผ่าน"),
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
              SizedBox(
                height: 100,
              ),
              Image.asset('assets/images/forgotpassword.png'),
              SizedBox(
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'โปรดกรอกอีเมลและเราจะส่งลิงก์รีเซ็ทรหัสผ่านไปยังอีเมลของคุณ',
                  style: TextStyle(fontSize: 19),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: _emailController,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the value as needed
                    ),
                    labelText: 'อีเมล',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    passwordReset();
                  },
                  icon: Icon(Icons.key),
                  label: Text(
                    'รีเซ็ทรหัสผ่าน',
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
