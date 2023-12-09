import 'package:intl/intl.dart';

import '18_HistoryPayment.dart';
import 'package:flutter/material.dart';
//ชำระเงินสำเร็จ

// ignore: must_be_immutable
class PaymentSuccess extends StatelessWidget {
  DateTime date;
  DateTime time;

  PaymentSuccess(
      {required this.date, required this.time,});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ชำระเงินสำเร็จ"),
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
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Image.asset(
                  "assets/images/checked.png",
                  width: 100,
                  height: 100,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "ชำระเงินสำเร็จ",
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "รอตรวจสอบที่หน้าประวัติการชำระเงิน",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              
              SizedBox(
                height: 20,
              ),
              Text(
                DateFormat('วันที่ d MMMM yyyy', 'th').format(date),
                style: TextStyle(fontSize: 20),
              ),
              Text(
                DateFormat('เวลา HH:mm น.', 'th').format(time),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HistoryPayment()),
                    );
                  },
                  child: Text("ประวัติการชำระเงิน")),
            ],
          ),
        ),
      ),
    );
  }
}
