import '17_PaymentSuccess.dart';
import 'package:flutter/material.dart';
//หน้า16

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late List<String> package;
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    package = [
      'แพ็คเก็จ 1 เดือน : 50 บาท',
      'แพ็คเก็จ 2 เดือน : 100 บาท',
      'แพ็คเก็จ 3 เดือน : 150 บาท',
    ];
    dropdownValue = package.first;
  }

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
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: Image.asset(
                  "assets/images/qrcodepromptpay.jpeg",
                  width: 225,
                  height: 225,
                ),
              )),
            ),
            Text(
              'บริษัท แลกเปลี่ยนสิ่งของจำกัด มหาชน',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            DropdownMenu<String>(
              width: 260,
              initialSelection: package.first,
              onSelected: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
              dropdownMenuEntries:
                  package.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList(),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(border: Border.all()),
              child: Center(
                child: Image.asset(
                  'assets/images/add_slip.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain, // Adjust the fit as needed
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => PaymentSuccess()),
                      );
                    },
                    child: Text(
                      "ชำระเงิน",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )))
          ],
        ),
      ),
    );
  }
}
