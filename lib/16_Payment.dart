import '17_PaymentSuccess.dart';
import 'package:flutter/material.dart';
//หน้า16

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("ชำระเงิน"),
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
        body: Column(
          children: [
            Center(
              child: Container(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/images/qrcodepromptpay.jpeg",
                  width: 350,
                  height: 350,
                ),
              )),
            ),
            Text(
              "แพ็คเกจ : 1 เดือน 50 บาท",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Image.asset("assets/images/addimage.png"),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                height: 50,
                width: 250,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => PaymentSuccess()),
                      );
                    },
                    child: Text(
                      "ชำระเงิน",
                      style: TextStyle(fontSize: 20),
                    )))
          ],
        ),
      ),
    );
  }
}
