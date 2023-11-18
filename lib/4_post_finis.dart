import '5_his_post.dart';
import '7_first_offer.dart';
import 'package:flutter/material.dart';

class SuccessPost extends StatefulWidget {
  const SuccessPost({super.key});

  @override
  State<SuccessPost> createState() => _SuccessPostState();
}

class _SuccessPostState extends State<SuccessPost> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("โพสต์สำเร็จ"),
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
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
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
                  "โพสต์สำเร็จ",
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => (HistoryPost()),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 255, 17, 0),
                      ),
                      child: Text('ประวัติการโพสต์'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 200,
                  height: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => (OfferRequest()),
                        ));
                      }, //HistoryPost
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 166, 245, 70),
                      ),
                      child: Text('ข้อเสนอที่เข้ามา'),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
