import 'widget/chat_detail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//หน้าประวัติการยื่นข้อเสนอ


class HistoryMakeOffer extends StatefulWidget {
  const HistoryMakeOffer({Key? key}) : super(key: key);

  @override
  State<HistoryMakeOffer> createState() => _HistoryMakeOfferState();
}

class _HistoryMakeOfferState extends State<HistoryMakeOffer> {
  late User _user;
  late String imageUser;
  late DatabaseReference _offerRef;
  late DatabaseReference _postRef;
  List<Map<dynamic, dynamic>> offerList = [];

  int _selectedIndex = -1;
  Map<dynamic, dynamic>? selectedOffer;
  double? latitude;
  double? longitude;

  int mySlideindex = 0;
  List<String> imageOffer = [];
  List<String> imagePost = [];
  final PageController _pageController = PageController();
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _offerRef = FirebaseDatabase.instance.ref().child('offer');
    selectedOffer = null;

    _offerRef
        .orderByChild('uid')
        .equalTo(_user.uid)
        .limitToLast(1)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            Map<dynamic, dynamic>.from(event.snapshot.value as Map);
        var lastKey = data.keys.last;
        var lastPayment = Map<dynamic, dynamic>.from(data[lastKey]);

        // Since we are listening to the last payment, we clear the list to ensure
        // it only contains the latest payment and corresponds to the first button.
        offerList.clear();

