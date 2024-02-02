import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swapitem/offerCome2.dart';
//หน้าประวัติการโพสต์

class offerCome extends StatefulWidget {
  const offerCome({Key? key}) : super(key: key);

  @override
  State<offerCome> createState() => _offerComeState();
}

class _offerComeState extends State<offerCome> {
  late User _user;
  double? latitude;
  double? longitude;
  late DatabaseReference _postRef;
  List<Map<dynamic, dynamic>> postsList = [];
  int _selectedIndex = -1;
  Map<dynamic, dynamic>? selectedPost;
  late GoogleMapController mapController;
  int? mySlideindex;
  List<String> image_post = [];
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _postRef = FirebaseDatabase.instance.ref().child('postitem');
    selectedPost = null;

    _postRef
        .orderByChild('uid')
        .equalTo(_user.uid)
        .onValue
        .listen((event) {
      postsList.clear();

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(event.snapshot.value as Map);

        // Iterate over all posts and filter by statusPosts
        data.forEach((key, value) {
          if (value['statusPosts'] == "รอการยืนยัน") {
            postsList.insert(0, value);
          }
        });

        if (postsList.isNotEmpty) {
          setState(() {
            selectedPost = postsList.first;
            _selectedIndex = 0;
          });
        }
      }
    })
        .onError((error) {
      print("Error fetching data: $error");
    });
  }


  void selectPayment(Map<dynamic, dynamic> postData) {
    setState(() {
      selectedPost = postData; // Update selectedPost with the chosen data
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
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
  //         builder: (context, userSnapshot) {
  //           if (userSnapshot.connectionState == ConnectionState.waiting) {
  //             return const Center(
  //               child: CircularProgressIndicator(),
  //             );
  //           } else if (userSnapshot.hasError) {
  //             return Center(
  //               child: Text('Error loading user data'),
  //             );
  //           } else if (userSnapshot.hasData &&
  //               userSnapshot.data!.snapshot.value != null) {
  //             // Your existing code for handling user data
  //             return StreamBuilder(
  //               stream: _postRef
  //                   .orderByChild('statusPosts')
  //                   .equalTo('รอการยืนยัน')
  //                   .onValue,
  //               builder: (context, statusSnapshot) {
  //                 if (statusSnapshot.connectionState ==
  //                     ConnectionState.waiting) {
  //                   return const Center(
  //                     child: CircularProgressIndicator(),
  //                   );
  //                 } else if (statusSnapshot.hasError) {
  //                   return Center(
  //                     child: Text('Error loading posts with status data'),
  //                   );
  //                 } else if (statusSnapshot.hasData &&
  //                     statusSnapshot.data!.snapshot.value != null) {
  //                   // Your existing code for handling posts with a specific status
  //                   // ...
  //
  //                   // Combine the data from both snapshots if needed
  //                   // ...
  //
  //                   return Column(
  //                     children: [
  //                       //offerCome2(postUid: selectedPost!['post_uid']),//ทำไมถึงเกิดการแสดงที่แย่มากๆ
  //                       SizedBox(
  //                         height: 50,
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: postsList.asMap().entries.map((entry) {
  //                             int idx = entry.key;
  //                             Map<dynamic, dynamic> postData = entry.value;
  //                             image_post =
  //                             List<String>.from(selectedPost!['imageUrls']);
  //                             latitude = double.tryParse(
  //                                 selectedPost!['latitude'].toString());
  //                             longitude = double.tryParse(
  //                                 selectedPost!['longitude'].toString());
  //                             return Padding(
  //                               padding: const EdgeInsets.symmetric(horizontal: 4.0),
  //                               child: buildCircularNumberButton(idx, postData),
  //                             );
  //                           }).toList(),
  //                         ),
  //                       ),
  //                       Divider(),
  //                       selectedPost != null
  //                           ? Expanded(
  //                         child: ListView(
  //                           children: [
  //                             Column(
  //                               children: [
  //                                 Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Column(
  //                                     children: [
  //                                       Padding(
  //                                         padding: const EdgeInsets.only(
  //                                             left: 8, top: 8, right: 8),
  //                                         child: SizedBox(
  //                                           height: 300,
  //                                           child: PageView.builder(
  //                                             onPageChanged: (value) {
  //                                               setState(() {
  //                                                 mySlideindex = value;
  //                                               });
  //                                             },
  //                                             itemCount: image_post.length,
  //                                             itemBuilder: (context, index) {
  //                                               return Padding(
  //                                                 padding: const EdgeInsets.all(
  //                                                     20.0),
  //                                                 child: ClipRRect(
  //                                                     borderRadius:
  //                                                     BorderRadius.circular(
  //                                                         20),
  //                                                     child: Image.network(
  //                                                       image_post[index],
  //                                                       fit: BoxFit.cover,
  //                                                     )),
  //                                               );
  //                                             },
  //                                           ),
  //                                         ),
  //                                       ),
  //                                       SizedBox(
  //                                         height: 60,
  //                                         width: 300,
  //                                         child: ListView.builder(
  //                                           scrollDirection: Axis.horizontal,
  //                                           itemCount: image_post.length,
  //                                           itemBuilder: (context, index) {
  //                                             return Padding(
  //                                               padding:
  //                                               const EdgeInsets.all(20.0),
  //                                               child: Container(
  //                                                 height: 20,
  //                                                 width: 20,
  //                                                 decoration: BoxDecoration(
  //                                                   shape: BoxShape.circle,
  //                                                   color: index == mySlideindex
  //                                                       ? Colors.deepPurple
  //                                                       : Colors.grey,
  //                                                 ),
  //                                               ),
  //                                             );
  //                                           },
  //                                         ),
  //                                       ),
  //                                       Row(
  //                                         children: [
  //                                           Icon(
  //                                             Icons
  //                                                 .tag, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
  //                                             color: Colors
  //                                                 .blue, // เปลี่ยนสีไอคอนตามความต้องการ
  //                                           ),
  //                                           SizedBox(
  //                                               width:
  //                                               8), // ระยะห่างระหว่างไอคอนและข้อความ
  //                                           Text(
  //                                             'หมายเลขโพสต์ : ' +
  //                                                 selectedPost!['postNumber'],
  //                                             style: TextStyle(fontSize: 18),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         children: [
  //                                           Icon(
  //                                             Icons
  //                                                 .date_range, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
  //                                             color: Colors
  //                                                 .blue, // เปลี่ยนสีไอคอนตามความต้องการ
  //                                           ),
  //                                           SizedBox(
  //                                               width:
  //                                               8), // ระยะห่างระหว่างไอคอนและข้อความ
  //                                           Text(
  //                                             'วันที่ : ' +
  //                                                 selectedPost!['date'],
  //                                             style: TextStyle(fontSize: 18),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         children: [
  //                                           Icon(
  //                                             Icons
  //                                                 .punch_clock, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
  //                                             color: Colors
  //                                                 .blue, // เปลี่ยนสีไอคอนตามความต้องการ
  //                                           ),
  //                                           Text(
  //                                             " เวลา :" +
  //                                                 selectedPost!['time'] +
  //                                                 ' น.',
  //                                             style: TextStyle(fontSize: 18),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       SizedBox(
  //                                         height: 10,
  //                                       ),
  //                                       Padding(
  //                                         padding: const EdgeInsets.only(
  //                                             left: 2,
  //                                             right: 15,
  //                                             top: 10,
  //                                             bottom: 10),
  //                                         child: Container(
  //                                           decoration: BoxDecoration(
  //                                             color: Color.fromARGB(
  //                                                 255, 214, 214, 212),
  //                                             borderRadius:
  //                                             BorderRadius.circular(12.0),
  //                                           ),
  //                                           child: Padding(
  //                                             padding:
  //                                             const EdgeInsets.all(11.0),
  //                                             child: Column(
  //                                               crossAxisAlignment:
  //                                               CrossAxisAlignment.start,
  //                                               children: [
  //                                                 Text(
  //                                                   'ชื่อสิ่งของ : ' +
  //                                                       selectedPost![
  //                                                       'item_name'],
  //                                                   style:
  //                                                   TextStyle(fontSize: 18),
  //                                                 ),
  //                                                 Text(
  //                                                   'หมวดหมู่ : ' +
  //                                                       selectedPost!['type'],
  //                                                   style:
  //                                                   TextStyle(fontSize: 18),
  //                                                 ),
  //                                                 Text(
  //                                                   'ยี่ห้อ : ' +
  //                                                       selectedPost!['brand'],
  //                                                   style:
  //                                                   TextStyle(fontSize: 18),
  //                                                 ),
  //                                                 Text(
  //                                                   'รุ่น : ' +
  //                                                       selectedPost!['model'],
  //                                                   style:
  //                                                   TextStyle(fontSize: 18),
  //                                                 ),
  //                                                 Text(
  //                                                   'รายละเอียด : ' +
  //                                                       selectedPost!['detail'],
  //                                                   style:
  //                                                   TextStyle(fontSize: 18),
  //                                                 ),
  //                                                 SizedBox(
  //                                                   height: 10,
  //                                                 ),
  //                                                 Center(
  //                                                     child: Image.asset(
  //                                                       'assets/images/swap.png',
  //                                                       width: 20,
  //                                                     )),
  //                                                 SizedBox(
  //                                                   height: 10,
  //                                                 ),
  //                                                 Text(
  //                                                   'ชื่อสิ่งของ : ' +
  //                                                       selectedPost![
  //                                                       'item_name1'],
  //                                                   style:
  //                                                   TextStyle(fontSize: 18),
  //                                                 ),
  //                                                 Text(
  //                                                   'ยี่ห้อ : ' +
  //                                                       selectedPost!['brand1'],
  //                                                   style:
  //                                                   TextStyle(fontSize: 18),
  //                                                 ),
  //                                                 Text(
  //                                                   'รุ่น : ' +
  //                                                       selectedPost!['model1'],
  //                                                   style:
  //                                                   TextStyle(fontSize: 18),
  //                                                 ),
  //                                                 Text(
  //                                                   'รายละเอียด : ' +
  //                                                       selectedPost![
  //                                                       'details1'],
  //                                                   style:
  //                                                   TextStyle(fontSize: 18),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                       Container(
  //                                         decoration: BoxDecoration(
  //                                             border: Border.all()),
  //                                         height: 300,
  //                                         width: 380,
  //                                         child: GoogleMap(
  //                                           onMapCreated: (GoogleMapController
  //                                           controller) {
  //                                             mapController = controller;
  //                                           },
  //                                           initialCameraPosition:
  //                                           CameraPosition(
  //                                             target:
  //                                             LatLng(latitude!, longitude!),
  //                                             zoom: 12.0,
  //                                           ),
  //                                           markers: <Marker>{
  //                                             Marker(
  //                                               markerId:
  //                                               MarkerId('initialPosition'),
  //                                               position: LatLng(
  //                                                   latitude!, longitude!),
  //                                               infoWindow: InfoWindow(
  //                                                 title: 'Marker Title',
  //                                                 snippet: 'Marker Snippet',
  //                                               ),
  //                                             ),
  //                                           },
  //                                         ),
  //                                       ),
  //                                       SizedBox(
  //                                         height: 10,
  //                                       ),
  //                                       ElevatedButton.icon(
  //                                         style: ElevatedButton.styleFrom(
  //                                             backgroundColor: Colors.red),
  //                                         onPressed: () {
  //                                           if (selectedPost != null &&
  //                                               selectedPost!
  //                                                   .containsKey('post_uid')) {
  //                                             showDeleteConfirmation(context,
  //                                                 selectedPost!['post_uid']);
  //                                           } else {
  //                                             print(
  //                                                 'No post selected for deletion.');
  //                                             // Debug: Print the current state of selectedPost
  //                                             print(
  //                                                 'Current selectedPost: $selectedPost');
  //                                           }
  //                                         },
  //                                         icon: Icon(Icons.delete,
  //                                             color: Colors.white),
  //                                         label: Text('ลบโพสต์',
  //                                             style: TextStyle(
  //                                                 color: Colors.white)),
  //                                       ),
  //                                       Divider(),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       )
  //                           : Column(
  //                         children: [
  //                           CircularProgressIndicator(),
  //                           Text('กำลังโหลด..'),
  //                         ],
  //                       ),
  //                     ],
  //                   ); // Your final UI widget
  //                 } else {
  //                   return Center(
  //                     child: Text('No posts with the specified status'),
  //                   );
  //                 }
  //               },
  //             );
  //           } else {
  //             return Center(
  //               child: Text('No data available'),
  //             );
  //           }
  //         },
  //       ));
  // }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ข้อเสนอที่เข้ามา"),
          toolbarHeight: 40,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/image 40.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        body: StreamBuilder(
          stream: _postRef
              .orderByChild('statusPosts').equalTo("รอการยืนยัน") //.orderByChild('statusPosts').equalTo("รอการยืนยัน")
              .onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('กำลังดาวน์โหลดข้อมูล....'),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error loading data'),
              );
            } else if (snapshot.hasData &&
                snapshot.data!.snapshot.value != null) {
              // Your existing code for handling data
              postsList.clear();
              Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(
                  snapshot.data!.snapshot.value as Map);
              data.forEach((key, value) {
                postsList.add(Map<dynamic, dynamic>.from(value));
              });

              return Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: postsList.asMap().entries.map((entry) {
                        int idx = entry.key;
                        Map<dynamic, dynamic> postData = entry.value;
                        image_post =
                            List<String>.from(selectedPost!['imageUrls']);
                        latitude = double.tryParse(
                            selectedPost!['latitude'].toString());
                        longitude = double.tryParse(
                            selectedPost!['longitude'].toString());
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: buildCircularNumberButton(idx, postData),
                        );
                      }).toList(),
                    ),
                  ),
                  Divider(),
                  selectedPost != null
                      ? Expanded(
                          child: ListView(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, top: 8, right: 8),
                                          child: SizedBox(
                                            height: 300,
                                            child: PageView.builder(
                                              onPageChanged: (value) {
                                                setState(() {
                                                  mySlideindex = value;
                                                });
                                              },
                                              itemCount: image_post.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: Image.network(
                                                        image_post[index],
                                                        fit: BoxFit.cover,
                                                      )),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 60,
                                          width: 300,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: image_post.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: index == mySlideindex
                                                        ? Colors.deepPurple
                                                        : Colors.grey,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .tag, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                                              color: Colors
                                                  .blue, // เปลี่ยนสีไอคอนตามความต้องการ
                                            ),
                                            SizedBox(
                                                width:
                                                    8), // ระยะห่างระหว่างไอคอนและข้อความ
                                            Text(
                                              'หมายเลขโพสต์ : ' +
                                                  selectedPost!['postNumber'],
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .date_range, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                                              color: Colors
                                                  .blue, // เปลี่ยนสีไอคอนตามความต้องการ
                                            ),
                                            SizedBox(
                                                width:
                                                    8), // ระยะห่างระหว่างไอคอนและข้อความ
                                            Text(
                                              'วันที่ : ' +
                                                  selectedPost!['date'],
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .punch_clock, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                                              color: Colors
                                                  .blue, // เปลี่ยนสีไอคอนตามความต้องการ
                                            ),
                                            Text(
                                              " เวลา :" +
                                                  selectedPost!['time'] +
                                                  ' น.',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 2,
                                              right: 15,
                                              top: 10,
                                              bottom: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 214, 214, 212),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(11.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'ชื่อสิ่งของ : ' +
                                                        selectedPost![
                                                            'item_name'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    'หมวดหมู่ : ' +
                                                        selectedPost!['type'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    'ยี่ห้อ : ' +
                                                        selectedPost!['brand'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    'รุ่น : ' +
                                                        selectedPost!['model'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    'รายละเอียด : ' +
                                                        selectedPost!['detail'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Center(
                                                      child: Image.asset(
                                                    'assets/images/swap.png',
                                                    width: 20,
                                                  )),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'ชื่อสิ่งของ : ' +
                                                        selectedPost![
                                                            'item_name1'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    'ยี่ห้อ : ' +
                                                        selectedPost!['brand1'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    'รุ่น : ' +
                                                        selectedPost!['model1'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    'รายละเอียด : ' +
                                                        selectedPost![
                                                            'details1'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all()),
                                          height: 300,
                                          width: 380,
                                          child: GoogleMap(
                                            onMapCreated: (GoogleMapController
                                                controller) {
                                              mapController = controller;
                                            },
                                            initialCameraPosition:
                                                CameraPosition(
                                              target:
                                                  LatLng(latitude!, longitude!),
                                              zoom: 12.0,
                                            ),
                                            markers: <Marker>{
                                              Marker(
                                                markerId:
                                                    MarkerId('initialPosition'),
                                                position: LatLng(
                                                    latitude!, longitude!),
                                                infoWindow: InfoWindow(
                                                  title: 'Marker Title',
                                                  snippet: 'Marker Snippet',
                                                ),
                                              ),
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(),
                                        offerCome2(
                                            postUid: selectedPost!['post_uid']),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            CircularProgressIndicator(),
                            Text('กำลังโหลด..'),
                          ],
                        ),
                ],
              );
            } else {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://cdn-icons-png.flaticon.com/256/11191/11191755.png',
                      width: 100,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'ไม่มีประวัติการโพสต์',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildCircularNumberButton(int index, Map<dynamic, dynamic> postData) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index; // Update the selected index
          selectedPost = postData; // Update the selected payment data
        });
      },
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _selectedIndex == index
              ? Colors.blue
              : Colors.grey, // Highlight if selected
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
