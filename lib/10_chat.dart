import 'package:flutter/material.dart';
import 'package:swapitem/widget/chat_detail.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("แชท"),
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
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () {
                // Navigate to the chat detail page when the row is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatDetail()),
                );
              },
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset(
                          'assets/images/pramepree.png',
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Shivam Gupta',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Hello, What are you doing?',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45))
                        ],
                      ),
                      Spacer(),
                      Text(
                        '4:30 PM',
                        style: TextStyle(color: Colors.black45),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