        setState(() {
          offerList.insert(0, lastPayment); // Insert at the start of the list
          selectedOffer = lastPayment;
          _selectedIndex = 0; // This ensures the first button is selected
        });
      }
    });
  }

  Future<List<Map<dynamic, dynamic>>> fetchPostItemData(String uidPost) async {
    DatabaseEvent postRef = await FirebaseDatabase.instance
        .ref()
        .child('postitem')
        .orderByChild('post_uid')
        .equalTo(uidPost)
        .once();

    if (postRef.snapshot.value != null) {
      Map<dynamic, dynamic> postItemData =
          postRef.snapshot.value as Map<dynamic, dynamic>;

      // Convert the map into a list of items
      List<Map<dynamic, dynamic>> itemList = [];
      postItemData.forEach((key, value) {
        itemList.add(Map<dynamic, dynamic>.from(value));
      });

      return itemList;
    } else {
      return [];
    }
  }

  void selectMakeOffer(Map<dynamic, dynamic> selectedOffer) {
    setState(() {
      this.selectedOffer = selectedOffer; // อัปเดต selectedOffer
      // อัปเดต latitude และ longitude
      latitude = double.tryParse(selectedOffer['latitude'].toString());
      longitude = double.tryParse(selectedOffer['longitude'].toString());
      // อาจจะต้องอัปเดต Google Maps ที่นี่
      updateGoogleMapLocation(latitude, longitude);
    });
  }

  void updateGoogleMapLocation(double? lat, double? lng) {
    if (lat != null && lng != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, lng),
            zoom: 12.0,
          ),
        ),
      );
    }
  }

  void deleteOffer(String offerKey) {
    // Delete the post from the database using the post key
    _offerRef.child(offerKey).remove().then((_) {
      print("Offer deleted successfully!");
      setState(() {
        // Remove the post from the list to update the UI
        offerList.removeWhere((post) => post['offer_uid'] == offerKey);
        // Reset selectedPost if it's the one being deleted
        if (selectedOffer != null && selectedOffer!['offer_uid'] == offerKey) {
          selectedOffer = null;
        }
      });
    }).catchError((error) {
      print("Failed to delete offer: $error");
    });//888
  }

  void showDeleteConfirmation(BuildContext context, String offerKey) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจหรือไม่ที่จะลบข้อเสนอนี้?'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
                'ยกเลิก',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // ปิดหน้าต่างโดยไม่ลบ
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text(
                'ลบ',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // ปิดหน้าต่างและลบโพสต์
                deleteOffer(offerKey);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ประวัติการยื่นข้อเสนอ"),
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
          stream: _offerRef.orderByChild('uid').equalTo(_user.uid).onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              offerList.clear();
              Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(
                  snapshot.data!.snapshot.value as Map);
              data.forEach((key, value) {
                offerList.add(Map<dynamic, dynamic>.from(value));
              });

              return Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: offerList.asMap().entries.map((entry) {
                        imageOffer =
                            List<String>.from(selectedOffer!['imageUrls']);
                        int idx = entry.key;
                        Map<dynamic, dynamic> offerData = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: buildCircularNumberButton(idx, offerData),
                        );
                      }).toList(),
                    ),
                  ),
                  Divider(),
                  selectedOffer != null
                      ? Expanded(
                          child: StreamBuilder(
                              stream:
                                  fetchPostItemData(selectedOffer!['post_uid'])
                                      .asStream(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'กำลังดาวน์โหลด',
                                        style: TextStyle(fontSize: 19),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      CircularProgressIndicator(),
                                    ],
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  List<Map<dynamic, dynamic>> postItemList =
                                      snapshot.data
                                          as List<Map<dynamic, dynamic>>;
                                  if (postItemList.isNotEmpty) {
                                    Map<dynamic, dynamic> postItemData =
                                        postItemList.first;

                                    imagePost = List<String>.from(
                                        postItemData['imageUrls']);
                                    latitude = double.tryParse(
                                        postItemData['latitude'].toString());
                                    longitude = double.tryParse(
                                        postItemData['longitude'].toString());

                                    return ListView(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'ข้อเสนอของคุณ',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, top: 2, right: 8),
                                              child: SizedBox(
                                                height: 300,
                                                child: PageView.builder(
                                                  onPageChanged: (value) {
                                                    setState(() {
                                                      mySlideindex = value;
                                                    });
                                                  },
                                                  itemCount: imageOffer.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: Image.network(
                                                            imageOffer[index],
                                                            fit: BoxFit.cover,
                                                          )),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: SizedBox(
                                                height: 60,
                                                width: 300,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: imageOffer.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: Container(
                                                        height: 20,
                                                        width: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: index ==
                                                                  mySlideindex
                                                              ? Colors
                                                                  .deepPurple
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .notifications_active, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                                                        color: Colors
                                                            .blue, // เปลี่ยนสีไอคอนตามความต้องการ
                                                      ),
                                                      const SizedBox(
                                                          width:
                                                              8), // ระยะห่างระหว่างไอคอนและข้อความ
                                                      Text(
                                                        "สถานะ : " +
                                                            selectedOffer![
                                                                    'status']
                                                                .toString(),
                                                        style: myTextStyle(),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .tag, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                                                        color: Colors
                                                            .blue, // เปลี่ยนสีไอคอนตามความต้องการ
                                                      ),
                                                      const SizedBox(
                                                          width:
                                                              8), // ระยะห่างระหว่างไอคอนและข้อความ
                                                      Text(
                                                        "หมายเลขยื่นข้อเสนอ : " +
                                                            selectedOffer![
                                                                    'offerNumber']
                                                                .toString(),
                                                        style: myTextStyle(),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .date_range, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                                                        color: Colors
                                                            .blue, // เปลี่ยนสีไอคอนตามความต้องการ
                                                      ),
                                                      const SizedBox(
                                                          width:
                                                              8), // ระยะห่างระหว่างไอคอนและข้อความ
                                                      Text(
                                                        "วันที่ : " +
                                                            selectedOffer![
                                                                'date'],
                                                        style: myTextStyle(),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .punch_clock, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                                                        color: Colors
                                                            .blue, // เปลี่ยนสีไอคอนตามความต้องการ
                                                      ),
                                                      const SizedBox(
                                                          width:
                                                              8), // ระยะห่างระหว่างไอคอนและข้อความ
                                                      Text(
                                                        "เวลา : " +
                                                            selectedOffer![
                                                                'time'] +
                                                            ' น.',
                                                        style: myTextStyle(),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 2,
                                                            right: 15,
                                                            top: 10,
                                                            bottom: 10),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 170, 170, 169),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12.0), // ทำให้ Container โค้งมน
                                                      ),
                                                      padding: EdgeInsets.all(
                                                          16), // ระยะห่างของเนื้อหาจาก Container
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "ชื่อสิ่งของ : " +
                                                                selectedOffer![
                                                                    'nameitem1'],
                                                            style:
                                                                myTextStyle(),
                                                          ),
                                                          Text(
                                                            "หมวดหมู่ : " +
                                                                selectedOffer![
                                                                    'type1'],
                                                            style:
                                                                myTextStyle(),
                                                          ),
                                                          Text(
                                                            "ยี่ห้อ : " +
                                                                selectedOffer![
                                                                    'brand1'],
                                                            style:
                                                                myTextStyle(),
                                                          ),
                                                          Text(
                                                            "รุ่น : " +
                                                                selectedOffer![
                                                                    'model1'],
                                                            style:
                                                                myTextStyle(),
                                                          ),
                                                          Text(
                                                            'รายละเอียด : ' +
                                                                selectedOffer![
                                                                    'detail1'],
                                                            style:
                                                                myTextStyle(),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        child:
                                                            ElevatedButton.icon(
                                                          icon: const Icon(
                                                              Icons.delete,
                                                              color:
                                                                  Colors.white),
                                                          onPressed: () {
                                                            if (selectedOffer !=
                                                                    null &&
                                                                selectedOffer!
                                                                    .containsKey(
                                                                        'offer_uid')) {
                                                              showDeleteConfirmation(
                                                                  context,
                                                                  selectedOffer![
                                                                      'offer_uid']);
                                                            } else {
                                                              print(
                                                                  'No post selected for deletion.');
                                                              // Debug: Print the current state of selectedPost
                                                              print(
                                                                  'Current selectedPost: $selectedOffer');
                                                            }
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              16),
                                                                  backgroundColor:
                                                                      Color.fromARGB(
                                                                          255,
                                                                          248,
                                                                          1,
                                                                          1)),
                                                          label: Text(
                                                            "ลบข้อเสนอ",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Image.asset(
                                          'assets/images/swap.png',
                                          width: 50,
                                          height: 50,
                                        ),
                                        Divider(),
                                        Center(
                                            child: Text(
                                          'รายละเอียดโพสต์',
                                          style: TextStyle(fontSize: 20),
                                        )),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        _buildImageSlider(),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.tag,
                                                    color: Colors.blue,
                                                  ),
                                                  const SizedBox(
                                                      width:
                                                          2), // ระยะห่างระหว่างไอคอนและข้อความ
                                                  Text(
                                                    "หมายเลขโพสต์ : " +
                                                        postItemData[
                                                                'postNumber']
                                                            .toString(),
                                                    style: myTextStyle(),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.person,
                                                    color: Colors.blue,
                                                  ),
                                                  const SizedBox(
                                                      width:
                                                          2), // ระยะห่างระหว่างไอคอนและข้อความ
                                                  Text(
                                                    "ชื่อผู้ใช้ : " +
                                                        postItemData['username']
                                                            .toString(),
                                                    style: myTextStyle(),
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
                                                  const SizedBox(
                                                      width:
                                                          2), // ระยะห่างระหว่างไอคอนและข้อความ
                                                  Text(
                                                    "วันที่ : " +
                                                        postItemData['date']
                                                            .toString(),
                                                    style: myTextStyle(),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .punch_clock_outlined, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                                                    color: Colors
                                                        .blue, // เปลี่ยนสีไอคอนตามความต้องการ
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    "เวลา : " +
                                                        postItemData['time']
                                                            .toString(),
                                                    style: myTextStyle(),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15,
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
                                                        postItemData[
                                                            'item_name'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    'หมวดหมู่ : ' +
                                                        postItemData['type'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    'ยี่ห้อ : ' +
                                                        postItemData['brand'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    'รุ่น : ' +
                                                        postItemData['model'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    'รายละเอียด : ' +
                                                        postItemData['detail'],
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
                                                        postItemData[
                                                            'item_name1'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    'ยี่ห้อ : ' +
                                                        postItemData['brand1'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    'รุ่น : ' +
                                                        postItemData['model1'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    'รายละเอียด : ' +
                                                        postItemData[
                                                            'details1'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
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
                                                target: LatLng(
                                                    latitude!, longitude!),
                                                zoom: 12.0,
                                              ),
                                              markers: <Marker>{
                                                Marker(
                                                  markerId: MarkerId(
                                                      'initialPosition'),
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
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              width: 350,
                                              child: ElevatedButton.icon(
                                                icon: Icon(Icons.chat,
                                                    color: Colors.white),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChatDetail(
                                                                username:
                                                                    postItemData[
                                                                        'username'],
                                                               
                                                              )));
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    padding: EdgeInsets.all(16),
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 41, 77, 250)),
                                                label: Text(
                                                  "แชท",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    // Handle the case when no post item is found
                                    return Column(
                                      children: [
                                        Text('ไม่มีประวัติการยื่นข้อเสนอ'),
                                      ],
                                    );
                                  }
                                } else {
                                  // Handle the case when snapshot has no data
                                  return Container();
                                }
                              }),
                        )
                      : Expanded(
                          child: Center(
                              child: Text(
                                  'Please select a payment to view the details')),
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
                      'https://cdn-icons-png.flaticon.com/256/7465/7465523.png',
                      width: 100,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'ไม่มีประวัติการยื่นข้อเสนอของคุณ',
                      style: TextStyle(fontSize: 25),
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

  Widget buildCircularNumberButton(int index, Map<dynamic, dynamic> offerData) {
    return InkWell(
      onTap: () {
        selectMakeOffer(offerData);
        setState(() {
          _selectedIndex = index; // Update the selected index
          selectedOffer = offerData; // Update the selected payment data
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

  Widget _buildImageSlider() {
    return imagePost.isEmpty
        ? SizedBox.shrink()
        : Column(
            children: [
              SizedBox(
                height: 200, // Set your desired height for the image area
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: imagePost.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      imagePost[index],
                      width: 200,
                      height: 100,
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
                      if (_pageController.page! < imagePost.length - 1) {
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
}

myTextStyle() {
  return const TextStyle(
    fontSize: 20,
    color: Colors.black,
  );
}
