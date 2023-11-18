// import '1.dart';
// import 'package:flutter/material.dart';

// /// Flutter code sample for [BottomNavigationBar].

// void main() => runApp(const createpost());

// class createpost extends StatelessWidget {
//   const createpost({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: create_post(),
//     );
//   }
// }

// class create_post extends StatefulWidget {
//   const create_post({super.key});

//   @override
//   State<create_post> createState() => _create_postState();
// }

// List<String> textFieldValues = [];
// Widget textField(String text) => Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           TextField(
//             obscureText: true,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: text,
//             ),
//             onChanged: (value) {
//               // เมื่อผู้ใช้ป้อนข้อมูลใน TextField
//               textFieldValues.add(value);
//             },
//           ),
//         ],
//       ),
//     );

// class _create_postState extends State<create_post> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           actions: <Widget>[
//             IconButton(
//               icon: Icon(
//                 Icons.notification_important,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 // do something
//               },
//             )
//           ],
//           toolbarHeight: 40,
//           title: Text('สร้างโพสต์'),
//           centerTitle: true,
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('basic_image/image 40.png'),
//                 fit: BoxFit.fill,
//               ),
//             ),
//           ),
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text('gg'),
//               ),
//               textField('gg'),
//               textField('gg'),
//               textField('gg'),
//               textField('gg'),
//               textField('gg'),
//               textField('gg'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
