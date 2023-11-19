import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swapitem/1_regis_page.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  Future signIn() async {
    setState(() {
      _loading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Add any additional logic after successful login if needed.
    } catch (e) {
      // Handle errors
      String errorMessage = "โปรดกรอกอีเมล และรหัสผ่าน"; // ข้อความที่คุณต้องการแสดง

      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMessage = 'ไม่พบผู้ใช้งานนี้ในระบบ';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'รหัสผ่านไม่ถูกต้อง';
        }
      }

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                SizedBox(width: 8),
                Text('เกิดข้อผิดพลาด'),
              ],
            ),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // ปิดกล่องข้อความผิดพลาด
                  setState(() {
                    _loading = false; // ปิดสถานะการโหลด
                  });
                },
                child: Text('ตกลง'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHight = MediaQuery.of(context).size.height - 58;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Row 1
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: screenWidth,
                      height: 17,
                      child: Image.asset(
                        'assets/images/toplogin.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              // Row 2
              Row(
                children: [
                  Container(
                    width: 17,
                    height: screenHight,
                    child: Image.asset(
                      'assets/images/llogin.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Image.asset('assets/images/SWAP ITEM.png'),
                        const SizedBox(
                          height: 30,
                        ),
                        Image.asset('assets/images/newlogoGod 1.png'),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              border:
                                  OutlineInputBorder(), // Add a border around the TextField
                              labelText: 'อีเมล',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border:
                                  OutlineInputBorder(), // Add a border around the TextField
                              labelText: 'รหัสผ่าน',
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: const Text('ลืมรหัสผ่าน?'))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _loading
                            ? Container(
                                width: 150,
                                height: 40,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              )
                            : Container(
                                width: 160,
                                height: 40,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    signIn();
                                  },
                                  icon: const Icon(Icons.login,color: Colors.white,),
                                  label: const Text(
                                    'เข้าสู่ระบบ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: 160,
                          height: 40,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => RegisPage(),
                              ));
                            },
                            icon: const Icon(Icons.add,color: Colors.white,),
                            label: const Text(
                              'สมัครสมาชิก',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 34, 25, 196)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 17,
                    height: screenHight,
                    child: Image.asset(
                      'assets/images/llogin.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              // Row 3
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: screenWidth,
                      height: 17,
                      child: Image.asset(
                        'assets/images/toplogin.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
