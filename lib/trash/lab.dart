// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';

// class MakeAnOffer extends StatefulWidget {
//   const MakeAnOffer({Key? key}) : super(key: key);

//   @override
//   State<MakeAnOffer> createState() => _MakeAnOfferState();
// }

// class _MakeAnOfferState extends State<MakeAnOffer> {
//   final _nameItem1 = TextEditingController();
//   final _brand1 = TextEditingController();
//   final _model1 = TextEditingController();
//   final _detail1 = TextEditingController();
//   final picker = ImagePicker();
//   List<File> _images = [];
//   void removeImage(int index) {
//     setState(() {
//       _images.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("ยื่นข้อเสนอ"),
//           toolbarHeight: 40,
//           centerTitle: true,
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/image 40.png'),
//                 fit: BoxFit.fill,
//               ),
//             ),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 10),
//                 Container(
//                   height: 200, // Set a fixed height for the GridView
//                   child: Expanded(
//                     child: GridView.builder(
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                       ),
//                       itemBuilder: (context, index) {
//                         return index == 0
//                             ? Center(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     IconButton(
//                                       icon: Icon(Icons.camera_alt),
//                                       onPressed: _images.length < 5
//                                           ? takePicture
//                                           : null,
//                                     ),
//                                     IconButton(
//                                       icon: Icon(Icons.image),
//                                       onPressed: _images.length < 5
//                                           ? chooseImages
//                                           : null,
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : Stack(
//                                 children: [
//                                   Image.file(
//                                     _images[index - 1],
//                                   ),
//                                   Positioned(
//                                     top: 0,
//                                     right: 0,
//                                     child: IconButton(
//                                       icon: Icon(Icons.close),
//                                       onPressed: () => removeImage(index - 1),
//                                     ),
//                                   ),
//                                 ],
//                               ); // Display the selected images with delete button
//                       },
//                       itemCount: _images.length + 1,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 17),
//                 // Dropdown, TextFields, and other widgets...
//                 // Rest of your UI code
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   takePicture() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);

//     if (pickedFile != null) {
//       setState(() {
//         _images.add(File(pickedFile.path));
//       });
//     }
//   }

//   chooseImages() async {
//     List<XFile> pickedFiles = await picker.pickMultiImage();
//     setState(() {
//       _images.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
//     });
//   }
//   // Functions like removeImage, takePicture, chooseImages, and _submitOffer go here
//   // ...
// }
