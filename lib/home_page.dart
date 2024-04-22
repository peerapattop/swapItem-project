import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:swapitem/0_btnnt.dart';
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
  final List<String>? filter;
  final String? searchString;

  const HomePage({Key? key, this.filter, this.searchString}) : super(key: key);

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
  String showLabel = "ค้นหาสิ่งของ";

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
    showLabels();
  }

  void showLabels() {
    setState(() {
      if (widget.filter != null) {
        searchController.text = widget.filter.toString();
      } else {
        showLabel = "ค้นหาสิ่งของ";
      }
    });
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
                child: GestureDetector(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: showLabel,
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchString = value;
                      });
                    },
                  ),
                ),
              )),
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => btnnt()),
                    (route) => false,
                  );
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
                      return dataDialog();
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.star),
                color: gps_default == false ? Colors.amberAccent : Colors.black,
                // Change color based on gps_default state
                onPressed: () {
                  setState(() {
                    gps_default = false;
                    _searchString = null;
                    widget.filter?.clear();
                    searchController.clear();
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.room_sharp),
                color: gps_default == true ? Colors.red : Colors.black,
                onPressed: () {
                  setState(() {
                    gps_default = true;
                    _searchString = null;
                    widget.filter?.clear();
                    searchController.clear();
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
    //ป่มของsearch
    String? filterString = widget.filter?.join(", ");
    if (_searchString != null && gps_default == false) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: SizedBox(
              height: 800,
              width: double.infinity,
              child: GridView2(searchString: _searchString),
            ),
          ),
        );

    } else if (_searchString == null && gps_default == false) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: 800,
            width: double.infinity,
            child: GridView2(searchString: filterString),
          ),
        ),
      );
    }  else if (_searchString == null && gps_default == true) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: 800,
            width: double.infinity,
            child: GridGPS(),
          ),
        ),
      );
    } else if (_searchString != null && gps_default == true) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: SizedBox(
              height: 800,
              width: double.infinity,
              child: GridGPS(
                searchString: _searchString,
              )),
        ),
      );
    } else if (widget.filter != null && gps_default == true) {
      if (filterString != null) {
        filterString = filterString.replaceAll(RegExp(r'[\[\]]'), '');
      }
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: SizedBox(
              height: 800,
              width: double.infinity,
              child: GridGPS(searchString: filterString)),
        ),
      );
    }
    return Text('d');
  }

  Future<void> _showMyDialog(BuildContext context, String selectedItem) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(selectedItem),
          content: SingleChildScrollView(
            child: MultiSelectableButtonList(selectedItem: selectedItem),
          ),
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
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding:
                    EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 5),
                child: Text(
                  "เลือกชนิดสิ่งของที่ต้องการ",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: [
                    for (String item in [
                      "คอมพิวเตอร์และอุปกรณ์เสริม",
                      "เครื่องใช้ไฟฟ้าภายในบ้าน",
                      "เครื่องใช้ในบ้าน",
                      "มือถือและอุปกรณ์เสริม",
                      "กล้องและโดรน",
                      "เครื่องเสียง",
                      "นาฬิกา",
                      "เกมและอุปกรณ์เสริม",
                      'เสื้อผ้าผู้ชาย',
                      'เสื้อผ้าผู้หญิง',
                      'เครื่องประดับ',
                      'รองเท้าผู้หญิง',
                      "รองเท้าผู้ชาย",
                      'เสื้อผ้ามุสลิม',
                      "กระเป๋าเดินทาง",
                      "กระเป๋าผู้หญิง",
                      "กระเป๋าผู้ชาย",
                      "กีฬาและกิจกรรมกลางแจ้ง",
                      "เครื่องเขียน",
                      "งานอดิเรกและของสะสม",
                      "หนังสือและนิตยสาร",
                      'อื่นๆ'
                    ])
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () {
                          _showMyDialog(context, item);
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
                padding: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.close, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(180, 40),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
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
    );
  }

// Widget searchWidget() {
//   return Row(
//     children: [
//       Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Text(
//           'กำลังค้นหา : ${widget.filter} ทั้งหมด',
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//       const Spacer(),
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ElevatedButton.icon(
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrangeAccent),
//           icon: const Icon(
//             Icons.clear,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             setState(() {
//             });
//           },
//           label: const Text(
//             'รีเซ็ท',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       ),
//     ],
//   );
// }
}
