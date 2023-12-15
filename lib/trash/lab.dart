// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
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
//             padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 10),
//                 Container(
//                   height: 300, // Set a fixed height for the GridView
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: Colors.black,
//                       width: 1.0,
//                     ),
//                   ),
//                   child: GridView.builder(
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3,
//                     ),
//                     itemBuilder: (context, index) {
//                       // Your itemBuilder code
//                     },
//                     itemCount: _images.length + 1,
//                   ),
//                 ),
//                 // ... Other UI elements here
//                 // TextFields, DropdownButton, ElevatedButton, etc.
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ... Other methods such as takePicture, chooseImages, _uploadImages, _submitOffer
// }
