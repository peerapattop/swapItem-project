import 'package:flutter/material.dart';
//หน้า13

class MakeAnOfferSuccess extends StatelessWidget {
  final String offer_id;
  final String date;
  final String time;
  const MakeAnOfferSuccess(
      {required this.offer_id, required this.date, required this.time});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(offer_id),
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
          padding: const EdgeInsets.only(top: 100),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/checked.png",
                  width: 100,
                  height: 100,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "ยื่นข้อเสนอสำเร็จ",
                  style: TextStyle(fontSize: 20, color: Colors.green),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "หมายเลขการยื่นข้อเสนอ /0001",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "$date",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "$time",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: 240,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "ประวัติการยื่นข้อเสนอ",
                        style: TextStyle(fontSize: 20),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
