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
  Map<dynamic, dynamic>?
      selectedPayment; // Variable to hold the selected payment data

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _requestVipRef = FirebaseDatabase.instance.ref().child('requestvip');
    selectedPayment = null; // Initialize selectedPayment as null
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
                  Container(
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
                              Image.network(
                                  selectedPayment!['image_payment'] ?? '',
                                  fit: BoxFit.cover),
                              // Display other details from selectedPayment
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
              // Return a loading or error widget
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
      onTap: () => selectPayment(paymentData),
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: selectedPayment == paymentData
              ? Colors.blue
              : Colors.grey, // Highlight if selected
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: Center(
          child: Text(
            '${index + 1}', // Display the button number
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
