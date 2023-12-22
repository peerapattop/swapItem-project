// @override
// Widget build(BuildContext context) {
//   return SafeArea(
//     child: Scaffold(
//       appBar: AppBar(
//         title: const Text("ข้อเสนอที่เข้ามา"),
//         toolbarHeight: 40,
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/images/image 40.png'),
//               fit: BoxFit.fill,
//             ),
//           ),
//         ),
//       ),
//       body: StreamBuilder(
//         stream: _postRef.orderByChild('uid').equalTo(_user.uid).onValue,
//         builder: (context, snapshot) {
//           // ถ้าข้อมูลยังไม่มา แสดงวงกลมโหลด
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           // ถ้าข้อมูลมาแล้วแต่เป็น null หรือไม่มีข้อมูล
//           if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
//             return Center(
//               child: Text(
//                 'ไม่มีข้อเสนอที่เข้ามา',
//                 style: TextStyle(fontSize: 20),
//               ),
//             );
//           }
//
//           // ถ้ามีข้อมูล สร้าง UI ตามปกติ
//           postsList.clear();
//           Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map);
//           data.forEach((key, value) {
//             postsList.add(Map<dynamic, dynamic>.from(value));
//           });
//
//           // ... ตามด้วยโค้ดที่จัดการ UI อื่นๆ ...
//         },
//       ),
//     ),
//   );
// }
