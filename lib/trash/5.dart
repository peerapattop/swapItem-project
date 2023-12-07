import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ShowAllPostItem extends StatefulWidget {
  const ShowAllPostItem({Key? key}) : super(key: key);

  @override
  _ShowAllPostItemState createState() => _ShowAllPostItemState();
}

class _ShowAllPostItemState extends State<ShowAllPostItem> {
  TextEditingController searchController = TextEditingController();
  final _postRef = FirebaseDatabase.instance.ref().child('postitem');

  @override
  Widget build(BuildContext context) {
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                  ),
                  itemCount: dataMap.length,
                  itemBuilder: (context, index) {
                    dynamic userData = dataMap.values.elementAt(index);
                    String item_name = userData['item_name'].toString();
                    String item_name1 = userData['item_name1'].toString();
                    List<String> imageUrls =
                        List<String>.from(userData['imageUrls'] ?? []);

                    return Container(
                      width: double.infinity, // ทำให้มีความกว้างเต็มพื้นที่
                      height: 600, // ความยาวของ Container
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 9,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (imageUrls.isNotEmpty)
                            Image.network(
                              imageUrls.first, // ใช้เฉพาะรูปแรก
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          Text('gg'),
                          Text('gg'),
                          // นำเอาข้อมูลที่ต้องการแสดงใน Container นี้มาใส่ตรงนี้
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
