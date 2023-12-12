// import '12_makeAnOffer.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';

// class DetailItem extends StatelessWidget {
  
//   Map postData = {};
//   final String postUid;
//   DetailItem({required this.postUid});

//   @override
//   void initState() {
//     super.initState();
//     _loadPostData();
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
//         });
//       }
//     }).catchError((error) {
//       // Handle errors here
//     });
//   }

//   final String itemname;
//   // แก้ไขคอนสตรักเตอร์: ลบ 'required' ซ้ำและไม่จำเป็นออก

//   @override
//   Widget build(BuildContext context) {
//     print(itemname); // การปริ้นท์นี้จะแสดงชื่อสินค้าใน Console

//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(itemname),
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
//             padding: const EdgeInsets.only(left: 10, right: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   "หมายเลขการโพสต์ /0001",
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 Image.asset("assets/images/shoes.png"),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "วันที่ 8/8/2566 เวลา 12:00 น.",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     Text(
//                       "ชื่อผู้โพสต์ : Pramepree",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     Text(
//                       "ชื่อสิ่งของ :  รองเท้า",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     Text(
//                       "หมวดหมู่ : ของใช้ส่วนตัว",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     Text(
//                       "รุ่น : Superstar",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     Text(
//                       "รายละเอียด : ไซส์ 40 สภาพการใช้งาน 50 % มีรอยถอกตรงส้นเท้า",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     Text(
//                       "สถานที่แลกเปลี่ยน : BTS อโศก",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Align(
//                       alignment: Alignment.center,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Image.asset("assets/images/swap.png"),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Align(
//                       alignment: Alignment.center,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Image.asset("assets/images/shirt.png"),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Text(
//                       "ชื่อสิ่งของ : เสื้อ",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     Text(
//                       "รุ่น : ST-Shirt",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     Text(
//                       "รายละเอียด : เสื้อมีรอยขาดที่ชายเสื้อ",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Center(
//                       child: Container(
//                         width: 140,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             primary: Color.fromARGB(255, 31, 240,
//                                 35), // ตั้งค่าสีพื้นหลังเป็นสีเขียว
//                           ),
//                           onPressed: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                   builder: (context) => MakeAnOffer()),
//                             );
//                           },
//                           child: Text(
//                             "ยื่นข้อเสนอ",
//                             style: TextStyle(
//                               color: Colors.white, // ตั้งค่าสีข้อความเป็นสีดำ
//                               fontSize: 18, // ตั้งค่าขนาดข้อความ
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
