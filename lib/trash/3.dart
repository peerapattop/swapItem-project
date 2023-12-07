import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ShowAllPostItem extends StatefulWidget {
  const ShowAllPostItem({Key? key}) : super(key: key);

  @override
  _ShowAllPostItemState createState() => _ShowAllPostItemState();
}

class _ShowAllPostItemState extends State<ShowAllPostItem> {
  String? _searchString;
  TextEditingController searchController = TextEditingController();
  final _postRef = FirebaseDatabase.instance.ref().child('postitem');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("จัดการโพสต์"),
        ),
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
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchString = val.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(width: 0.8),
                      ),
                      hintText: "ค้นหา",
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 30,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.clear,
                        ),
                        onPressed: () {
                          setState(() {
                            searchController.clear();
                            _searchString = '';
                          });
                        },
                      ),
                    ),
                  ),
                ),
                //แสดงข้อมูลโพสต์ด้วย GridView
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: dataMap.length,
                    itemBuilder: (context, index) {
                      dynamic userData = dataMap.values.elementAt(index);
                      String postNumber = userData['postNumber'].toString();
                      String username = userData['username'].toString();
                      String email = userData['email'].toString();
                      List<String> imageUrls = List<String>.from(userData['imageUrls'] ?? []);

                      if (_searchString != null &&
                          (_searchString!.isNotEmpty &&
                              (!username
                                  .toLowerCase()
                                  .contains(_searchString!)))) {
                        return Container(); // ไม่แสดงรายการนี้
                      }

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              child: FittedBox(
                                child: Text(postNumber),
                              ),
                            ),
                            Text(username),
                            Text(email),
                            if (imageUrls.isNotEmpty)
                              Image.network(
                                imageUrls.first, // ใช้เฉพาะรูปแรก
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
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
      ),
    );
  }
}
