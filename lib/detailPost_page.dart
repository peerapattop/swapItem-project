import 'dart:async';

import 'package:flutter/material.dart';
import 'package:swapitem/makeAnOffer_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'ProfileScreen.dart';

class ShowDetailAll extends StatefulWidget {
  final String postUid;
  final String longti;
  final String lati;
  final String imageUser;
  final String statusPost;

  ShowDetailAll({
    required this.postUid,
    required this.longti,
    required this.lati,
    required this.imageUser,
    required this.statusPost,
  });

  @override
  _ShowDetailAllState createState() => _ShowDetailAllState();
}

class _ShowDetailAllState extends State<ShowDetailAll> {
  double? latitude;
  double? longitude;
  late GoogleMapController mapController;
  Map postData = {};
  List<String> image_post = [];
  final PageController _pageController = PageController();
  bool _isLoading = true;

  @override
  void initState() {
    _buildImageSlider();
    super.initState();
    _loadPostData();
    latitude = double.tryParse(widget.lati);
    longitude = double.tryParse(widget.longti);
  }

  void _loadPostData() {
    FirebaseDatabase.instance
        .ref('postitem/${widget.postUid}')
        .once()
        .then((DatabaseEvent databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        setState(() {
          postData =
              Map<String, dynamic>.from(databaseEvent.snapshot.value as Map);
          image_post = List<String>.from(postData['imageUrls'] ?? []);

          // Handle the case where latitude or longitude is null after parsing
          if (latitude == null || longitude == null) {
            print('Error: Unable to parse latitude or longitude');
            // You could set default values or show an error message
          }
        });
      }
      // Data loading finished, set isLoading to false
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {
      // Handle error
      setState(() {
        _isLoading = false;
      });
    });
  }

  void fetchUserData(String uid) {
    FirebaseDatabase.instance.ref('users/$uid').once().then((databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(databaseEvent.snapshot.value as Map);
        String id = userData['id'];
        String creditPostSuccess = userData['creditPostSuccess'].toString();
        String creditOfferSuccess = userData['creditOfferSuccess'].toString();
        String totalOffer = userData['totalOffer'].toString();
        String totalPost = userData['totalPost'].toString();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              username: postData['username'],
              id: id,
              imageUser: postData['imageUser'],
              creditPostSuccess: creditPostSuccess,
              creditOfferSuccess: creditOfferSuccess,
              totalOffer: totalOffer,
              totalPost: totalPost,
            ),
          ),
        );
      } else {
        print('ไม่พบข้อมูลผู้ใช้');
      }
    }).catchError((error) {
      print('เกิดข้อผิดพลาดในการดึงข้อมูลผู้ใช้: $error');
    });
  }

  Widget _buildImageSlider() {
    return image_post.isEmpty
        ? const SizedBox.shrink()
        : Column(
            children: [
              SizedBox(
                height: 200, // Set your desired height for the image area
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: image_post.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      image_post[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 30),
                    onPressed: () {
                      if (_pageController.page! > 0) {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 30),
                    onPressed: () {
                      if (_pageController.page! < image_post.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("รายละเอียดสินค้า"),
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
        body: _isLoading
            ? const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('กำลังดาวน์โหลด...')
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildImageSlider(),
                          Row(
                            children: [
                              const Icon(
                                Icons.numbers,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'หมายเลขโพสต์ : ${postData['postNumber']}',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () {
                                  fetchUserData(postData['uid']);
                                },
                                child: Row(
                                  children: [
                                    const Text(
                                      "ชื่อผู้โพสต์ : ",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      postData['username'],
                                      style: const TextStyle(
                                          color: Colors.purple, fontSize: 20),
                                    ),
                                    const Icon(
                                      Icons.search,
                                      color: Colors.purple,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.date_range,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "วันที่ : ${postData['date']}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.lock_clock,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "เวลา : ${postData['time']}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 2, right: 15, top: 10, bottom: 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width -
                                  17, // Subtract 17 to account for padding and margin
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 214, 214, 212),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align text to the left
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "ชื่อสิ่งของ : ${postData['item_name']}",
                                              style: TextStyle(fontSize: 20)),
                                          Text("หมวดหมู่ : ${postData['type']}",
                                              style: TextStyle(fontSize: 20)),
                                          Text("ยี่ห้อ : ${postData['brand']}",
                                              style: TextStyle(fontSize: 20)),
                                          Text("รุ่น : ${postData['model']}",
                                              style: TextStyle(fontSize: 20)),
                                          Text(
                                              "รายละเอียด : ${postData['detail']}",
                                              style: TextStyle(fontSize: 20)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset("assets/images/swap.png"),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width -
                                      17, // Subtract 17 to account for padding and margin
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 214, 214, 212),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Align text to the left
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "ชื่อสิ่งของ : ${postData['item_name1']}",
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              Text(
                                                  "ยี่ห้อ : ${postData['brand1']}",
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              Text(
                                                  "รุ่น : ${postData['model1']}",
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              Text(
                                                  "รายละเอียด : ${postData['details1']}",
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            decoration: BoxDecoration(border: Border.all()),
                            height: 300,
                            width: 380,
                            child: GoogleMap(
                              onMapCreated: (GoogleMapController controller) {
                                mapController = controller;
                              },
                              initialCameraPosition: CameraPosition(
                                target: LatLng(latitude!, longitude!),
                                zoom: 12.0,
                              ),
                              markers: <Marker>{
                                Marker(
                                  markerId: const MarkerId('initialPosition'),
                                  position: LatLng(latitude!, longitude!),
                                  infoWindow: const InfoWindow(
                                    title: 'Marker Title',
                                    snippet: 'Marker Snippet',
                                  ),
                                ),
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: (postData['statusPosts'] == 'รอการยืนยัน' ||postData['statusPosts'] == 'ยืนยัน')
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    onPressed: () {},
                                    child: const Text(
                                      "ไม่สามารถแลกเปลี่ยนได้",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      String sendUid = postData['post_uid'];
                                      String username = postData['username'];
                                      String imageUser = postData['imageUser'];
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => MakeAnOffer(
                                            postUid: sendUid,
                                            username: username,
                                            imageUser: imageUser,
                                            uidUserpost: postData['uid'],
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    child: const Text(
                                      "ยื่นข้อเสนอ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
