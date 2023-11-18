import '18_HistoryPayment.dart';
import 'package:flutter/material.dart';
//หน้า17

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("ชำระเงินสำเร็จ"),
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
              Text(
                "หมายเลขการชำระเงิน #0001",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "วันที่ 9 พฤษภาคม 2566",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "เวลา 19:00 น.",
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
