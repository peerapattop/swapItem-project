// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';

// class MyGridView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('GridView Example'),
//       ),
//       body: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, // Number of columns
//           mainAxisSpacing: 16.0, // Spacing between rows
//           crossAxisSpacing: 16.0, // Spacing between columns
//         ),
//         itemBuilder: (context, index) {
//           // Replace this with the widget you want to display in each grid item
//           return Card(
//             child: Center(
//               child: Text('Item $index'),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: MyGridView(),
//   ));
// }


 
// void main() => runApp(const MyApp());
 
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
 
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text("Container example"),
//         ),
//         body: Container(
//           height: 200,
//           width: double.infinity,
//           color: Colors.purple,
//           child: const Text("Hello! i am inside a container!",
//               style: TextStyle(fontSize: 20)),
//         ),
//       ),
//     );
//   }
// }