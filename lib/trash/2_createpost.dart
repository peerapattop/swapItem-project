import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

class testImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Image Upload',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageUploadPage(),
    );
  }
}

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pickImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = selectedImage;
    });
  }

  Future<void> _uploadImage() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    if (_image == null) return;

    final File file = File(_image!.path);
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference ref = storage.ref().child('images/$fileName');

    try {
      await ref.putFile(file);
      final String downloadUrl = await ref.getDownloadURL();

      final DatabaseReference dbRef = FirebaseDatabase.instance.ref('offer');
      await dbRef.push().set({'url': downloadUrl, 'name': fileName});

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Image uploaded successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Image Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image != null
                ? Image.file(File(_image!.path))
                : Text('No image selected'),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
