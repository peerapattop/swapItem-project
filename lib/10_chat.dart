import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'widget/chat_detail.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({Key? key}) : super(key: key);
  @override
  _ChatHomePageState createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      // User not logged in
      return Scaffold(
        appBar: AppBar(
          title: Text("แชท"),
        ),
        body: Center(child: Text("Please log in to view chats")),
      );
    } else {
      // User logged in, proceed to load chat data
      return Scaffold(
          appBar: AppBar(
            title: const Text("แชท"),
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
          body: StreamBuilder(
            stream:
                _database.child('users/${currentUser?.uid}/messages').onValue,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData &&
                  !snapshot.hasError &&
                  snapshot.data?.snapshot.value != null) {
                Map<dynamic, dynamic> messageGroups =
                    snapshot.data!.snapshot.value;
                List<Widget> messageWidgets = [];

                messageGroups.forEach((groupKey, messages) {
                  if (messages is Map) {
                    // Sort the messages by time
                    var sortedMessages = messages.values.toList()
                      ..sort((a, b) =>
                          (b['time'] as String).compareTo(a['time'] as String));

                    // Assuming the sorted list is not empty, take the last message which is the latest
                    var latestMessage = sortedMessages.first;
                    String text = latestMessage['text'];
                    String receiver = latestMessage[
                        'receiver']; // Use 'receiver' instead of 'recevier'
                    String time = latestMessage['time'];
                    String imageUser = latestMessage['imageUser'];

                    messageWidgets.add(MessageListItem(
                      receiver: receiver,
                      text: text,
                      time: time,
                      imageUser: imageUser,
                    ));
                  }
                });

                return ListView(children: messageWidgets);
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                          'https://cdn-icons-png.flaticon.com/256/6663/6663862.png'),
                      SizedBox(height: 10),
                      Text(
                        'กรุณายื่นข้อเสนอหรือสร้างโพสต์เพื่อเริ่มแชท',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                );
              }
            },
          ));
    }
  }
}

class MessageListItem extends StatelessWidget {
  final String receiver;
  final String text;
  final String time;
  final String imageUser;

  const MessageListItem({
    Key? key,
    required this.receiver,
    required this.text,
    required this.time,
    required this.imageUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetail(
                username: receiver,
                imageUser: imageUser,
              ),
            ),
          );
        },
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage:
                  NetworkImage(imageUser), // Load image from network
              radius: 30, // Size of the avatar
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    receiver,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    text,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
