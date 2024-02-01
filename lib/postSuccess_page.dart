import 'package:intl/intl.dart';

import '5_his_post.dart';
import 'package:flutter/material.dart';

class PostSuccess extends StatefulWidget {
  final String postNumber;
  final String date;
  final String time;
  const PostSuccess(
      {super.key,
      required this.time,
      required this.date,
      required this.postNumber});

  @override
  State<PostSuccess> createState() => _SuccessPostState();
}

class _SuccessPostState extends State<PostSuccess> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("โพสต์สำเร็จ"),
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
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Center(
              child: Column(children: [
                Image.asset(
                  'assets/images/ture_post.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  "โพสต์สำเร็จ",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                const SizedBox(height: 20),
                Text(
                  "หมายเลขการโพสต์ ${widget.postNumber}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple),
                ),
                const SizedBox(height: 20),
                Text(
                  "วันที่ ${DateFormat('d MMMM yyyy', 'th').format(DateTime.parse(widget.date))}",
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
                Text(
                  "เวลา ${widget.time} น.",
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: 240,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HistoryPost(),
                        ),
                      );
                    },
                    child: const Text(
                      "ประวัติการโพสต์",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.home),
                    TextButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child:
                          const Text('หน้าแรก', style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
