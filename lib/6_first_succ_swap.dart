import 'package:flutter/material.dart';

class ChangeSuccess extends StatefulWidget {
  const ChangeSuccess({super.key});

  @override
  State<ChangeSuccess> createState() => _ChangeSuccessState();
}

class _ChangeSuccessState extends State<ChangeSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("แลกเปลี่ยนสำเร็จ"),
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
      body: Padding(
        padding: const EdgeInsets.only(top: 200),
        child: Center(
          child: Column(children: [
            Container(
              child: Image.asset(
                'assets/images/ture_post.png',
                width: 100,
                height: 100,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "แลกเปลี่ยนสำเร็จ",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "หมายเลขการโพสต์ /0001",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "วันที่ 11 กันยายน 2566",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              "เวลา 22:04 น.",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 255, 17, 0),
                ),
                child: Text('ประวัติการยื่นข้อเสนอ'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
  }
}
