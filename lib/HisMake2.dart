import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:swapitem/ProfileScreen.dart';
import 'package:swapitem/widget/chat_detail.dart';
import 'package:swapitem/widget/offer_imageshow.dart';

class His_MakeOffer_2 extends StatefulWidget {
  final String postUid;
  final String offer_uid;
  final String statusOffer;

  const His_MakeOffer_2({
    Key? key,
    required this.postUid,
    required this.statusOffer,
    required this.offer_uid,
  }) : super(key: key);

  @override
  State<His_MakeOffer_2> createState() => _His_MakeOffer_2State();
}

class _His_MakeOffer_2State extends State<His_MakeOffer_2> {
  late String statusOffer = widget.statusOffer;
  late User _user;
  late DatabaseReference _postRef;
  List<Map<dynamic, dynamic>> postsList = [];
  Map<dynamic, dynamic>? selectedPost;
  List<String> image_post = [];
  String Ans = '';

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
                selectedPost = postsList.reversed.toList()[0];
              });
            }
          }
        }, onError: (error) {
      print("Error fetching data: $error");
    });
  }

  void fetchData() async {
    try {
      DatabaseReference postRef = FirebaseDatabase.instance
          .ref()
          .child('postitem')
          .child(selectedPost!['post_uid']);

      await postRef.update({'answerStatus': Ans});
    } catch (e) {
      // Handle errors
    }
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
          image_post = List<String>.from(selectedPost!['imageUrls']);
          print(selectedPost!['statusOffers']);
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
                    "หมายเลขโพสต์ : ${selectedPost!['postNumber']}",
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
                      fetchUserData(selectedPost!['uid'], context);
                    },
                    child: Row(
                      children: [
                        Text(
                          selectedPost!['username'],
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
                    "วันที่ : ${(selectedPost!['date'])}",
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
                    " เวลา :" + selectedPost!['time'] + ' น.',
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
                          'ชื่อสิ่งของ : ${selectedPost!['item_name1']}',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'ยี่ห้อ : ' + selectedPost!['brand1'],
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'รุ่น : ${selectedPost!['model1']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'รายละเอียด : ${selectedPost!['details1']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              statusOffer == 'ยังไม่ถูกเลือก' &&
                  selectedPost!['statusPosts'].toString() == 'รอการยืนยัน'
                  ? showConfirmBtn2()
                  : showConfirmBtn(),
              SizedBox(height: 10),
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

  Widget confirmBtn() {
    if (selectedPost!['statusPosts'] == 'รอการยืนยัน' ||
        selectedPost!['statusPosts'] == 'ยืนยัน') {
      return Row(
        children: [
          ElevatedButton.icon(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () async {
              try {
                DatabaseReference postRef1 = FirebaseDatabase.instance
                    .ref()
                    .child('offer')
                    .child(widget.offer_uid.toString());

                await postRef1.update({
                  //post
                  'statusOffers': "ปฏิเสธ",
                });
              } catch (e) {
                // Handle error if necessary
              }
              // Add your onPressed logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
            label: const Text(
              'ปฏิเสธการแลกเปลี่ยน',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: () async {
              Show_Confirmation_Dialog_Status(
                context,
              );
              // Add your onPressed logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            ),
            label: const Text(
              'ยืนยันการแลกเปลี่ยน',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      );
    }
    return SizedBox.shrink();
  }

  Widget showConfirmBtn() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 600,
            height: 300,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 214, 214, 212),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: Column(
                children: [
                  Text(
                    'สถานะการแลกเปลี่ยน',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 30.0, bottom: 10.0, right: 15.0),
                          child: Text(
                            'ผู้โพสต์',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 45,
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                          const EdgeInsets.only(left: 21.0, bottom: 10.0),
                          child: Text(
                            'ผู้ยื่นข้อเสนอ',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          width: 150,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5.0, right: 10.0, left: 10.0),
                            child: Center(
                              child: selectedPost!['statusPosts'] ==
                                  'สามารถยื่นข้อเสนอได้' &&
                                  widget.statusOffer == "ยังไม่ถูกเลือก"
                                  ? Text('กำลังเลือกข้อเสนอ')
                                  : Text(selectedPost!['statusPosts']),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Transform.rotate(
                          angle: -pi / 2,
                          child: Image.asset(
                            'assets/images/swap.png',
                            width: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 150,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5.0, right: 10.0, left: 10.0),
                            child: Center(
                              child: Text(
                                statusOffer,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, right: 10.0, left: 10.0),
                        child: Center(
                          child: Text(
                            buildStatus(selectedPost!['statusPosts'].toString(),
                                widget.statusOffer.toString()),
                          ),
                          //     String statusPost = selectedPost!['statusPosts'];
                          // String statusOffer = widget.statusOffer;
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'ผลการแลกเปลี่ยน',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 50,
          width: double
              .infinity, // Make the button expand to the full width available
          child: ElevatedButton.icon(
            icon: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetail(
                    receiverUid: selectedPost!['uid'],
                  ),
                ),
              );
            },
            label: const Text(
              'แชท',
              style: TextStyle(color: Colors.white, fontSize: 19),
            ),
          ),
        ),
        const SizedBox(height: 10),
        logicHid()
      ],
    );
  }

  Widget logicHid() {
    if (statusOffer == 'รอการยืนยัน') {
      return confirmBtn();
    }
    if (statusOffer == 'ยืนยัน') {
      return Container();
    } else {
      return Container();
    }
  }


  Widget showConfirmBtn2() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 600,
            height: 300,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 214, 214, 212),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: Column(
                children: [
                  Text(
                    'สถานะการแลกเปลี่ยน',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 30.0, bottom: 10.0, right: 15.0),
                          child: Text(
                            'ผู้โพสต์',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 45,
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                          const EdgeInsets.only(left: 21.0, bottom: 10.0),
                          child: Text(
                            'ผู้ยื่นข้อเสนอ',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          width: 150,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5.0, right: 10.0, left: 10.0),
                            child: Center(
                              child: Text('ปฏิเสธ'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Transform.rotate(
                          angle: -pi / 2,
                          child: Image.asset(
                            'assets/images/swap.png',
                            width: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 150,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5.0, right: 10.0, left: 10.0),
                            child: Center(
                              child: Text(
                                statusOffer,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      width: 200,
                      height: 50,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      child: const Padding(
                        padding:
                        EdgeInsets.only(top: 5.0, right: 10.0, left: 10.0),
                        child: Center(
                            child: Text(
                              "ข้อเสนอของคุณไม่ถูกเลือก",
                            )
                          //     String statusPost = selectedPost!['statusPosts'];
                          // String statusOffer = widget.statusOffer;
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'ผลการแลกเปลี่ยน',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 50,
          width: double
              .infinity, // Make the button expand to the full width available
          child: ElevatedButton.icon(
            icon: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetail(
                    receiverUid: selectedPost!['uid'],
                  ),
                ),
              );
            },
            label: const Text(
              'แชท',
              style: TextStyle(color: Colors.white, fontSize: 19),
            ),
          ),
        ),
        const SizedBox(height: 10),
        selectedPost!['statusPosts'] == 'รอการยืนยัน' &&
            statusOffer == 'รอการยืนยัน'
            ? confirmBtn()
            : Container(),
      ],
    );
  }

  void Show_Confirmation_Dialog_Status(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการตัดสินใจ'),
          content: const Text(
              '**คำเตือน** รอการยืนยันการตัดสินใจจาก ผู้แลกเปลี่ยนของคุณก่อน ถึงจะสำเร็จ'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'ยกเลิก',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
                'ยันยัน',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _performUpdateOffer();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _performUpdateOffer() async {
    try {
      DatabaseReference postRef1 = FirebaseDatabase.instance
          .ref()
          .child('offer')
          .child(widget.offer_uid.toString());

      await postRef1.update({
        //post
        'statusOffers': "ยืนยัน",
      });
    } catch (e) {
      // Handle error if necessary
    }
  }

  String buildStatus(String statusPost, String statusOffer) {
    if (statusPost == "สามารถยื่นข้อเสนอได้" &&
        statusOffer == "ยังไม่ถูกเลือก") {
      Ans = "ยังไม่ถูกเลือก"; //
    }
    if (statusPost == "รอการยืนยัน" && statusOffer == "รอการยืนยัน") {
      Ans = "รอการยืนยัน"; //
    } else if (statusPost == "ยืนยัน" && statusOffer == "รอการยืนยัน") {
      Ans = "รอการยืนยัน"; //
    } else if (statusPost == "รอการยืนยัน" && statusOffer == "ยืนยัน") {
      Ans = "รอการยืนยัน"; //
    } else if (statusPost == "ยืนยัน" && statusOffer == "ยืนยัน") {
      Ans = "แลกเปลี่ยนสำเร็จ"; //
    } else if (statusPost == "ยืนยัน" && statusOffer == "ปฏิเสธ") {
      Ans = "ล้มเหลว"; //
    } else if (statusPost == "ปฏิเสธ" && statusOffer == "ยืนยัน") {
      Ans = "ล้มเหลว"; //
    } else if (statusPost == "ปฏิเสธ" && statusOffer == "ปฏิเสธ") {
      Ans = "ล้มเหลว"; //
    } else if (statusPost == "ปฏิเสธ" && statusOffer == "รอการยืนยัน") {
      Ans = "ล้มเหลว"; //
    } else if (statusPost == "รอการยืนยัน" && statusOffer == "ปฏิเสธ") {
      Ans = "ล้มเหลว"; //
    }

    if (Ans == 'แลกเปลี่ยนสำเร็จ' || Ans == 'ล้มเหลว') {
      fetchData();
    }
    return Ans;
  }

  String convertDateFormat(String inputDate) {
    DateTime dateTime = DateTime.parse(inputDate);
    DateFormat formatter = DateFormat('d MMMM y', 'th');
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }
}