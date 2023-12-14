import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//หน้า 12

class MakeAnOffer extends StatefulWidget {
  const MakeAnOffer({super.key});

  @override
  State<MakeAnOffer> createState() => _MakeAnOfferState();
}

class _MakeAnOfferState extends State<MakeAnOffer> {
  List<File> _images = [];
  final picker = ImagePicker();
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, right: 2, left: 2, bottom: 5),
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
                    SizedBox(
                      height: 15, //height
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
