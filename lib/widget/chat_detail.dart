import 'package:flutter/material.dart';
import 'package:swapitem/widget/chat.dart';

import 'chatbottomsheet.dart';

class ChatDetail extends StatefulWidget {
  const ChatDetail({Key? key}) : super(key: key);

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: Padding(
            padding: EdgeInsets.only(top: 5),
            child: AppBar(
              elevation: 20, // ปรับค่านี้ตามต้องการ
              leadingWidth: 30,
              title: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Image.asset(
                      'assets/images/pramepree.png',
                      height: 45,
                      width: 45,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text('Shivam Gupta'),
                ],
              ),
            ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.only(top: 20,left: 20,right: 20),
          children: [
            ChatPerson(),
            ChatPerson(),
            ChatPerson(),
            ChatPerson(),
            ChatPerson(),
          ],
        ),
        bottomSheet: ChatBottomSheet(),
      ),
    );
  }
}
