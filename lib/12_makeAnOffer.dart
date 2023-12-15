import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MakeAnOffer extends StatefulWidget {
  const MakeAnOffer({Key? key}) : super(key: key);

  @override
  State<MakeAnOffer> createState() => _MakeAnOfferState();
}

List<String> category = <String>[
  'เสื้อผ้า',
  'รองเท้า',
  'ของใช้ทั่วไป',
  'อุปกรณ์อิเล็กทรอนิกส์',
  'ของใช้ในบ้าน',
  'อุปกรณ์กีฬา',
  'เครื่องใช้ไฟฟ้า',
  'ของเบ็ดเตล็ด',
];
String dropdownValue = category.first;

class _MakeAnOfferState extends State<MakeAnOffer> {
  final _nameItem1 = TextEditingController();
  final _brand1 = TextEditingController();
  final _model1 = TextEditingController();
  final _detail1 = TextEditingController();

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                // ... Other UI elements here
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Colors.grey,
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    underline: Container(),
                    items:
                        category.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 17,
                ),
                TextField(
                  controller: _nameItem1,
                  decoration: InputDecoration(
                    labelText: 'ชื่อสิ่งของ', // Label text
                    border:
                        OutlineInputBorder(), // Creates a rounded border around the TextField
                    prefixIcon:
                        Icon(Icons.shopping_bag), // Icon inside the TextField
                  ),
                ),
                SizedBox(
                  height: 17,
                ),
                TextField(
                  controller: _brand1,
                  decoration: InputDecoration(
                    labelText: 'ยี่ห้อ', // Label text
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.branding_watermark),
                  ),
                ),
                SizedBox(
                  height: 17,
                ),
                TextField(
                  controller: _model1,
                  decoration: InputDecoration(
                    labelText: 'รุ่น', // Label text
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.model_training),
                  ),
                ),
                SizedBox(
                  height: 17,
                ),
                TextField(
                  controller: _detail1,
                  decoration: InputDecoration(
                    labelText: 'รายละเอียด', // Label text
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.details),
                  ),
                  maxLines: null, // Allows for multi-line input
                ),
                SizedBox(
                  height: 17,
                ),
                SizedBox(
                  height: 7,
                ),
                // ... Other text fields
                Center(
                  child: Container(
                    width: 360,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        _submitOffer();
                      },
                      child: Text(
                        "ยื่นข้อเสนอ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitOffer() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference itemRef =
        FirebaseDatabase.instance.ref().child('offer').push();
    Map dataRef = {
      'uid': uid,
      'type1': dropdownValue,
      'nameitem1': _nameItem1.text.trim(),
      'brand1': _brand1.text.trim(),
      'model1': _model1.text.trim(),
      'detail1': _detail1.text.trim(),
    };
    await itemRef.set(dataRef);
    // Consider adding some feedback to the user after successful submission
  }
}
