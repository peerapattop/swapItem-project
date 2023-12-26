import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:swapitem/detailPost_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_database/firebase_database.dart';

class ShowAllPostItem extends StatefulWidget {
  final String? searchString;

  const ShowAllPostItem({Key? key, this.searchString}) : super(key: key);

  @override
  _ShowAllPostItemState createState() => _ShowAllPostItemState();
}

class _ShowAllPostItemState extends State<ShowAllPostItem> {
  TextEditingController searchController = TextEditingController();
  final _postRef = FirebaseDatabase.instance.ref().child('postitem');
  String? formattedDateTime;
  List<dynamic> filteredData = []; // Store data that matches the search

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
              child: Text("No data available"),
            );
          }
          DataSnapshot dataSnapshot = snapshot.data!.snapshot;
          Map<dynamic, dynamic>? dataMap = dataSnapshot.value as Map?;

          if (dataMap == null || dataMap.isEmpty) {
            return const Center(
              child: Text("No data available"),
            );
          }
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

          return Column(
            children: <Widget>[
              if (widget.searchString == null || widget.searchString!.isEmpty)
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(
                      left: 3,
                      right: 3,
                      top: 3,
                      bottom: 150,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 5.5,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                    ),
                    itemCount: dataMap.length,
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
                                child: Text(
                                  'Item Name: $item_name',
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
                                  'Exchange with',
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
                              child: ElevatedButton(
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
                                child: Center(child: Text('Details')),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              // Display only if there is a search
              if (widget.searchString != null &&
                  widget.searchString!.isNotEmpty)
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(
                      left: 3,
                      right: 3,
                      top: 3,
                      bottom: 150,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 5.5,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
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
                                child: Text(
                                  'Item Name: $item_name',
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
                                  'Exchange with',
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
                              child: ElevatedButton(
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
                                child: Center(child: Text('Details')),
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
