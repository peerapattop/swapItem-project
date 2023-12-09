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
  List<Map<dynamic, dynamic>> paymentsList = [];
  int _selectedIndex = -1;
  Map<dynamic, dynamic>? selectedPayment;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _requestVipRef = FirebaseDatabase.instance.ref().child('requestvip');
    selectedPayment = null;
  }

  void selectPayment(Map<dynamic, dynamic> paymentData) {
    setState(() {
      selectedPayment =
          paymentData; // Update selectedPayment with the chosen data
    });
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
        body: StreamBuilder(
          stream: _requestVipRef
              .orderByChild('user_uid')
              .equalTo(_user.uid)
              .onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              paymentsList.clear();
              Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(
                  snapshot.data!.snapshot.value as Map);
              data.forEach((key, value) {
                paymentsList.add(Map<dynamic, dynamic>.from(value));
              });

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50, // Fixed height for the button container
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: paymentsList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: buildCircularNumberButton(
                              index, paymentsList[index]),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  // Check if selectedPayment is not null and then display its details
                  selectedPayment != null
                      ? Expanded(
                          child: ListView(
                            children: [
                              Column(
                                children: [
                                  Image.network(
                                    selectedPayment!['image_payment'],
                                    fit: BoxFit.cover,
                                    width: 300,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 217, 217, 216),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.tag),
                                              Text(
                                                ' หมายเลขการชำระเงิน PAY-' +
                                                    selectedPayment![
                                                        'PaymentNumber'],
                                                style: TextStyle(fontSize: 18),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.date_range),
                                              Text(
                                                ' วันที่ : ' +
                                                    selectedPayment!['date'],
                                                style: TextStyle(fontSize: 18),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.timelapse),
                                              Text(
                                                ' เวลา : ${selectedPayment!['time']} น.',
                                                style: TextStyle(fontSize: 18),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.list),
                                              Text(
                                                ' แพ็กเกจ : ' +
                                                    selectedPayment!['packed'],
                                                style: TextStyle(fontSize: 18),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.safety_check),
                                              Text(
                                                ' สถานะ : ' +
                                                    selectedPayment!['status'],
                                                style: TextStyle(fontSize: 18),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: Center(
                              child: Text(
                                  'Please select a payment to view the details')),
                        ),
                ],
              );
            } else {
              return Center(child: Text('Loading or error state'));
            }
          },
        ),
      ),
    );
  }

  Widget buildCircularNumberButton(
      int index, Map<dynamic, dynamic> paymentData) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index; // Update the selected index
          selectedPayment = paymentData; // Update the selected payment data
        });
      },
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _selectedIndex == index
              ? Colors.blue
              : Colors.grey, // Highlight if selected
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
