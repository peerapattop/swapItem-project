import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final String id;
  final String imageUser;
  final String creditPostSuccess;
  final String creditOfferSuccess;
  final String totalOffer;
  final String totalPost;

  const ProfileScreen({
    Key? key,
    required this.username,
    required this.id,
    required this.imageUser,
    required this.creditPostSuccess,
    required this.creditOfferSuccess,
    required this.totalOffer,
    required this.totalPost,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("โปรไฟล์ผู้ใช้"),
          toolbarHeight: 40,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/image 40.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black, // สีของเส้นกรอบ
                    width: 3.0, // ความกว้างของเส้นกรอบ
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    widget.imageUser,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.tag, color: Colors.blue),
                      const SizedBox(width: 5),
                      Text('หมายเลขผู้ใช้ : ${widget.id}',
                          style: TextStyle(fontSize: 19)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.blue),
                      const SizedBox(width: 5),
                      Text('ชื่อผู้ใช้: ${widget.username}',
                          style: TextStyle(fontSize: 19)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'เครดิตการโพสต์',
                    style: TextStyle(
                        fontSize: 19,
                        color: Color.fromARGB(255, 124, 1, 124),
                        decoration: TextDecoration.underline),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value:
                                    double.tryParse(widget.creditPostSuccess),
                                color: Colors.green,
                                title:
                                    '${widget.creditPostSuccess}%',
                                radius: 50,
                                titleStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                value: double.tryParse((double.parse(
                                            widget.totalPost) -
                                        double.parse(widget.creditPostSuccess))
                                    .toString()),
                                color: Colors.red,
                                title:
                                    '${(100 - double.parse(widget.creditPostSuccess)).toStringAsFixed(2)}%',
                                radius: 50,
                                titleStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      // Text(
                      //   'อัตราการแลกเปลี่ยน : ${widget.creditPostSuccess}',
                      //   style: const TextStyle(fontSize: 18),
                      // ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 20,
                                color: Colors.green,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'สำเร็จ',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 20,
                                color: Colors.red,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'ไม่สำเร็จ',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'เครดิตการยื่นข้อเสนอ',
                    style: TextStyle(
                        fontSize: 19,
                        color: Color.fromARGB(255, 124, 1, 124),
                        decoration: TextDecoration.underline),
                  ),
                  // Text('แลกเปลี่ยนสำเร็จ : ${widget.creditOfferSuccess}',
                  //     style: const TextStyle(fontSize: 19)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: 30,
                                color: Colors.green,
                                title: '50%',
                                radius: 50,
                              ),
                              PieChartSectionData(
                                value: 30,
                                color: Colors.red,
                                title: '50%',
                                radius: 50,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      // Text(
                      //   'อัตราการแลกเปลี่ยน : ${widget.creditPostSuccess}',
                      //   style: const TextStyle(fontSize: 18),
                      // ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 20,
                                color: Colors.green,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'สำเร็จ',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 20,
                                color: Colors.red,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'ไม่สำเร็จ',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
