import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:swapitem/ProfileScreen.dart';
import 'package:swapitem/widget/chat_detail.dart';
import 'package:swapitem/widget/offer_imageshow.dart';
//หน้าประวัติการโพสต์

class offerCome2 extends StatefulWidget {
  final String postUid;

  const offerCome2({Key? key, required this.postUid}) : super(key: key);

  @override
  State<offerCome2> createState() => _offerCome2State();
}

class _offerCome2State extends State<offerCome2> {
  late String? idPost;
  late User _user;
  late DatabaseReference _offerRef;
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
    _offerRef = FirebaseDatabase.instance.ref().child('offer');
    selectedOffer = null;

    _offerRef.orderByChild('uidUserpost').equalTo(_user.uid).onValue.listen(
        (event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            Map<dynamic, dynamic>.from(event.snapshot.value as Map);

        setState(() {
          postsList.clear();
          data.forEach((key, value) {
            postsList.add(Map<dynamic, dynamic>.from(value));
          });

          if (postsList.isNotEmpty) {
            selectedOffer = postsList.last;
            _selectedIndex = 0;
            print("look at me" + selectedOffer.toString());
          }
        });
      }
    }, onError: (error) {
      print("Error fetching data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: StreamBuilder(
        stream:
            _offerRef.orderByChild('post_uid').equalTo(widget.postUid).onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                children: [],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading data'),//888
            );
          } else if (snapshot.hasData &&
              snapshot.data!.snapshot.value != null) {
            // Your existing code for handling data without clearing postsList
            Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(
                snapshot.data!.snapshot.value as Map);
            postsList.clear(); // Clearing here if new data is coming
            data.forEach((key, value) {
              postsList.add(Map<dynamic, dynamic>.from(value));
            });
            return Column(
              children: [
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
                            List<String>.from(selectedOffer!['imageUrls']);
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
                      'หมายเลขการยื่นข้อเสนอ : ${selectedOffer?['offerNumber']}',
                      style: const TextStyle(fontSize: 19),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.blue),
                    const SizedBox(width: 5),
                    const Text(
                      'ชื่อผู้ใช้ : ',
                      style: TextStyle(fontSize: 19),
                    ),
                    GestureDetector(
                      onTap: () {
                        fetchUserData(selectedOffer?['uid'], context);
                      },
                      child: Row(
                        children: [
                          Text(
                            selectedOffer?['username'],
                            style: const TextStyle(
                                fontSize: 19, color: Colors.purple),
                          ),
                          const Icon(
                            Icons.search,
                            color: Colors.purple,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.date_range, color: Colors.blue),
                    const SizedBox(width: 5),
                    Text(
                      'วันที่ : ${convertDateFormat(selectedOffer?['date'])}',
                      style: const TextStyle(fontSize: 19),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.lock_clock, color: Colors.blue),
                    const SizedBox(width: 5),
                    Text(
                      'เวลา : ${selectedOffer?['time']} น.',
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
                          'ชื่อสิ่งของ : ' + selectedOffer!['nameitem1'],
                          style: const TextStyle(fontSize: 19),
                        ),
                        Text(
                          'ยี่ห้อ : ' + selectedOffer!['brand1'],
                          style: const TextStyle(fontSize: 19),
                        ),
                        Text(
                          'รุ่น : ' + selectedOffer!['model1'],
                          style: const TextStyle(fontSize: 19),
                        ),
                        Text(
                          'รายละเอียด : ' + selectedOffer!['detail1'],
                          style: const TextStyle(fontSize: 19),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 7),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(120, 45),
                      ),
                      icon: const Icon(
                        Icons.chat,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetail(
                              receiverUid: selectedOffer?['uid'],
                            ),
                          ),
                        );
                      },
                      label: const Text(
                        'แชท',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 150),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () {
                        if (selectedOffer != null &&
                            selectedOffer!.containsKey('post_uid')) {
                          showUpdateConfirmation(
                              context, selectedOffer!['post_uid']);
                        } else {
                          print('No post selected for deletion.');
                          // Debug: Print the current state of selectedPost
                          print('Current selectedPost: $selectedOffer');
                        }
                      },
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text('ยืนยัน',
                          style: TextStyle(color: Colors.white)),
                    ),
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
      ),
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

  void fetchUserData(String uid, BuildContext context) {
    FirebaseDatabase.instance.ref('users/$uid').once().then((databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(databaseEvent.snapshot.value as Map);
        String id = userData['id'] ?? '';
        String imageUser = userData['image_user'];
        String username = userData['username'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              username: username,
              id: id,
              imageUser: imageUser,
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

  void showUpdateConfirmation(BuildContext context, String postKey) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการเลือกข้อเสนอนี้'),
          content: const Text('ถ้ากดยืนยัน โพสต์นี้จะไม่แสดงอีกต่อไป'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'ยกเลิก',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // ปิดหน้าต่างโดยไม่ลบ
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
                'ยืนยัน',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _performUpdateOffer();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _performUpdateOffer() async {
    try {
      DatabaseReference _postRef = FirebaseDatabase.instance
          .ref()
          .child('postitem')
          .child(widget.postUid);

      await _postRef.update({
        'user_id_confirm': selectedOffer?['offer_uid'],
      });

      // Update statusPosts field to "สำเร็จ" in the same postitem node
      await _postRef.update({
        'statusPosts': "สำเร็จ",
      });
    } catch (e) {
      // Handle error if necessary
    }
  }
}
