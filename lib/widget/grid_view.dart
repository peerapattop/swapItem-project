import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:swapitem/detailPost_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_database/firebase_database.dart';

class ShowAllPostItem extends StatefulWidget {
  const ShowAllPostItem({Key? key}) : super(key: key);

  @override
  _ShowAllPostItemState createState() => _ShowAllPostItemState();
}

class _ShowAllPostItemState extends State<ShowAllPostItem> {
  TextEditingController searchController = TextEditingController();
  final _postRef = FirebaseDatabase.instance.ref().child('postitem');
  String? formattedDateTime;
  @override
  Widget build(BuildContext context) {
    String locale = 'th_TH';
    initializeDateFormatting(locale).then((_) {
      DateTime dateTime = DateTime.now();
      formattedDateTime = DateFormat.yMd(locale).add_jm().format(dateTime);
    });
    return Scaffold(
      body: StreamBuilder(
        stream: _postRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text("ไม่มีข้อมูล"),
            );
          }
          DataSnapshot dataSnapshot = snapshot.data!.snapshot;
          Map<dynamic, dynamic>? dataMap = dataSnapshot.value as Map?;

          if (dataMap == null || dataMap.isEmpty) {
            return const Center(
              child: Text("ไม่มีข้อมูล"),
            );
          }

          return Column(
            children: <Widget>[
              // แสดงข้อมูลโพสต์ด้วย GridView
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(
                    left: 3,
                    right: 3,
                    top: 3,
                    bottom: 150, // เพิ่มค่านี้ให้มากพอที่จะมองเห็นปุ่ม
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // จำนวนคอลัมน์
                    childAspectRatio: 3 / 5.5, // อัตราส่วนความกว้างต่อความสูง
                    crossAxisSpacing: 3, // ระยะห่างระหว่างคอลัมน์
                    mainAxisSpacing: 3, // ระยะห่างระหว่างแถว
                  ),
                  itemCount: dataMap.length, // หรือจำนวนของข้อมูลที่คุณมี
                  itemBuilder: (context, index) {
                    dynamic userData = dataMap.values.elementAt(index);
                    String item_name = userData['item_name'].toString();
                    String item_name1 = userData['item_name1'].toString();
                    String post_uid = userData['post_uid'].toString();
                    String lati = userData['latitude'].toString();
                    String longti = userData['longitude'].toString();
                    String imageUser = userData['imageUser'];
                    List<String> imageUrls =
                        List<String>.from(userData['imageUrls'] ?? []);
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // รูปทรงของการ์ด
                      ),
                      elevation: 5, // เงาของการ์ด
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Assuming you have a method to get image URL for each item
                          // Replace `getImageForItem(index)` with your own method or variable

                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'ชื่อสิ่งของ: $item_name', // Replace with your item name
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          if (imageUrls.isNotEmpty)
                            Center(
                              child: AspectRatio(
                                aspectRatio:
                                    1 / 1, // Ensure the image is square
                                child: Image.network(
                                  imageUrls.first,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: Text(
                                'ต้องการแลกเปลี่ยนกับ', // Replace with your item details
                                style: TextStyle(
                                  fontSize: 14,
                                  color: const Color.fromARGB(255, 22, 22, 22),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Center(
                              child: Text(
                                '$item_name1', // Replace with your item details
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                          Spacer(), // This will push the button to the end of the card
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // ตรวจสอบว่าตัวแปร item_name ถูกกำหนดค่าไว้แล้วในส่วนของโค้ดที่เหมาะสม

                                // Add a delay using Future.delayed
                                Future.delayed(Duration(seconds: 1), () {
                                  // หน่วงเวลา 1 วินาที
                                  // After the delay, navigate to the new screen
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ShowDetailAll(
                                          postUid: post_uid,
                                          longti: longti,
                                          lati:lati,
                                          imageUser:imageUser),
                                    ),
                                  );
                                });

                                // Handle your button tap here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .primaryColor, // This is the background color of the button
                                foregroundColor: Colors
                                    .white, // This is the foreground color of the button
                              ),
                              child: Center(child: Text('รายละเอียด')),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
