
import 'package:flutter/material.dart';
//หน้า 12

class MakeAnOffer extends StatefulWidget {
  const MakeAnOffer({super.key});

  @override
  State<MakeAnOffer> createState() => _MakeAnOfferState();
}

class _MakeAnOfferState extends State<MakeAnOffer> {
  List<String> category = <String>[
    'เสื้อผ้า',
    'รองเท้า',
    'ของใช้ทั่วไป',
    'อุปกรณ์อิเล็กทรอนิกส์'
  ];
  String dropdownValue = 'เสื้อผ้า';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("ยื่นข้อเสนอ"),
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
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "หมายเลขการโพสต์ /0001",
                  style: TextStyle(fontSize: 18),
                ),
                Image.asset("assets/images/shoes.png"),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "วันที่ 8/8/2566 เวลา 12:00 น.",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "ชื่อผู้โพสต์ : Pramepree",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "หมวดหมู่ : ของใช้ส่วนตัว",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "ชื่อสิ่งของ :  รองเท้า",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "ยี่ห้อ : Converse",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "รุ่น : Superstar",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "รายละเอียด : ไซส์ 40 สภาพการใช้งาน 50 % มีรอยถอกตรงส้นเท้า",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "สถานที่แลกเปลี่ยน : BTS อโศก",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/images/swap.png"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/images/shirt.png"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownMenu<String>(
                        initialSelection: category.first,
                        onSelected: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        dropdownMenuEntries: category
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                              value: value, label: value);
                        }).toList(),
                      ),
                    ),
                    ShowDataOffer("ชื่อสิ่งของ"),
                    ShowDataOffer("ยี่ห้อ"),
                    ShowDataOffer("รุ่น"),
                    ShowDataOffer("รายละเอียด"),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        width: 360,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 31, 240,
                                35), // ตั้งค่าสีพื้นหลังเป็นสีเขียว
                          ),
                          onPressed: () {},
                          child: Text(
                            "ยื่นข้อเสนอ",
                            style: TextStyle(
                              color: Colors.white, // ตั้งค่าสีข้อความเป็นสีดำ
                              fontSize: 18, // ตั้งค่าขนาดข้อความ
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget ShowDataOffer(String label) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelText: '$label',
        labelStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        hintStyle: TextStyle(
          fontStyle: FontStyle.italic,
        ),
        fillColor: Colors.grey[200],
        filled: true,
      ),
    ),
  );
}
