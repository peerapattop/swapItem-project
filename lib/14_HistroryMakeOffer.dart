import 'package:swapitem/ProfileScreen.dart';
import 'package:swapitem/widget/offer_imageshow.dart';

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
  final PageController _pageController1 = PageController();
  final PageController _pageController2 = PageController();

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
        offerList.clear();

        setState(() {
          offerList.insert(0, lastPayment);
          selectedOffer = lastPayment;
          _selectedIndex = 0;
        });
      }
    });
  }

  void fetchUserData(String uid, BuildContext context) {
    print('Fetching user data for UID: $uid');

    FirebaseDatabase.instance.ref('users/$uid').once().then((databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        print('User data found for UID: $uid');

        Map<String, dynamic> userData =
            Map<String, dynamic>.from(databaseEvent.snapshot.value as Map);
        String id = userData['id'] ?? '';
        String username = userData['username'] ?? 'Unknown';
        String imageUser = userData['image_user'] ?? '';
        String creditPostSuccess = userData['creditPostSuccess'].toString();
        String  creditOfferSuccess = userData['creditOfferSuccess'].toString();
        String  creditOfferFailure = userData['creditOfferFailure'].toString();
        // Navigate to ProfileScreen with user data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              username: username,
              id: id,
              imageUser: imageUser,
              creditPostSuccess: creditPostSuccess,
              creditOfferFailure: creditOfferFailure,
              creditOfferSuccess: creditOfferSuccess,
            ),
          ),
        );
      } else {
        print('User data not found for UID: $uid');
      }
    }).catchError((error) {
      print('Error fetching user data: $error');
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
    }); //888
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
              child: const Text(
                'ยกเลิก',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // ปิดหน้าต่างโดยไม่ลบ
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while data is being fetched
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
              // Handle errors
              return const Center(
                child: Text('Error loading data'),
              );
            } else if (snapshot.hasData &&
                snapshot.data!.snapshot.value != null) {
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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: offerList.asMap().entries.map((entry) {
                          imageOffer =
                              List<String>.from(selectedOffer!['imageUrls']);
                          int idx = entry.key;
                          Map<dynamic, dynamic> offerData = entry.value;
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: buildCircularNumberButton(idx, offerData),
                          );
                        }).toList(),
                      ),
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
                                if (snapshot.hasData) {
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
                                    imageUser = postItemData['imageUser'];
                                    String username = postItemData['username'];

                                    return ListView(
                                      children: [
                                        Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'ข้อเสนอของคุณ',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                            ImageGalleryWidget(
                                              imageUrls: imageOffer,
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
                                                        "สถานะ : ${selectedOffer!['statusOffers']}",
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
                                                        "หมายเลขยื่นข้อเสนอ : ${selectedOffer!['offerNumber']}",
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
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 170, 170, 169),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12.0), // ทำให้ Container โค้งมน
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
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
                                        const Divider(),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text(
                                            'รายละเอียดโพสต์',
                                            style: TextStyle(fontSize: 20),
                                          )),
                                        ),
                                        ImageGalleryWidget(
                                            imageUrls: imagePost),
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
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    "หมายเลขโพสต์ : ${postItemData['postNumber']}",
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
                                                  const SizedBox(width: 2),
                                                  GestureDetector(
                                                    onTap: () {
                                                      fetchUserData(
                                                          postItemData['uid'],
                                                          context);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "ชื่อผู้ใช้ : ",
                                                          style: myTextStyle(),
                                                        ),
                                                        Text(
                                                          postItemData[
                                                              'username'],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .purple,
                                                                  fontSize: 20),
                                                        ),
                                                        const Icon(
                                                          Icons.search,
                                                          color: Colors.purple,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.date_range,
                                                      color: Colors.blue),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    "วันที่ : ${postItemData['date']}",
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
                                              color: const Color.fromARGB(
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
                                                  SizedBox(height: 10),
                                                  Center(
                                                      child: Image.asset(
                                                    'assets/images/swap.png',
                                                    width: 20,
                                                  )),
                                                  const SizedBox(height: 10),
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
                                                  markerId: const MarkerId(
                                                      'initialPosition'),
                                                  position: LatLng(
                                                      latitude!, longitude!),
                                                  infoWindow: const InfoWindow(
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
                                                                  receiverUid:
                                                                      postItemData[
                                                                          'uid'])));
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
                      'https://cdn-icons-png.flaticon.com/256/11191/11191755.png',
                      width: 100,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'ไม่มีประวัติการยื่นข้อเสนอของคุณ',
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
          color: _selectedIndex == index ? Colors.blue : Colors.grey,
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
                  controller: _pageController1,
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
                      if (_pageController1.page! > 0) {
                        _pageController1.previousPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, size: 30),
                    onPressed: () {
                      if (_pageController1.page! < imagePost.length - 1) {
                        _pageController1.nextPage(
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

  Widget _buildImageSliderOffer() {
    if (imageOffer.isEmpty) {
      return const SizedBox.shrink();
    } else if (imageOffer.length == 1) {
      // Display the single image without PageView
      return Column(
        children: [
          SizedBox(
            height: 200, // Set your desired height for the image area
            child: Image.network(
              imageOffer[0],
              width: 200,
              height: 100,
            ),
          ),
          const SizedBox(height: 5),
        ],
      );
    } else {
      // Display multiple images using PageView
      return Column(
        children: [
          SizedBox(
            height: 200, // Set your desired height for the image area
            child: PageView.builder(
              controller: _pageController2,
              itemCount: imageOffer.length,
              itemBuilder: (context, index) {
                return Image.network(
                  imageOffer[index],
                  width: 200,
                  height: 100,
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
                  if (_pageController2.page! > 0) {
                    _pageController2.previousPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                    );
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 30),
                onPressed: () {
                  if (_pageController2.hasClients &&
                      _pageController2.page! < imageOffer.length - 1) {
                    _pageController2.nextPage(
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
  }
}

myTextStyle() {
  return const TextStyle(
    fontSize: 20,
    color: Colors.black,
  );
}
