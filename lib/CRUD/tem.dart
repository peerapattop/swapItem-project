// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';

// //จากนั้น, ให้ทำการเริ่มต้น Firebase ในฟังก์ชัน main:
// mains() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
// }

// final databaseReference = FirebaseDatabase.instance.reference();

// class ggp {
//   Map postData = {};
//   void createRecord() {
//     databaseReference
//         .child("1")
//         .set({'title': 'Hello World', 'description': 'Welcome to Flutter'});
//   }

//   void _loadPostData() {
//     FirebaseDatabase.instance
//         .ref('postitem/${widget.postUid}')
//         .once()
//         .then((DatabaseEvent databaseEvent) {
//       if (databaseEvent.snapshot.value != null) {
//         setState(() {
//           postData =
//               Map<String, dynamic>.from(databaseEvent.snapshot.value as Map);
//           image_post = List<String>.from(postData['imageUrls'] ?? []);
//         });
//       }
//     }).catchError((error) {
//       // Handle errors here
//     });
//   }

//   void updateData() {
//     databaseReference.child('1').update({'description': 'Flutter is Awesome'});
//   }
// }

// void deleteData() {
//   databaseReference.child('1').remove();
// }
