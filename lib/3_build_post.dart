import 'dart:io';
import '4_post_finis.dart';
import 'package:flutter/material.dart';
import 'package:swapitem/11_detail.dart';
import 'package:image_picker/image_picker.dart';

List<String> category = <String>[
  'เสื้อผ้า',
  'รองเท้า',
  'ของใช้ทั่วไป',
  'อุปกรณ์อิเล็กทรอนิกส์'
];
String dropdownValue = category.first;

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final item_name = TextEditingController();
  final brand = TextEditingController();
  final model = TextEditingController();
  final details = TextEditingController();
  final exchange_location = TextEditingController();

  final item_name1 = TextEditingController();
  final brand1 = TextEditingController();
  final model1 = TextEditingController();
  final details1 = TextEditingController();
  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("สร้างโพสต์"),
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
            imgPost(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "โปรดกรอกรายละเอียด",
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: Colors.grey,
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
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: item_name,
                      decoration: InputDecoration(
                        labelText: "ชื่อสิ่งของ",
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(),
                        prefixIcon:
                            Icon(Icons.shopping_bag), // Add your desired icon
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: brand,
                      decoration: InputDecoration(
                        label: Text(
                          "ยี่ห้อ",
                          style: TextStyle(fontSize: 20),
                        ),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.tag),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: model,
                      decoration: InputDecoration(
                          label: Text(
                            "รุ่น",
                            style: TextStyle(fontSize: 20),
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.tag)),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: details,
                      decoration: InputDecoration(
                          label: Text(
                            "รายละเอียด",
                            style: TextStyle(fontSize: 20),
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.density_medium_sharp)),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: exchange_location,
                      decoration: InputDecoration(
                          label: Text(
                            "สถานที่แลกเปลี่ยน",
                            style: TextStyle(fontSize: 20),
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_city)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(child: Image.asset('assets/images/swapIMG.png')),
                    const SizedBox(
                      height: 10,
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
                    const SizedBox(
                      height: 15,
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
                            Icons.tag,
                          )),
                    ),
                    SizedBox(
                      height: 15,
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
                            Icons.tag,
                          )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: details1,
                      decoration: InputDecoration(
                          label: Text(
                            "รายละเอียด",
                            style: TextStyle(fontSize: 20),
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.density_medium_sharp)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => (SuccessPost()),
                          ));
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        child: Text(
                          "สร้างโพสต์",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  void takePhoto(ImageSource source) async {
    final dynamic pickedFile = await ImagePicker().pickImage(
      source: source,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });

      // Close the file selection window
      Navigator.pop(context);
    }
  }

  Widget imgPost() {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 60.0,
          backgroundImage: _imageFile != null
              ? FileImage(File(_imageFile!.path))
              : AssetImage('assets/icons/Person-icon.jpg')
                  as ImageProvider<Object>,
        ),
        Positioned(
          bottom: 10.0,
          right: 10.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context, builder: ((Builder) => bottomSheet()));
            },
            child: const Icon(
              Icons.camera_alt,
              color: const Color.fromARGB(255, 52, 0, 150),
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "เลือกรูปภาพของคุณ",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: Icon(Icons.camera),
                label: Text('กล้อง'),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: Icon(Icons.camera),
                label: Text('แกลลอรี่'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
