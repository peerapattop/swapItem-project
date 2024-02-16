import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:swapitem/ProfileScreen.dart';
import 'package:swapitem/widget/chat_detail.dart';
import 'package:swapitem/widget/offer_imageshow.dart';

class His_Make_off2 extends StatefulWidget {
  final String postUid;

  const His_Make_off2({Key? key, required this.postUid}) : super(key: key);

  @override
  State<His_Make_off2> createState() => _His_Make_off2State();
}

class _His_Make_off2State extends State<His_Make_off2> {
  String timeclick = '';
  late String? idPost;
  late User _user;
  late DatabaseReference _postRef;
  List<Map<dynamic, dynamic>> postsList = [];
  int _selectedIndex = -1;
  Map<dynamic, dynamic>? selectedOffer;
  late GoogleMapController mapController;
  int? mySlideindex;
  List<String> image_post = [];

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _postRef = FirebaseDatabase.instance.ref().child('postitem');
    selectedOffer = null;

    _loadOffers();
  }

  // Method to load offers based on post UID
  void _loadOffers() {
    _postRef
        .orderByChild('post_uid')
        .equalTo(widget.postUid)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            Map<dynamic, dynamic>.from(event.snapshot.value as Map);

        data.forEach((key, value) {
          if (true) {
            postsList.add(value);
          }
        });

        // Sort postsList by 'timestamp' in descending order
        postsList.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

        if (postsList.isNotEmpty) {
          setState(() {
            selectedOffer = postsList.reversed.toList()[0];
            _selectedIndex = 0;
          });
        }
      }
    }).onError((error) {
      print("Error fetching data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _postRef.orderByChild('post_uid').equalTo(widget.postUid).onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          Map<dynamic, dynamic> data =
              Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map);

          // bool hasPendingPosts = false;
          // data.forEach((key, value) {
          //   if (true) {
          //     hasPendingPosts = true;
          //   }
          // });
          return Column(
            children: [
              //888
              SizedBox(
                height: 50,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: postsList.reversed
                        .toList()
                        .asMap()
                        .entries
                        .map((entry) {
                      int idx = entry.key;
                      Map<dynamic, dynamic> postData = entry.value;
                      image_post =
                          List<String>.from(selectedOffer!['username']);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: buildCircularNumberButton(idx, postData),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'ข้อเสนอที่เข้ามา',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ImageGalleryWidget(
                imageUrls: image_post,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.tag, color: Colors.blue),
                  const SizedBox(width: 5),
                  Text(
                    'หมายเลขการยื่นข้อเสนอ : ${selectedOffer?['username']}',
                    style: const TextStyle(fontSize: 19),
                  )
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.date_range, color: Colors.blue),
                  const SizedBox(width: 5),
                  Text(
                    'วันที่ : ${convertDateFormat(selectedOffer?['username'])}',
                    style: const TextStyle(fontSize: 19),
                  )
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.lock_clock, color: Colors.blue),
                  const SizedBox(width: 5),
                  Text(
                    'เวลา : ${selectedOffer?['username']} น.',
                    style: const TextStyle(fontSize: 19),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: 437,
                height: 272,
                decoration: ShapeDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(0.00, -1.00),
                    end: Alignment(0, 1),
                    colors: [Color(0x9B419FB3), Color(0x008B47C1)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ชื่อสิ่งของ : ' + selectedOffer!['username'],
                        style: const TextStyle(fontSize: 19),
                      ),
                      Text(
                        'ยี่ห้อ : ' + selectedOffer!['username'],
                        style: const TextStyle(fontSize: 19),
                      ),
                      Text(
                        'รุ่น : ' + selectedOffer!['username'],
                        style: const TextStyle(fontSize: 19),
                      ),
                      Text(
                        'รายละเอียด : ' + selectedOffer!['username'],
                        style: const TextStyle(fontSize: 19),
                      ),
                    ],
                  ),
                ),
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
                const SizedBox(height: 20),
                const Text(
                  'ยังไม่มีข้อเสนอที่เข้ามาให้แลกเปลี่ยน',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildCircularNumberButton(int index, Map<dynamic, dynamic> postData) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index; // Update the selected index
          selectedOffer = postData; // Update the selected payment data
        });
      },
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(4),
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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  String convertDateFormat(String inputDate) {
    DateTime dateTime = DateTime.parse(inputDate); // แปลงสตริงเป็นวันที่
    DateFormat formatter =
        DateFormat('d MMMM y', 'th'); // สร้างรูปแบบการแสดงวันที่ตามที่ต้องการ
    String formattedDate =
        formatter.format(dateTime); // แปลงวันที่เป็นรูปแบบที่ต้องการ
    return formattedDate; // คืนค่าวันที่ที่ถูกแปลง
  }
}
