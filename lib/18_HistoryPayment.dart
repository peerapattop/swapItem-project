//หน้าประวัติการชำระเงิน
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

    _listenToPayments(); // Call function to listen to payment updates
  }

  void _listenToPayments() {
    selectedPayment = null;
    _requestVipRef
        .orderByChild('user_uid')
        .equalTo(_user.uid)
        .onValue
        .listen((event) {
      paymentsList.clear();
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
        Map<dynamic, dynamic>.from(event.snapshot.value as Map);

        data.forEach((key, value) {
          if (true) {
            paymentsList.add(value);
          }
        });

        paymentsList.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

        // Set selectedPayment and selectedIndex to show latest data immediately
        if (paymentsList.isNotEmpty) {
          setState(() {
            selectedPayment = paymentsList.first;
            _selectedIndex = 0;
          });
        }
      }
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while data is being fetched
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('กำลังดาวน์โหลดข้อมูล....'),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              // Handle errors
              return const Center(
                child: Text('Error loading data'),
              );
            } else if (snapshot.hasData &&
                snapshot.data!.snapshot.value != null) {
              paymentsList.clear();
              Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(
                  snapshot.data!.snapshot.value as Map);
              data.forEach((key, value) {
                paymentsList.add(Map<dynamic, dynamic>.from(value));
              });

              return Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: paymentsList.asMap().entries.map((entry) {
                        int idx = entry.key;
                        Map<dynamic, dynamic> paymentData = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: buildCircularNumberButton(idx, paymentData),
                        );
                      }).toList(),
                    ),
                  ),
                  const Divider(),
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
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        (loadingProgress
                                                                .expectedTotalBytes ??
                                                            1)
                                                    : null,
                                              ),
                                              const SizedBox(height: 8),
                                              const Text(
                                                'กำลังดาวน์โหลดรูปภาพ...',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            const Color.fromARGB(255, 217, 217, 216),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.tag,
                                                color: Colors.blue,
                                              ),
                                              const SizedBox(width: 5),
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
                                              const Icon(
                                                Icons.date_range,
                                                color: Colors.blue,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                "วันที่ : ${DateFormat('dd MMMM yyyy', 'th_TH').format(DateTime.parse(selectedPayment!['date']))}",
                                                style: const TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.access_time_outlined,
                                                color: Colors.blue,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                ' เวลา : ${selectedPayment!['time']} น.',
                                                style: const TextStyle(fontSize: 18),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.list,
                                                color: Colors.blue,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                ' แพ็กเกจ : ' +
                                                    selectedPayment!['packed'],
                                                style: TextStyle(fontSize: 18),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.safety_check,
                                                color: Colors.blue,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                ' สถานะ : ' +
                                                    selectedPayment!['status'],
                                                style: const TextStyle(fontSize: 18),
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
                      : const Expanded(
                          child: Center(
                            child: Text(
                                'Please select a payment to view the details'),
                          ),
                        ),
                ],
              );
            } else {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://cdn-icons-png.flaticon.com/256/7152/7152394.png',
                      width: 100,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'ไม่มีประวัติการชำระเงิน',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              );
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
        margin: const EdgeInsets.all(4),
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
            style: const TextStyle(
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
