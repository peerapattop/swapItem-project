// import 'package:flutter/material.dart';
//
// class GradientButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//
//   const GradientButton({
//     Key? key,
//     required this.text,
//     // required this.onPressed,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final databaseReference = FirebaseDatabase.instance.reference();
//     databaseReference
//         .child('offer')
//         .orderByChild('post_uid')
//         .equalTo(post_UID)
//         .once()
//         .then((DataSnapshot snapshot) {
//       Map<dynamic, dynamic> offersMap = snapshot.value;
//
//       if (offersMap != null) {
//         // กรองข้อมูลที่มี "status" เท่ากับ "finish"
//         Map<dynamic, dynamic> filteredOffersMap = {};
//         offersMap.forEach((key, value) {
//           if (value['status'] == "finish") {
//             filteredOffersMap[key] = value;
//           }
//         });
//
//         // ทำอะไรต่อที่นี่กับ filteredOffersMap
//       } else {
//         print("ไม่พบข้อมูลที่ตรงตามเงื่อนไข");
//       }
//     })
//         .catchError((error) {
//       print("เกิดข้อผิดพลาด: $error");
//     });
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 42, vertical: 8.0), // Outer padding for the button
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Color(0xFFf6a5c1), // Light pink
//             Color(0xFF5fadcf), // Light blue
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           primary: Colors.transparent, // Button background color (transparent to show gradient)
//           onPrimary: Colors.white, // Text color
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Inner padding for the button's child
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30),
//           ),
//           elevation: 0,
//           // Ensures that the button has a transparent splash color
//           splashFactory: NoSplash.splashFactory,
//         ),
//         onPressed: onPressed,
//         child: Text(
//           text,
//           style: TextStyle(color: Colors.white), // Text style
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Gradient Button Example'),
//         ),
//         body: Center(
//           child: GradientButton(
//             text: 'Enabled',
//             onPressed: () {
//               // Button press action
//               print('Button pressed!');
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
