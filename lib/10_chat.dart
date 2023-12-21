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
                // Extract your data from the snapshot
                Map<dynamic, dynamic> messageGroups =
                    snapshot.data!.snapshot.value;

                // Debug print the message groups
                print('Message groups data: $messageGroups');

                // Convert the nested map to a list of message widgets
                List<Widget> messageWidgets = [];
                messageGroups.forEach((groupKey, messages) {
                  // Assuming 'messages' is a map, iterate over the messages
                  if (messages is Map) {
                    messages.forEach((messageKey, messageData) {
                      // Check if 'text' exists and is not null
                      if (messageData != null && messageData['text'] != null) {
                        String text = messageData['text'];
                        String receiver = messageData['recevier'];
                        String time = messageData['time'];
                        messageWidgets.add(MessageListItem(
                            receiver: receiver, text: text, time: time));
                      } else {
                        // Handle the case where 'text' is not available
                        print(
                            'Warning: Message text is null for message key $messageKey in group $groupKey');
                      }
                    });
                  }
                });

                // Display the list of messages
                return ListView(children: messageWidgets);
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Center(child: CircularProgressIndicator());
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

  const MessageListItem({
    Key? key,
    required this.receiver,
    required this.text,
    required this.time,
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
              ),
            ),
          );
        },
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(''), // Load image from network
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
