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
  late DatabaseReference _userRef;
  late DatabaseReference _requestVipRef;
  late String paymentNumber;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _userRef = FirebaseDatabase.instance.ref().child('users').child(_user.uid);
    _requestVipRef =
        FirebaseDatabase.instance.ref().child('requestvip').child(_user.uid);
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
                stream: _userRef.onValue,
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
                  } else {
                    DataSnapshot dataSnapshot = snapshot.data!.snapshot;
                      Map<dynamic, dynamic> dataUser = dataSnapshot.value as Map<dynamic, dynamic>;
                    return StreamBuilder(
                        stream: _requestVipRef.onValue,
                        builder: (context, requestVipSnapshot) {
                          if (requestVipSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (requestVipSnapshot.hasError) {
                            return Center(
                                child:
                                    Text('Error: ${requestVipSnapshot.error}'));
                          } else {
                            DataSnapshot requestVipDataSnapshot =
                                requestVipSnapshot.data!.snapshot;
                            Map<dynamic, dynamic> requestVipData =
                                requestVipDataSnapshot.value
                                    as Map<dynamic, dynamic>;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                      SizedBox(height: 20),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Center(
                                          child: Image.asset(
                                            "assets/images/slip.jpeg",
                                            width: 500,
                                            height: 500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 217, 217, 216),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          children: [
                                            buildInfoRow(Icons.tag,
                                                " หมายเลขการชำระเงิน : PAY-${requestVipData['PaymentNumber']}"),
                                            buildInfoRow(Icons.date_range,
                                                dataUser['date']),
                                            buildInfoRow(Icons.more_time,
                                                " เวลา : 08:38 น."),
                                            buildInfoRow(Icons.menu,
                                                " แพ็กเกจ : 1 เดือน 50 บาท"),
                                            buildInfoRow(Icons.handyman,
                                                " สถานะ : รอการตรวจสอบ"),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        });
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
