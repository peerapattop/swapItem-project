// GridView.builder(
//   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//     crossAxisCount: 2, // จำนวนคอลัมน์
//     childAspectRatio: 3 / 4, // อัตราส่วนความกว้างต่อความสูง
//     crossAxisSpacing: 10, // ระยะห่างระหว่างคอลัมน์
//     mainAxisSpacing: 10, // ระยะห่างระหว่างแถว
//   ),
//   itemCount: 10, // หรือจำนวนของข้อมูลที่คุณมี
//   itemBuilder: (context, index) {
//     return Card(
//       clipBehavior: Clip.antiAlias,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10), // รูปทรงของการ์ด
//       ),
//       elevation: 5, // เงาของการ์ด
//       margin: const EdgeInsets.all(10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           // Assuming you have a method to get image URL for each item
//           // Replace `getImageForItem(index)` with your own method or variable
//           Image.network(
//             getImageForItem(index),
//             fit: BoxFit.cover, // This is to ensure the image covers the card width
//             height: 150, // Set a fixed height for the image
//             width: double.infinity,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'ชื่อ: ชื่อสินค้า', // Replace with your item name
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Text(
//               'ตัวเลือกสินค้า: รายละเอียด', // Replace with your item details
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ),
//           Spacer(), // This will push the button to the end of the card
//           ElevatedButton(
//             onPressed: () {
//               // Handle your button tap here
//             },
//             style: ElevatedButton.styleFrom(
//               primary: Theme.of(context).primaryColor, // This is the background color of the button
//               onPrimary: Colors.white, // This is the foreground color of the button
//             ),
//             child: Text('รายละเอียด'),
//           ),
//         ],
//       ),
//     );
//   },
// );
