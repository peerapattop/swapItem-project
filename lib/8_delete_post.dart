import 'package:flutter/material.dart';

class DeletePost extends StatefulWidget {
  const DeletePost({super.key});

  @override
  State<DeletePost> createState() => _DeletePostState();
}

class _DeletePostState extends State<DeletePost> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("ยืนยันการลบโพสต์"),
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
        body: Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Center(
            child: Column(children: [
              Container(
                child: Image.asset(
                  'assets/images/binn.png',
                  width: 100,
                  height: 100,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "ต้องการลบโพสต์หรือไม่",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "หมายเลขการโพสต์ /0001",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "วันที่ 11 กันยายน 2566",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                "เวลา 22:04 น.",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: 200,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text('ยืนยัน'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 200,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => OfferRequest()),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: Text('ยกเลิก'),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
