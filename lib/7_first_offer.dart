import '8_delete_post.dart';
import 'package:flutter/material.dart';

const List<String> people = <String>[
  'ข้อเสนอคนที่ 1',
  'ข้อเสนอคนที่ 2',
  'ข้อเสนอคนที่ 3',
  'ข้อเสนอคนที่ 4'
];
String dropdownValue = people.first;

class OfferRequest extends StatefulWidget {
  const OfferRequest({super.key});

  @override
  State<OfferRequest> createState() => _OfferRequestState();
}

class _OfferRequestState extends State<OfferRequest> {
  List<String> foodList = [
    "https://cdn.pixabay.com/photo/2010/12/13/10/05/berries-2277_1280.jpg",
    "https://cdn.pixabay.com/photo/2015/12/09/17/11/vegetables-1085063_640.jpg",
    "https://cdn.pixabay.com/photo/2017/01/20/15/06/oranges-1995056_640.jpg",
    "https://cdn.pixabay.com/photo/2014/11/05/15/57/salmon-518032_640.jpg",
    "https://cdn.pixabay.com/photo/2016/07/22/09/59/fruits-1534494_640.jpg",
  ];
  int mySlideindex = 0;
  int selectedButton = 1;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("ข้อเสนอที่เข้ามา"),
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
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCircularNumberButton(1),
                  SizedBox(
                    width: 10,
                  ),
                  buildCircularNumberButton(2),
                  SizedBox(
                    width: 10,
                  ),
                  buildCircularNumberButton(3),
                  SizedBox(
                    width: 10,
                  ),
                  buildCircularNumberButton(4),
                  SizedBox(
                    width: 10,
                  ),
                  buildCircularNumberButton(5),
                  // เพิ่ม CircularNumberButton อื่น ๆ ตามต้องการ
                ],
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                child: SizedBox(
                  height: 300,
                  child: PageView.builder(
                    onPageChanged: (value) {
                      setState(() {
                        mySlideindex = value;
                      });
                    },
                    itemCount: foodList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              foodList[index],
                              fit: BoxFit.cover,
                            )),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 60,
                width: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: foodList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == mySlideindex
                              ? Colors.deepPurple
                              : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.tag, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                          color: Colors.blue, // เปลี่ยนสีไอคอนตามความต้องการ
                        ),
                        const SizedBox(
                            width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
                        Text(
                          "หมายเลขโพสต์ #0001",
                          style: MyTextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.person, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                          color: Colors.blue, // เปลี่ยนสีไอคอนตามความต้องการ
                        ),
                        const SizedBox(
                            width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
                        Text(
                          "ชื่อผู้โพสต์ : Pramepree",
                          style: MyTextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.date_range, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                          color: Colors.blue, // เปลี่ยนสีไอคอนตามความต้องการ
                        ),
                        const SizedBox(
                            width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
                        Text(
                          "วันที่ 9/8/2999",
                          style: MyTextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.punch_clock, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                          color: Colors.blue, // เปลี่ยนสีไอคอนตามความต้องการ
                        ),
                        const SizedBox(
                            width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
                        Text(
                          "เวลา 13:00 น.",
                          style: MyTextStyle(),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 170, 170, 169),
                        borderRadius: BorderRadius.circular(
                            12.0), // ทำให้ Container โค้งมน
                      ),
                      padding:
                          EdgeInsets.all(16), // ระยะห่างของเนื้อหาจาก Container
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ชื่อสิ่งของ : รองเท้า",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "ยี่ห้อ : adidas",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "รุ่น : superstar",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "รายละเอียด : รองเท้าไซร์ 40",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'สถานที่แลกเปลี่ยน : BTS สนามกีฬา',
                            style: MyTextStyle(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              Image.asset(
                'assets/images/swap.png',
                width: 50,
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCircularNumberButton(1),
                  SizedBox(
                    width: 10,
                  ),
                  buildCircularNumberButton(2),
                  SizedBox(
                    width: 10,
                  ),
                  buildCircularNumberButton(3),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                child: SizedBox(
                  height: 300,
                  child: PageView.builder(
                    onPageChanged: (value) {
                      setState(() {
                        mySlideindex = value;
                      });
                    },
                    itemCount: foodList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              foodList[index],
                              fit: BoxFit.cover,
                            )),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 60,
                width: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: foodList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == mySlideindex
                              ? Colors.deepPurple
                              : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                          color: Colors.blue, // เปลี่ยนสีไอคอนตามความต้องการ
                        ),
                        SizedBox(width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
                        Text(
                          "ผู้ส่งคำขอเสนอแลกเปลี่ยน  : Prampree ",
                          style: MyTextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.date_range, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                          color: Colors.blue, // เปลี่ยนสีไอคอนตามความต้องการ
                        ),
                        SizedBox(width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
                        Text(
                          "วันที่ 9/8/2566",
                          style: MyTextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.punch_clock, // เปลี่ยนเป็นไอคอนที่คุณต้องการ
                          color: Colors.blue, // เปลี่ยนสีไอคอนตามความต้องการ
                        ),
                        Text(
                          " เวลา 12:00 น.",
                          style: MyTextStyle(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 170, 170, 169),
                        borderRadius: BorderRadius.circular(
                            12.0), // ทำให้ Container โค้งมน
                      ),
                      padding:
                          EdgeInsets.all(16), // ระยะห่างของเนื้อหาจาก Container
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ชื่อสิ่งของ :  เสื้อ",
                            style: MyTextStyle(),
                          ),
                          Text(
                            "หมวดหมู่ : เสื้อผ้า",
                            style: MyTextStyle(),
                          ),
                          Text(
                            "ยี่ห้อ : ตะขาบ",
                            style: MyTextStyle(),
                          ),
                          Text(
                            "รุ่น :  T-Shire",
                            style: MyTextStyle(),
                          ),
                          Text(
                            'รายละเอียด :สภาพการใช้งาน 50%',
                            style: MyTextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      icon: Icon(Icons.chat, color: Colors.white),
                      onPressed: () {},
                      label: Text(
                        'แชท',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      icon: Icon(Icons.check, color: Colors.white),
                      onPressed: () {},
                      label: Text(
                        'ยืนยัน',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    ElevatedButton.icon(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {},
                      label: Text(
                        'ปฎิเสธ',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCircularNumberButton(int number) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedButton = number;
          // Add your logic to change content based on the selected button.
          // For example, update a text or perform some action.
          updateContent(number);
        });
      },
      style: ElevatedButton.styleFrom(
        primary: selectedButton == number ? Colors.blue : null,
        shape: CircleBorder(),
      ),
      child: Text(
        number.toString(),
        style: TextStyle(
          color: selectedButton == number ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  void updateContent(int number) {
    // Implement your logic here to update content based on the selected button.
    // For example, update a text or perform some action.
    print('Button $number pressed');
  }
}

MyTextStyle() {
  return TextStyle(
    fontSize: 18,
    color: Colors.black,
  );
}

Widget buildCircularNumberButton(int number) {
  return InkWell(
    onTap: () {
      // โค้ดที่ต้องการให้ทำงานเมื่อปุ่มถูกกด
    },
    child: Container(
      width: 40, // ปรับขนาดตามต้องการ
      height: 40, // ปรับขนาดตามต้องการ
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black, // สีขอบ
          width: 2.0, // ความกว้างขอบ
        ),
      ),
      child: Center(
        child: Text(
          '$number',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
