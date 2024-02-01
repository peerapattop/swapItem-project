import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swapitem/ProfileScreen.dart';
import 'package:swapitem/widget/offer_imageshow.dart';

class CheckOffercome extends StatefulWidget {
  const CheckOffercome({Key? key}) : super(key: key);

  @override
  State<CheckOffercome> createState() => _CheckOffercomeState();
}

class _CheckOffercomeState extends State<CheckOffercome> {
  late User _user;
  late DatabaseReference _postRef;
  late DatabaseReference _offerRef;
  List<Map<dynamic, dynamic>> postsList = [];
  List<Map<dynamic, dynamic>> offersList = [];
  Map<dynamic, dynamic>? selectedPost;
  Map<dynamic, dynamic>? selectedOffers;
  int _postIndex = -1;
  int _offerIndex = -1;

  double? latitude;
  double? longitude;
  late GoogleMapController mapController;

  List<String> image_post = [];
  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser!;
    _postRef = FirebaseDatabase.instance.ref().child('postitem');
    _offerRef = FirebaseDatabase.instance.ref().child('offer');
    selectedPost = null;
    selectedOffers = null;
    // Load the first post
    _postRef
        .orderByChild('uid')
        .equalTo(_user.uid)
        .limitToFirst(1)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map;
        print('Data from Firebase: $data');

        if (data.isNotEmpty) {
          var firstKey = data.keys.first;
          var firstPost = Map<dynamic, dynamic>.from(data[firstKey]);

          // When you get the first post, load its offers
          _loadOffersData(firstPost['post_uid']);

          setState(() {
            postsList.clear();
            postsList.insert(0, firstPost);
            selectedPost = firstPost;
            _postIndex = 0;
          });

          // Filter posts based on 'statusPosts' field
          final filteredPosts = data.values
              .where((post) => post['statusPosts'] == 'รอการยืนยัน')
              .toList();

          setState(() {
            postsList = List<Map<dynamic, dynamic>>.from(filteredPosts);
          });
        } else {
          print('Data from Firebase is empty.');
        }
      } else {
        print('No data from Firebase.');
      }
    });
  }

  void _loadOffersData(String postUid) {
    _offerRef
        .orderByChild('post_uid')
        .equalTo(postUid)
        .limitToFirst(1)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map;
        print('Offers data from Firebase: $data');

        if (data.isNotEmpty) {
          var firstKey = data.keys.first;
          var firstOffer = Map<dynamic, dynamic>.from(data[firstKey]);

          setState(() {
            offersList.clear();
            offersList.insert(0, firstOffer);
            selectedOffers = firstOffer;
            _offerIndex = 0;
          });

          // Filter offers based on 'statusOffers' field
          final filteredOffers = data.values
              .where((offer) => offer['statusOffers'] == 'รอการยืนยัน')
              .toList();

          setState(() {
            offersList = List<Map<dynamic, dynamic>>.from(filteredOffers);
          });
        } else {
          print('Offers data from Firebase is empty.');
        }
      } else {
        print('No offers data from Firebase.');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: seePost()
      ),
    );
  }

  Widget buildCircularNumberButtonPosts(
      int index, Map<dynamic, dynamic> postData
      ) {
    return InkWell(
      onTap: () {
        _loadOffersData(postData['post_uid']); // Load offer data based on the post_uid
        setState(() {
          _postIndex = index; // Update the selected index
          selectedPost = postData; // Update the selected post data
          // Clear the previously selected offers when a new post is selected
          offersList.clear(); // This will clear the offer list
          selectedOffers = null; // Clear selected offer
          _offerIndex = -1; // Reset the selected index for offers
        });
      },
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _postIndex == index
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

  Widget seePost() {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: postsList.asMap().entries.map((entry) {
              int idx = entry.key;
              image_post = List<String>.from(selectedOffers!['imageUrls']);
              Map<dynamic, dynamic> postData = entry.value;
              image_post = List<String>.from(selectedPost!['imageUrls']);
              latitude = double.tryParse(selectedPost!['latitude'].toString());
              longitude =
                  double.tryParse(selectedPost!['longitude'].toString());
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: buildCircularNumberButtonPosts(idx, postData),
              );
            }).toList(),
          ),
        ),
        ImageGalleryWidget(
          imageUrls: image_post,
        ),
        Row(
          children: [
            Icon(
              Icons.tag,
              // เปลี่ยนเป็นไอคอนที่คุณต้องการ
              color: Colors.blue, // เปลี่ยนสีไอคอนตามความต้องการ
            ),
            SizedBox(width: 8),
            Text(
              'โพสต์ของคุณ : ' + selectedPost!['postNumber'],
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.date_range,
              // เปลี่ยนเป็นไอคอนที่คุณต้องการ
              color: Colors.blue, // เปลี่ยนสีไอคอนตามความต้องการ
            ),
            SizedBox(width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
            Text(
              'วันที่ : ' + selectedPost!['date'],
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.punch_clock,
              // เปลี่ยนเป็นไอคอนที่คุณต้องการ
              color: Colors.blue, // เปลี่ยนสีไอคอนตามความต้องการ
            ),
            Text(
              " เวลา :" + selectedPost!['time'] + ' น.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: 400,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            color: Color(0xFFF0F0F0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ชื่อสิ่งของ : ' + selectedPost!['item_name'],
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'หมวดหมู่ : ' + selectedPost!['type'],
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'ยี่ห้อ : ' + selectedPost!['brand'],
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'รุ่น : ' + selectedPost!['model'],
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'รายละเอียด : ' + selectedPost!['detail'],
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
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
        Container(
          width: 400,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            color: Color(0xFFF0F0F0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'สิ่งของที่ต้องการแลกเปลี่ยน : ' + selectedPost!['item_name1'],
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'ยี่ห้อ : ' + selectedPost!['brand1'],
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'รุ่น : ' + selectedPost!['model1'],
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'รายละเอียด : ' + selectedPost!['details1'],
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
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
              target: LatLng(latitude ?? 0.0, longitude ?? 0.0),
              zoom: 12.0,
            ),
            markers: <Marker>{
              Marker(
                markerId: MarkerId('initialPosition'),
                position: LatLng(latitude ?? 0.0, longitude ?? 0.0),
                infoWindow: InfoWindow(
                  title: 'Marker Title',
                  snippet: 'Marker Snippet',
                ),
              ),
            },
          ),
        ),
        SizedBox(height: 10),
        SizedBox(height: 10),
      ],
    );
  }
}
