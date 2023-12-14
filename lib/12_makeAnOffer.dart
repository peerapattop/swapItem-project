import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MakeAnOffer extends StatefulWidget {
  const MakeAnOffer({super.key});

  @override
  State<MakeAnOffer> createState() => _MakeAnOfferState();
}

Future<void> _MakeAnOfferState1(BuildContext context) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference itemRef =
        FirebaseDatabase.instance.ref().child('offer').push();
    await itemRef.set(uid);
  } catch (error) {
    print('Error in buildPost: $error');
    Navigator.pop(context);
  }
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
  final nameitem1 = TextEditingController();
  final brand1 = TextEditingController();
  final model1 = TextEditingController();
  final detail1 = TextEditingController();
  List<File> _images = [];
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var item_name1;
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, right: 2, left: 2, bottom: 5),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          width: 370,
                          height: 280,
                          child: Column(
                            children: [
                              Expanded(
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                                  itemBuilder: (context, index) {
                                    return index == 0
                                        ? Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.camera_alt),
                                                  onPressed: _images.length < 5
                                                      ? takePicture
                                                      : null,
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.image),
                                                  onPressed: _images.length < 5
                                                      ? chooseImages
                                                      : null,
                                                ),
                                              ],
                                            ),
                                          )
                                        : Stack(
                                            children: [
                                              Image.file(
                                                _images[index - 1],
                                              ),
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: IconButton(
                                                  icon: Icon(Icons.close),
                                                  onPressed: () =>
                                                      removeImage(index - 1),
                                                ),
                                              ),
                                            ],
                                          ); // Display the selected images with delete button
                                  },
                                  itemCount: _images.length + 1,
                                ),
                              ),
                              Text(
                                '${_images.length}/5',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15, //height
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          underline:
                              Container(), // Remove the default underline
                          items: category
                              .map<DropdownMenuItem<String>>((String value) {
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
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    TextField(
                      controller: item_name1,
                      decoration: InputDecoration(
                          label: Text(
                            "ชื่อสิ่งของ",
                            style: TextStyle(fontSize: 20),
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.shopping_bag,
                          )),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    TextField(
                      controller: brand1,
                      decoration: InputDecoration(
                          label: Text(
                            "ยี่ห้อ",
                            style: TextStyle(fontSize: 20),
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.shopping_bag,
                          )),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    TextField(
                      controller: model1,
                      decoration: InputDecoration(
                          label: Text(
                            "รุ่น",
                            style: TextStyle(fontSize: 20),
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.shopping_bag,
                          )),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    TextField(
                      controller: detail1,
                      decoration: InputDecoration(
                          label: Text(
                            "รายละเอียด",
                            style: TextStyle(fontSize: 20),
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.shopping_bag,
                          )),
                    ),
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
                          onPressed: () {
                            _MakeAnOfferState1(context);
                          },
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

  chooseImages() async {
    List<XFile> pickedFiles = await picker.pickMultiImage();
    setState(() {
      _images.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
    });
  }

  takePicture() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }
}
