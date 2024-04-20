import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swapitem/registerVip_page.dart';
import 'package:swapitem/buildPost_page.dart';
import 'package:swapitem/test555.dart';
import 'package:swapitem/widget/GrideGps.dart';
import 'package:swapitem/widget/dropdown.dart';
import 'package:swapitem/widget/grid_view.dart';
import 'package:swapitem/notification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User _user;
  late DatabaseReference _userRef;
  String? _searchString;
  TextEditingController searchController = TextEditingController();
  double _distance = 5;
  bool isFavorite = true;
  bool gps_default = false;
  List<String> list = <String>['One', 'Two', 'Three', 'Four'];
  List<String> selectedButtons = [];

  void toggleButton(String value) {
    setState(() {
      if (selectedButtons.contains(value)) {
        selectedButtons.remove(value);
      } else {
        selectedButtons.add(value);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _userRef = FirebaseDatabase.instance.ref().child('users').child(_user.uid);
  }

  void handleSearch() {
    setState(() {
      _searchString = searchController.text.trim().isEmpty
          ? null
          : searchController.text.trim().toLowerCase();
    });
  }

  Stream<int> getUnreadNotificationCountStream() {
    var notificationCollection =
        FirebaseFirestore.instance.collection('notifications');

    return notificationCollection
        .where('readBy.${_user.uid}', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> markNotificationsAsRead() async {
    var notificationCollection =
        FirebaseFirestore.instance.collection('notifications');
    var batch = FirebaseFirestore.instance.batch();

    var querySnapshot = await notificationCollection
        .where('readBy.${_user.uid}', isEqualTo: false)
        .get();

    for (var doc in querySnapshot.docs) {
      batch.update(doc.reference, {
        'readBy.${_user.uid}': true,
      });
    }

    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            icon: const Icon(Icons.menu),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
          title: Row(
            children: [
              Expanded(
                  child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'ค้นหาสินค้า',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchString = value;
                    });
                  },
                ),
              )),
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    searchController.clear();
                    _searchString = '';
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(child: dataDialog());
                    },
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.star),
                color: gps_default == false ? Colors.amberAccent : Colors.black,
                // Change color based on gps_default state
                onPressed: () {
                  setState(() {
                    gps_default =
                        false; // Assuming gps_default is a boolean variable
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.room_sharp),
                color: gps_default == true ? Colors.red : Colors.black,
                onPressed: () {
                  setState(() {
                    gps_default = true;
                  });
                },
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: _userRef.onValue,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    children: [
                      SizedBox(height: 350),
                      CircularProgressIndicator(),
                      Text('กำลังโหลดข้อมูล...')
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                DataSnapshot dataSnapshot = snapshot.data!.snapshot;
                Map dataUser = dataSnapshot.value as Map;
                String postCount = dataUser['postCount'].toString();
                String makeofferCount = dataUser['makeofferCount'].toString();

                return Column(
                  children: [
                    isFavorite == true
                        ? buildUserProfileSection(
                            dataUser, postCount, makeofferCount)
                        : SizedBox(),
                    const Divider(),
                    showItemSearch(),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildUserProfileSection(
      Map dataUser, String postCount, String makeofferCount) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: ClipRRect(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          width: 1.0,
                          color: Colors.black,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'โควตาการโพสต์ $postCount/5 เดือน',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: ClipRRect(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          width: 1.0,
                          color: Colors.black,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'โควตาการยื่นข้อเสนอ $makeofferCount/5 เดือน',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Payment(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              width: 1.0,
                              color: Colors.black,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              spacing: 5.0,
                              children: [
                                Image.asset('assets/images/vip.png'),
                                const Text(
                                  'เติม VIP',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.create,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NewPost()));
                              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApphhh()));
                            },
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                width: 1.0,
                                color: Colors.black,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              backgroundColor: Colors.red,
                            ),
                            label: const Text(
                              'สร้างโพสต์',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: ClipOval(
                  child: Image.network(
                    dataUser['image_user'],
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                dataUser['username'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget showItemSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: SizedBox(
          height: 800,
          width: double.infinity,
          child: gps_default == false
              ? GridView2(searchString: _searchString)
              : GridGPS(),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(String selectedItem) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(selectedItem),
          content:  SingleChildScrollView(
            child: MultiSelectableButtonList(selectedItem:selectedItem),
          ),
          actions: <Widget>[
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent
              ),
              icon: const Icon(Icons.search,color: Colors.white,),
              label: const Text('ค้นหา',style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget showDistance() {
    return Dialog(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 30),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search),
                  Text(
                    "ค้นหาโพสต์ตามระยะทาง",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.near_me),
                    onPressed: () {
                      // showPostNearMe();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    label: const Text("ใกล้ฉัน"),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Text(
                    'ระยะห่างไม่เกิน: $_distance กิโลเมตร',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Slider(
                    value: _distance,
                    min: 1.0,
                    // กำหนดค่าต่ำสุดที่เลือกได้
                    max: 10.0,
                    onChanged: (double value) {
                      setState(() {
                        _distance =
                            value.roundToDouble(); // ปัดค่าเพื่อให้เป็นทศนิยม
                      });
                    },
                    divisions: 10,
                    semanticFormatterCallback: (double value) {
                      return '${value.round()}'; // ให้ label เป็นค่าที่เลือกโดยตรง
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.chevron_right_outlined),
                    onPressed: () {
                      showPostDefault();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    label: const Text("รีเซ็ท"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      gps_default = true;
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const SizedBox(
                    width: 100,
                    child: Center(child: Text("ยืนยัน")),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget searchItem() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(width: 0.8),
                ),
                hintText: "ชื่อสิ่งของ,ประเภท ที่ต้องการ",
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                searchController.clear();
                _searchString = '';
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: handleSearch,
          ),
          IconButton(
            icon: const Icon(Icons.room_sharp),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return showDistance();
                },
              );
            },
          )
        ],
      ),
    );
  }

  Widget showPostDefault() {
    return const GridView2();
  }

  Widget dataDialog() {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 5),
                    child: Text(
                      "เลือกชนิดสิ่งของที่ต้องการ",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, left: 20, right: 20, bottom: 5),
                    child: Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: [
                        for (String item in [
                          'เสื้อผ้าแฟชั่นผู้ชาย',
                          'เสื้อผ้าแฟชั่นผู้หญิง',
                          'กระเป๋า',
                          'รองเท้าผู้ชาย',
                          'รองเท้าผู้หญิง',
                          'นาฬิกาและแว่นตา',
                          'เครื่องใช้ในบ้าน',
                          'มือถือและอุปกรณ์เสริม',
                          'เครื่องใช้ไฟฟ้าภายในบ้าน',
                          'กล้องและอุปกรณ์ถ่ายภาพ',
                          'คอมพิวเตอร์และอุปกรณ์เสริม',
                          'ของเล่น สินค้าแม่และเด็ก',
                          'เครื่องเขียน หนังสือ และงานอดิเรก',
                          'อุปกรณ์กีฬา',
                          'อื่นๆ',
                        ])
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: () {
                              _showMyDialog(item);
                            },
                            child: Text(
                              item,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      label: const Text(
                        'ปิด',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
