import 'package:swapitem/_login_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
class RegisPage extends StatefulWidget {
  const RegisPage({Key? key}) : super(key: key);

  @override
  _RegisPageState createState() => _RegisPageState();
}

class _RegisPageState extends State<RegisPage> {
  XFile? _imageFile;
  //final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ลงทะเบียน"),
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
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 15,),
                imgPost(),
                textField('ชื่อ', Icons.person),
                textField('สกุล', Icons.person),
                textField('เพศ', Icons.male),
                textField('วันเกิด', Icons.date_range),
                textField('ชื่อผู้ใช้', Icons.person),
                textField('อีเมล', Icons.email),
                textField('รหัสผ่าน', Icons.password),
                textField('ยืนยันรหัสผ่าน', Icons.password),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 219,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 2, 173, 82),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => (Login()),
                        ));
                      },
                      child: const Text(
                        'ยืนยันการลงทะเบียน',
                        style: TextStyle(
                          color: Colors.white, // Change text color as needed
                          fontSize: 18, // Change font size as needed
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textField(String labelText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 16,right: 16,top: 15),
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: '$labelText',
          labelStyle: const TextStyle(fontSize: 20),
          prefixIcon: Icon(icon), // Use prefixIcon for adding an icon
        ),
      ),
    );
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
        : AssetImage('assets/images/profile_defalt.jpg') as ImageProvider<Object>,

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
