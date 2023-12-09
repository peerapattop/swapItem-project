//หน้าประวัติการชำระเงิน
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HistoryPayment extends StatefulWidget {
  const HistoryPayment({Key? key}) : super(key: key);

  @override
  State<HistoryPayment> createState() => _HistoryPaymentState();
}

class _HistoryPaymentState extends State<HistoryPayment> {
  late User _user;
  late DatabaseReference _requestVipRef;
  late String paymentNumber;

  @override
  void initState() {
    super.initState();
    super.initState();
    initializeUser();
  }

  void initializeUser() {
    _user = FirebaseAuth.instance.currentUser!;

    _requestVipRef = FirebaseDatabase.instance.ref().child('requestvip');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ประวัติการชำระเงิน"),
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
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: StreamBuilder(
                stream: _requestVipRef
                    .orderByChild('user_uid')
                    .equalTo(_user.uid)
                    .onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 350,
                          ),
                          CircularProgressIndicator(),
                          Text('กำลังโหลดข้อมูล...')
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data!.snapshot.value == null) {
                    return Center(child: Text('ไม่มีประวัติการชำระเงิน'));
                  } else {
                    Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(
                        snapshot.data!.snapshot.value as Map);
                    // ตัวอย่างนี้สมมติว่าเราเข้าถึง record แรกที่เจอ (แต่อาจมีหลาย records)
                    Map<dynamic, dynamic> paymentData =
                        data.values.firstWhere((v) => true, orElse: () => {});
                    String status = paymentData['status'];
                    String paymentNumber = paymentData['PaymentNumber'];
                    String time = paymentData['time'];
                    String packed = paymentData['packed'];
                    String image_payment = paymentData['image_payment'];
                    String date = paymentData['date'];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  buildCircularNumberButton(1),
                                  SizedBox(width: 10),
                                  buildCircularNumberButton(2),
                                  SizedBox(width: 10),
                                  buildCircularNumberButton(3),
                                  SizedBox(width: 10),
                                  buildCircularNumberButton(4),
                                  SizedBox(width: 10),
                                  buildCircularNumberButton(5),
                                ],
                              ),
                              SizedBox(height: 5),
                              Divider(),
                              SizedBox(height: 5),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Center(
                                  child: Image.network(
                                    image_payment,
                                    width: 500,
                                    height: 500,
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 217, 217, 216),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    buildInfoRow(Icons.tag,
                                        " หมายเลขการชำระเงิน : PAY-$paymentNumber"),
                                    buildInfoRow(Icons.date_range, ' วันที่ : $date'),
                                    buildInfoRow(
                                        Icons.more_time, " เวลา : $time น."),
                                    buildInfoRow(Icons.menu, " $packed"),
                                    buildInfoRow(
                                        Icons.handyman, " สถานะ : $status"),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCircularNumberButton(int number) {
    return InkWell(
      onTap: () {
        // โค้ดที่ต้องการให้ทำงานเมื่อปุ่มถูกกด
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: Center(
          child: Text(
            '$number',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        Text(text, style: TextStyle(fontSize: 20)),
      ],
    );
  }
}
