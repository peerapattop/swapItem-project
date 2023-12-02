import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//ไม่ใช่ตั้นฉบับ

Widget gg() {
  List<File> _images = []; 
  final picker = ImagePicker();

  return 
  Container(
    child: Scaffold(
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return index == 0
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () {
                          takePicture(_images);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.image),
                        onPressed: () {
                          chooseImages(_images);
                        },
                      ),
                    ],
                  ),
                )
              : Image.file(_images[index - 1]); // Display the selected images
        },
        itemCount: _images.length + 1,
      ),
    ),
  );
}

void takePicture(List<File> images) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.camera);

  if (pickedFile != null) {
    images.add(File(pickedFile.path!));
    // Call setState here if needed
  }
}

void chooseImages(List<File> images) async {
  final picker = ImagePicker();
  List<XFile> pickedFiles = await picker.pickMultiImage();
  if (pickedFiles != null) {
    images.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path!)));
    // Call setState here if needed
  }
}
