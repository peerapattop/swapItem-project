import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swapitem/offerCome2.dart';
import 'package:swapitem/widget/offer_imageshow.dart';
//หน้าประวัติการโพสต์

class offerCome extends StatefulWidget {
  final String postUid;
  const offerCome({Key? key, required this.postUid}) : super(key: key);

  @override
  State<offerCome> createState() => _offerComeState();
}

class _offerComeState extends State<offerCome> {
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
    _postRef = FirebaseDatabase.instance.ref().child('postitem');
    selectedPost = null;

    _postRef.orderByChild('uid').equalTo(widget.postUid).onValue.listen((event) {
      postsList.clear();

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            Map<dynamic, dynamic>.from(event.snapshot.value as Map);

        // Iterate over all posts and filter by statusPosts
        setState(() {
          data.forEach((key, value) {
            if (value['statusPosts'] == "รอการยืนยัน") {
              postsList.insert(
                  0, value); // Insert at the beginning of the list
            }
          });
        });

        if (postsList.isNotEmpty) {
          setState(() {
            selectedPost = postsList.last;
            _selectedIndex = 0;
          });
        }
      }
    }).onError((error) {
      print("Error fetching data: $error");
    });
  }

  void selectPayment(Map<dynamic, dynamic> postData) {
    setState(() {
      selectedPost = postData; // Update selectedPost with the chosen data
    });
  }

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
              .orderByChild('statusPosts')
              .equalTo(
                  'รอการยืนยัน') //.orderByChild('statusPosts').equalTo("รอการยืนยัน")
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
                                        ImageGalleryWidget(
                                          imageUrls: image_post,
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
          }, //gg
        ),
      ),
    );
  }

  Widget buildCircularNumberButton(int index, Map<dynamic, dynamic> postData) {
    print("kuy" + selectedPost.toString());
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
