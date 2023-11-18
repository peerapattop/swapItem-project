import '10_chat.dart';
import '8_delete_post.dart';
import '6_first_succ_swap.dart';
import 'package:flutter/material.dart';

const List<String> people = <String>[
  'ข้อเสนอคนที่ 1',
  'ข้อเสนอคนที่ 2',
  'ข้อเสนอคนที่ 3',
  'ข้อเสนอคนที่ 4'
];
String dropdownValue = people.first;

class OfferRequest extends StatefulWidget {
  const OfferRequest({super.key});

  @override
  State<OfferRequest> createState() => _OfferRequestState();
}

class _OfferRequestState extends State<OfferRequest> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("ข้อเสนอที่เข้ามา"),
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
          body: SingleChildScrollView(
              child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // ตั้งค่าให้ชิดซ้าย
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            "หมายเลขการโพสต์ /0001",
                            style: MyTextStyle(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.end, // ตั้งค่าให้ชิดขวา
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => (DeletePost()),
                                ));
                              },
                              icon: Icon(Icons.delete),
                              label: Text("ลบโพสต์")),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.center, // ตั้งค่าให้ชิดซ้าย
                      children: [
                        Image.asset(
                          "assets/images/boots_post.png",
                          width: 200,
                          height: 200,
                        ),
                      ],
                    ), //88
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // ตั้งค่าให้ชิดซ้าย
                        children: [
                          Text(
                            "ชื่อสิ่งของ :  รองเท้า",
                            style: MyTextStyle(),
                          ),
                          Text(
                            "หมวดหมู่ : รองเท้า",
                            style: MyTextStyle(),
                          ),
                          Text(
                            "ยี่ห้อ : Adidas",
                            style: MyTextStyle(),
                          ),
                          Text(
                            "รุ่น :  Superstar",
                            style: MyTextStyle(),
                          ),
                          Text(
                            'รายละเอียด : ไซส์ 40 สภาพการใช้งาน 50%',
                            style: MyTextStyle(),
                          ),
                          Text(
                            "ต้องการแลกเปลี่ยนกับ :  เสื้อ",
                            style: MyTextStyle(),
                          ),
                          Text(
                            'รายละเอียด : เสื้อไซส์ L ยี่ห้อ lacoste',
                            style: MyTextStyle(),
                          ),
                          Text(
                            "สถานที่แลกเปลี่ยน : รถไฟฟ้าสถานี่อโศก",
                            style: MyTextStyle(),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/images/66666.png",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // ตั้งค่าให้ชิดซ้าย
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            width: 200,
                            child: Column(
                              children: [
                                DropdownMenu<String>(
                                  width: 170,
                                  initialSelection: people.first,
                                  onSelected: (String? value) {
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  },
                                  dropdownMenuEntries:
                                      people.map<DropdownMenuEntry<String>>(
                                    (String value) {
                                      return DropdownMenuEntry<String>(
                                        value: value,
                                        label: value,
                                      );
                                    },
                                  ).toList(),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Image.asset(
                                  'assets/images/shirt.png',
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => (ChangeSuccess()),
                                    ));
                                  },
                                  child: Text("ยืนยันการแลกเปลี่ยน"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => (Chat()),
                                    ));
                                  },
                                  child: Text("แชท"),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // ตั้งค่าให้ชิดขวา
                      children: [
                        Text(
                          "เลขที่ผู้ยื่นข้อเสนอ",
                          style: MyTextStyle(),
                        ),
                        Text(
                          "#01",
                          style: MyTextStyle(),
                        ),
                        Text(
                          "วันที่ 9/8/2999",
                          style: MyTextStyle(),
                        ),
                        Text(
                          "เวลา 13:00 น.",
                          style: MyTextStyle(),
                        ),
                        Text(
                          "ชื่อคนเสนอ : Simpson",
                          style: MyTextStyle(),
                        ),
                        Text(
                          "ชื่อสิ่งของที่จะแลก : เสื้อ",
                          style: MyTextStyle(),
                        ),
                        Text(
                          "รายละเอียด : เสื้อแบรนด์ตะขาบ",
                          style: MyTextStyle(),
                        ),
                        Text(
                          "คำอธิบายภาพ : สภาพ 70%",
                          style: MyTextStyle(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ))),
    );
  }
}

MyTextStyle() {
  return TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
}
