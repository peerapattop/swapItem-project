import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ShowDetailAll extends StatefulWidget {
  final String postUid;

  ShowDetailAll({required this.postUid});

  @override
  _ShowDetailAllState createState() => _ShowDetailAllState();
}

class _ShowDetailAllState extends State<ShowDetailAll> {
  Map postData = {};
  List<String> image_post = [];
  final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    _loadPostData();
  }

  void _loadPostData() {
    FirebaseDatabase.instance
        .ref('postitem/${widget.postUid}')
        .once()
        .then((DatabaseEvent databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        setState(() {
          postData =
              Map<String, dynamic>.from(databaseEvent.snapshot.value as Map);
          image_post = List<String>.from(postData['imageUrls'] ?? []);
        });
      }
    }).catchError((error) {
      // Handle errors here
    });
  }

  Widget _buildImageSlider() {
    return image_post.isEmpty
        ? SizedBox.shrink()
        : Column(
            children: [
              SizedBox(
                height: 200, // Set your desired height for the image area
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: image_post.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      image_post[index],
                      fit: BoxFit.cover,
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
                      if (_pageController.page! < image_post.length - 1) {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("ประวัติการโพสต์"),
          toolbarHeight: 40,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/image 40.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                _buildImageSlider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'หมายเลขโพสต์ : ${postData['post_uid']}',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "ชื่อผู้โพสต์ :  ${postData['username']}",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "วันที่โพสต์ : ${postData['date']}",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "เวลาโพสต์ : ${postData['time']}",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "รายละเอียด : ${postData['detail']}",
                      style: TextStyle(fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 2, right: 15, top: 10, bottom: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width -
                            17, // Subtract 17 to account for padding and margin
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 214, 214, 212),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align text to the left
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10), // Add left padding to the text
                              child: Text(
                                "สถานที่แลกเปลี่ยน : BTS อโศก",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/images/swap.png"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/images/shirt.png"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "ชื่อสิ่งของ : เสื้อ",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "รุ่น : ST-Shirt",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "รายละเอียด : เสื้อมีรอยขาดที่ชายเสื้อ",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        width: 140,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 31, 240,
                                35), // ตั้งค่าสีพื้นหลังเป็นสีเขียว
                          ),
                          onPressed: () {},
                          child: Text(
                            "ยื่นข้อเสนอ",
                            style: TextStyle(
                              color: Colors.white, // ตั้งค่าสีข้อความเป็นสีดำ
                              fontSize: 18, // ตั้งค่าขนาดข้อความ
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
