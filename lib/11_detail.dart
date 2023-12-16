import 'package:flutter/material.dart';
import 'package:swapitem/12_makeAnOffer.dart';
import 'package:swapitem/trash/2_createpost.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowDetailAll extends StatefulWidget {
  final String postUid;
  final String longti;
  final String lati;

  ShowDetailAll(
      {required this.postUid, required this.longti, required this.lati});

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
    }).catchError((error) {
      // Handle errors here
      print('An error occurred while loading post data: $error');
    });
  }

  Widget _buildImageSlider() {
    return image_post.isEmpty
        ? SizedBox.shrink()
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
              SizedBox(
                  height:
                      5), // Adjust the size of this SizedBox as needed for spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 30),
                    onPressed: () {
                      if (_pageController.page! > 0) {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, size: 30),
                    onPressed: () {
                      if (_pageController.page! < image_post.length - 1) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 200),
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
          title: Text("ยื่นข้อเสนอ"),
          toolbarHeight: 40,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/image 40.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageSlider(),
                    Row(
                      children: [
                        Icon(
                          Icons.numbers,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'หมายเลขโพสต์ : ${postData['postNumber']}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "ชื่อผู้โพสต์ :  ${postData['username']}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "วันที่ : ${postData['date']}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.lock_clock,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "เวลา : ${postData['time']}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.list,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "รายละเอียด : ${postData['detail']}",
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
                          color: Color.fromARGB(255, 214, 214, 212),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    Text("รายละเอียด : ${postData['detail']}",
                                        style: TextStyle(fontSize: 20)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/images/swap.png"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width -
                                17, // Subtract 17 to account for padding and margin
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 214, 214, 212),
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
                                            style: TextStyle(fontSize: 20)),
                                        Text("ยี่ห้อ : ${postData['brand1']}",
                                            style: TextStyle(fontSize: 20)),
                                        Text("รุ่น : ${postData['model1']}",
                                            style: TextStyle(fontSize: 20)),
                                        Text(
                                            "รายละเอียด : ${postData['details1']}",
                                            style: TextStyle(fontSize: 20)),
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
                    SizedBox(
                      height: 15,
                    ),
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
                            markerId: MarkerId('initialPosition'),
                            position: LatLng(latitude!, longitude!),
                            infoWindow: InfoWindow(
                              title: 'Marker Title',
                              snippet: 'Marker Snippet',
                            ),
                          ),
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 15, 239,
                                19), // ตั้งค่าสีพื้นหลังเป็นสีเขียว
                          ),
                          onPressed: () {
                            String send_uid = postData['post_uid'];
                            String username = postData['username'];
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MakeAnOffer(postUid: send_uid,username: username,)),
                            );
                          },
                          child: Text(
                            "ยื่นข้อเสนอ",
                            style: TextStyle(
                                color: Colors.white, // ตั้งค่าสีข้อความเป็นสีดำ
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold // ตั้งค่าขนาดข้อความ
                                ),
                          ),
                        ),
                      ),
                    ),
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
