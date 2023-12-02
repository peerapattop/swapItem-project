import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//ต้นฉบับ
class AddImage extends StatefulWidget {
  const AddImage({Key? key}) : super(key: key);

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  List<File> _images = []; // Use File type for image files
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
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
                            takePicture();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.image),
                          onPressed: () {
                            chooseImages();
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

  takePicture() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  chooseImages() async {
    List<XFile> pickedFiles = await picker.pickMultiImage();
    setState(() {
      _images.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
    });
    }
}
