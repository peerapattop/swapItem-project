// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('ตาราง 4x4 พร้อมขอบดำ'),
//         ),
//         body: Center(
//           child: GridView.builder(
//             itemCount: 16, // 4x4 มีทั้งหมด 16 ช่อง
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 4, // จำนวนคอลัมน์
//               childAspectRatio: 1.0, // สัดส่วนของแต่ละช่อง
//             ),
//             itemBuilder: (context, index) {
//               return Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black), // เส้นขอบดำ
//                 ),
//                 child: Center(
//                   child: Text(
//                     (index + 1).toString(), // แสดงข้อความตามลำดับ
//                     style: TextStyle(fontSize: 24.0), // ขนาดข้อความ
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }



// Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'โควตาการโพสต์ 5/5 เดือน',
//                       style: TextStyle(height: 2, fontSize: 17),
//                     ),
//                     Text(
//                       'โควตาการแลก 5/5 เดือน',
//                       style: TextStyle(height: 2, fontSize: 17),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 200,
//                       height: 200,
//                       alignment: Alignment.center,
//                       margin: EdgeInsets.all(25),
//                       decoration: BoxDecoration(
//                         color: Colors.black12,
//                         border: Border.all(
//                           color: Colors.black,
//                           width: 2,
//                         ),
//                         shape: BoxShape.circle, // เปลี่ยนเป็นวงกลม
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),