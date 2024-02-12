import 'package:flutter/material.dart';

import '14_HistroryMakeOffer.dart';
import 'home_page.dart';
//หน้ายื่นข้อเสนอสำเร็จ

class MakeAnOfferSuccess extends StatelessWidget {
  final String offer_id;
  final String date;
  final String time;
  final int offerNumber;
  const MakeAnOfferSuccess(
      {super.key, required this.offer_id,
      required this.date,
      required this.time,
      required this.offerNumber});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ยื่นข้อเสนอสำเร็จ'),
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
          automaticallyImplyLeading: false,
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
                const SizedBox(height: 10),
                const Text(
                  "ยื่นข้อเสนอสำเร็จ",
                  style: TextStyle(fontSize: 20, color: Colors.green),
                ),
                const SizedBox(height: 40),
                Text(
                  "หมายเลขการยื่นข้อเสนอ : $offerNumber",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  "วันที่ : $date",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "เวลา : $time น.",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: 240,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HistoryMakeOffer(),
                          ),
                        );
                      },
                      child: const Text(
                        "ประวัติการยื่นข้อเสนอ",
                        style: TextStyle(fontSize: 20),
                      )),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.home),
                    TextButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text('หน้าแรก', style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
