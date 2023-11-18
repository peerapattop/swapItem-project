import 'package:flutter/material.dart';
//หน้า18

class HistoryPayment extends StatefulWidget {
  const HistoryPayment({super.key});

  @override
  State<HistoryPayment> createState() => _HistoryPaymentState();
}

class _HistoryPaymentState extends State<HistoryPayment> {
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
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
                            SizedBox(
                              width: 10,
                            ),
                            buildCircularNumberButton(2),
                            SizedBox(
                              width: 10,
                            ),
                            buildCircularNumberButton(3),
                            SizedBox(
                              width: 10,
                            ),
                            buildCircularNumberButton(4),
                            SizedBox(
                              width: 10,
                            ),
                            buildCircularNumberButton(5),
                            // เพิ่ม CircularNumberButton อื่น ๆ ตามต้องการ
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                              
                          child: Center(
                              child: Image.asset(
                            "assets/images/slip.jpeg",
                            width: 500,
                            height: 500,
                          )),
                        ),
                        SizedBox(height: 30,),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 217, 217, 216),
                            borderRadius: BorderRadius.circular(
                                12.0), // ทำให้ Container โค้งมน
                          ),
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.tag,
                                    color: Colors.blue,
                                  ), // เพิ่มไอคอนที่นี่

                                  Text(
                                    " หมายเลขการชำระเงิน : PAY-77",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.blue,
                                  ), // เพิ่มไอคอนที่นี่

                                  Text(
                                    " วันที่ : 28/9/2566",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.more_time,
                                    color: Colors.blue,
                                  ), // เพิ่มไอคอนที่นี่

                                  Text(
                                    " เวลา : 08:38 น.",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.menu,
                                    color: Colors.blue,
                                  ), // เพิ่มไอคอนที่นี่

                                  Text(
                                    " แพ็กเกจ : 1 เดือน 50 บาท",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.handyman,
                                    color: Colors.blue,
                                  ), // เพิ่มไอคอนที่นี่

                                  Text(
                                    " สถานะ : รอการตรวจสอบ",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildCircularNumberButton(int number) {
  return InkWell(
    onTap: () {
      // โค้ดที่ต้องการให้ทำงานเมื่อปุ่มถูกกด
    },
    child: Container(
      width: 40, // ปรับขนาดตามต้องการ
      height: 40, // ปรับขนาดตามต้องการ
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black, // สีขอบ
          width: 2.0, // ความกว้างขอบ
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
