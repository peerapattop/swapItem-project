import 'package:intl/intl.dart';
import 'package:swapitem/home_page.dart';
import '18_HistoryPayment.dart';
import 'package:flutter/material.dart';

//หน้าชำระเงินสำเร็จ
class PaymentSuccess extends StatelessWidget {
  DateTime date;
  DateTime time;

  PaymentSuccess({
    super.key,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ชำระเงินสำเร็จ"),
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
          automaticallyImplyLeading:
              false, // ตั้งค่าเป็น false เพื่อไม่แสดงปุ่ม "Back"
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
              const SizedBox(height: 20),
              const Text(
                "ชำระเงินสำเร็จ",
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
              const SizedBox(height: 20),
              const Text(
                "ตรวจสอบสถานะที่หน้าประวัติการชำระเงิน",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 40),
              Text(
                DateFormat('วันที่ d MMMM yyyy', 'th').format(date),
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                DateFormat('เวลา HH:mm น.', 'th').format(time),
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HistoryPayment()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // กำหนดสีพื้นหลังเป็นสีฟ้า
                ),
                child: const Text(
                  "ประวัติการชำระเงิน",
                  style: TextStyle(
                      color: Colors.white,fontSize: 20), // กำหนดสีของข้อความเป็นสีขาว
                ),
              ),
              const SizedBox(height: 50),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.home,
                  color: Colors.blue,
                ),
                label: const Text(
                  'หน้าแรก',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
