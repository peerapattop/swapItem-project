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
            print("kuy" + selectedPost.toString());
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
