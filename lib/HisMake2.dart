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
  late User _user;
  late DatabaseReference _postRef;
  List<Map<dynamic, dynamic>> postsList = [];
  Map<dynamic, dynamic>? selectedOffer;
  List<String> image_post = [];

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _postRef = FirebaseDatabase.instance.ref().child('postitem');

    _loadOffers();
  }

  // Method to load offers based on post UID
  void _loadOffers() {
    _postRef.orderByChild('post_uid').equalTo(widget.postUid).onValue.listen(
        (event) {
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
          });
        }
      }
    }, onError: (error) {
      print("Error fetching data: $error");
    });
  }

  void fetchUserData(String uid, BuildContext context) {
    FirebaseDatabase.instance.ref('users/$uid').once().then((databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(databaseEvent.snapshot.value as Map);
        String id = userData['id'] ?? '';
        String imageUser = userData['image_user'];
        String username = userData['username'];
        String creditPostSuccess = userData['creditPostSuccess'].toString();
        String creditOfferSuccess = userData['creditOfferSuccess'].toString();
        String totalOffer = userData['totalOffer'].toString();
        String totalPost = userData['totalPost'].toString();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              username: username,
              id: id,
              imageUser: imageUser,
              creditPostSuccess: creditPostSuccess,
              creditOfferSuccess: creditOfferSuccess,
              totalPost: totalPost,
              totalOffer: totalOffer,
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
          image_post = List<String>.from(selectedOffer!['imageUrls']);
          print(selectedOffer!['statusOffers']);
          return Column(
            children: [
              ImageGalleryWidget(
                imageUrls: image_post,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.tag,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "หมายเลขโพสต์ : ${selectedOffer!['postNumber']}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "ชื่อผู้ใช้ : ",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      fetchUserData(selectedOffer!['uid'], context);
                    },
                    child: Row(
                      children: [
                        Text(
                          selectedOffer!['username'],
                          style: const TextStyle(
                              fontSize: 18, color: Colors.purple),
                        ),
                        const Icon(Icons.search, color: Colors.purple),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.date_range,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "วันที่ : ${convertDateFormat(selectedOffer!['date'])}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.punch_clock,
                    color: Colors.blue,
                  ),
                  Text(
                    " เวลา :" + selectedOffer!['time'] + ' น.',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 2, right: 2, top: 10, bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(0.00, -1.00),
                      end: Alignment(0, 1),
                      colors: [Color(0x66482A1D), Color(0x00E86B36)],
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ชื่อสิ่งของ : ' + selectedOffer!['item_name'],
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'หมวดหมู่ : ' + selectedOffer!['type'],
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'ยี่ห้อ : ' + selectedOffer!['brand'],
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'รุ่น : ' + selectedOffer!['model'],
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'รายละเอียด : ' + selectedOffer!['detail'],
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Center(
                            child: Image.asset(
                          'assets/images/swap.png',
                          width: 20,
                        )),
                        const SizedBox(height: 10),
                        Text(
                          'ชื่อสิ่งของ : ${selectedOffer!['item_name1']}',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'ยี่ห้อ : ' + selectedOffer!['brand1'],
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'รุ่น : ${selectedOffer!['model1']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'รายละเอียด : ${selectedOffer!['details1']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.chat,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatDetail(receiverUid: selectedOffer!['uid']),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(500, 50),
                ),
                label: const Text(
                  'แชท',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              selectedOffer!['statusPosts'] == 'กำลังดำเนินการ'
                  ? Row(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Add your onPressed logic here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                          ),
                          label: const Text(
                            'ปฎิเสธการแลกเปลี่ยน',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Add your onPressed logic here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                          ),
                          label: const Text(
                            'ยืนยันการแลกเปลี่ยน',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 20),
            ],
          );
        } else {
          return const Center(
            child: Text('No data available'),
          );
        }
      },
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
