import 'package:flutter/material.dart';
//หน้า14

class HistoryMakeOffer extends StatelessWidget {
  const HistoryMakeOffer({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ประวัติการยื่นข้อเสนอ"),
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
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align children to the left
            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align children to the left
                children: [
                  const SizedBox(
                    height: 20,
                  ),
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
                  const SizedBox(
                    height: 15,
                  ),
                  Center(child: Image.asset("assets/images/shirt.png")),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Row(
                          children: [
                            const Icon(
                              Icons.person, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                              color:
                                  Colors.blue, // เปลี่ยนสีไอคอนตามความต้องการ
                            ),
                            const SizedBox(
                                width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
                            Text(
                              "ชื่อ : Peerapat",
                              style: myTextStyle(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.date_range, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                              color:
                                  Colors.blue, // เปลี่ยนสีไอคอนตามความต้องการ
                            ),
                            const SizedBox(
                                width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
                            Text(
                              "วันที่ 9/8/2999",
                              style: myTextStyle(),
                            ),
                          ],
                        ),
                        Row(
                      children: [
                        const Icon(
                          Icons.punch_clock, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                          color: Colors.blue, // เปลี่ยนสีไอคอนตามความต้องการ
                        ),
                        const SizedBox(
                            width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
                        Text(
                          "เวลา 13:00 น.",
                          style: myTextStyle(),
                        ),
                      ],
                    ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 2, right: 15, top: 10, bottom: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 170, 170, 169),
                              borderRadius: BorderRadius.circular(
                                  12.0), // ทำให้ Container โค้งมน
                            ),
                            padding: EdgeInsets.all(
                                16), // ระยะห่างของเนื้อหาจาก Container
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ชื่อสิ่งของ :  เสื้อ",
                                  style: myTextStyle(),
                                ),
                                Text(
                                  "หมวดหมู่ : เสื้อผ้า",
                                  style: myTextStyle(),
                                ),
                                Text(
                                  "ยี่ห้อ : ตะขาบ",
                                  style: myTextStyle(),
                                ),
                                Text(
                                  "รุ่น :  T-Shire",
                                  style: myTextStyle(),
                                ),
                                Text(
                                  'รายละเอียด :สภาพการใช้งาน 50%',
                                  style: myTextStyle(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Center(child: Image.asset("assets/images/swap.png")),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset("assets/images/shoes.png"),
                    ),
                     Row(
                      children: [
                        const Icon(
                          Icons.water_outlined, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                          color: Colors.blue, // เปลี่ยนสีไอคอนตามความต้องการ
                        ),
                        const SizedBox(
                            width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
                        Text(
                          "สถานะ : รอการยืนยัน",
                          style: myTextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.tag, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                          color: Colors.blue, // เปลี่ยนสีไอคอนตามความต้องการ
                        ),
                        const SizedBox(
                            width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
                        Text(
                          "หมายเลขโพสต์ #0001",
                          style: myTextStyle(),
                        ),  
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.person, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                          color: Colors.blue, // เปลี่ยนสีไอคอนตามความต้องการ
                        ),
                        const SizedBox(
                            width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
                        Text(
                          "ชื่อผู้โพสต์ : Pramepree",
                          style: myTextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.date_range, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                          color: Colors.blue, // เปลี่ยนสีไอคอนตามความต้องการ
                        ),
                        const SizedBox(
                            width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
                        Text(
                          "วันที่ 9/8/2999",
                          style: myTextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.punch_clock, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                          color: Colors.blue, // เปลี่ยนสีไอคอนตามความต้องการ
                        ),
                        const SizedBox(
                            width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
                        Text(
                          "เวลา 13:00 น.",
                          style: myTextStyle(),
                        ),
                      ],
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 2, right: 15, top: 10, bottom: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 170, 170, 169),
                          borderRadius: BorderRadius.circular(
                              12.0), // ทำให้ Container โค้งมน
                        ),
                        padding: EdgeInsets.all(
                            16), // ระยะห่างของเนื้อหาจาก Container
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ชื่อสิ่งของ : รองเท้า",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              "ยี่ห้อ : adidas",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              "รุ่น : superstar",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              "รายละเอียด : รองเท้าไซร์ 40",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              'สถานที่แลกเปลี่ยน : BTS สนามกีฬา',
                              style: myTextStyle(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          width: 350,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.chat,color: Colors.white),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(16),
                                  backgroundColor:
                                      Color.fromARGB(255, 10, 41, 164)),
                              label: Text(
                                "แชท",
                                style: TextStyle(fontSize: 16,color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          width: 350,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.delete,color: Colors.white),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(16),
                                  backgroundColor:
                                      Color.fromARGB(255, 248, 1, 1)),
                              label: Text(
                                "ลบ",
                                style: TextStyle(fontSize: 16,color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

myTextStyle() {
  return const TextStyle(
    fontSize: 20,
    color: Colors.black,
  );
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
