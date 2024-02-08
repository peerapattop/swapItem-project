import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  Map<dynamic, dynamic>? selectedPost;
  late GoogleMapController mapController;
  int? mySlideindex;
  List<String> image_post = [];

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _offerRef = FirebaseDatabase.instance.ref().child('offer');
    selectedPost = null;

    _offerRef.orderByChild('uidUserpost').equalTo(_user.uid).onValue.listen(
        (event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            Map<dynamic, dynamic>.from(event.snapshot.value as Map);

        setState(() {
          postsList.clear(); // Clearing here if new data is coming
          data.forEach((key, value) {
            postsList.add(Map<dynamic, dynamic>.from(value));
          });

          if (postsList.isNotEmpty) {
            selectedPost = postsList.last;
            _selectedIndex = 0;
            print("look at me" + selectedPost.toString());
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
                children: [

                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading data'),
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
                            List<String>.from(selectedPost!['imageUrls']);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: buildCircularNumberButton(idx, postData),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'ขอเสนอที่เข้ามา',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ImageGalleryWidget(
                  imageUrls: image_post,
                ),
                Container(
                  width: 437,
                  height: 272,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
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
                          'ชื่อสิ่งของ : ' + selectedPost!['nameitem1'],
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
                          'รายละเอียด : ' + selectedPost!['detail1'],
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    if (selectedPost != null &&
                        selectedPost!.containsKey('post_uid')) {
                      showDeleteConfirmation(
                          context, selectedPost!['post_uid']);
                    } else {
                      print('No post selected for deletion.');
                      // Debug: Print the current state of selectedPost
                      print('Current selectedPost: $selectedPost');
                    }
                  },
                  icon: Icon(Icons.delete, color: Colors.white),
                  label: Text('ลบโพสต์', style: TextStyle(color: Colors.white)),
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

  void showDeleteConfirmation(BuildContext context, String postKey) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการเลือกข้อเสนอนี้'),
          content: Text('ถ้ากดยืนยัน โพสต์นี้จะไม่แสดงอีกต่อไป'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
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
              child: Text(
                'ลบ',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _performUpdate();
                // ปิดหน้าต่างและลบโพสต์
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _performUpdate() async {
    try {
      late DatabaseReference _postRef;
      _postRef = FirebaseDatabase.instance
          .ref()
          .child('posts')
          .child(selectedPost!['post_uid']);
      // Your existing update logic
      await _postRef.update({
        'statusPosts': "สำเร็จ",
      });
    } catch (error) {
      throw error; // Rethrow the error to be caught by the FutureBuilder
    }
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
