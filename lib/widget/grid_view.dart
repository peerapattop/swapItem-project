import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../detailPost_page.dart';

class GridView2 extends StatefulWidget {
  final String? searchString;
  const GridView2({Key? key, this.searchString}) : super(key: key);

  @override
  State<GridView2> createState() => _GridView2State();
}

class _GridView2State extends State<GridView2> {
  User? user = FirebaseAuth.instance.currentUser;
  final _postRef = FirebaseDatabase.instance.ref().child('postitem');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _postRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text("No data available"),
            );
          }

          DataSnapshot dataSnapshot = snapshot.data!.snapshot;
          Map<dynamic, dynamic>? dataMap = dataSnapshot.value as Map?;

          if (dataMap != null) {
            List<dynamic> filteredData = dataMap.values.toList();

            filteredData = dataMap.values
                .where((userData) =>
            widget.searchString == null ||
                widget.searchString!.isEmpty ||
                userData['item_name']
                    .toString()
                    .toLowerCase()
                    .contains(widget.searchString!.toLowerCase()) ||
                userData['item_name1']
                    .toString()
                    .toLowerCase()
                    .contains(widget.searchString!.toLowerCase()))
                .toList();

            filteredData.sort((a, b) {
              String statusA =
                  a['status_user'] ?? ''; // Use an empty string if status is null
              String statusB =
                  b['status_user'] ?? ''; // Use an empty string if status is null

              // Prioritize 'ผู้ใช้พรีเมี่ยม' cards first
              if (statusA == 'ผู้ใช้พรีเมี่ยม' && statusB != 'ผู้ใช้พรีเมี่ยม') {
                return -1; // Move card A (VIP) to the front
              } else if (statusA != 'ผู้ใช้พรีเมี่ยม' &&
                  statusB == 'ผู้ใช้พรีเมี่ยม') {
                return 1; // Move card B (VIP) to the front
              } else {
                return 0; // No priority change for other cases
              }
            });

            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 6.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                dynamic userData = filteredData[index];
                String item_name = userData['item_name'].toString();
                String item_name1 = userData['item_name1'].toString();
                String post_uid = userData['post_uid'].toString();
                String lati = userData['latitude'].toString();
                String longti = userData['longitude'].toString();
                String imageUser = userData['imageUser'];
                String userUid = userData['uid'];
                bool isVip = userData['status_user'] == 'ผู้ใช้พรีเมี่ยม';

                List<String> imageUrls =
                List<String>.from(userData['imageUrls'] ?? []);
                return Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              if (isVip) Image.asset('assets/images/vip.png'),
                              Text(
                                'ชื่อสิ่งของ: $item_name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (imageUrls.isNotEmpty)
                        Center(
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Center(
                          child: Text(
                            'แลกเปลี่ยนกับ',
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
                            '$item_name1',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: user?.uid != userUid
                            ? ElevatedButton(
                          onPressed: () {
                            Future.delayed(Duration(seconds: 1), () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ShowDetailAll(
                                    postUid: post_uid,
                                    longti: longti,
                                    lati: lati,
                                    imageUser: imageUser,
                                  ),
                                ),
                              );
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: Center(child: Text('รายละเอียด')),
                        )
                            : const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'โพสต์ของฉัน',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text("No data available"),
            );
          }
        },
      ),
    );
  }
}