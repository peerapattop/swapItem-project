import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
          title: Text("Chat"),
        ),
        body: Center(child: Text("Please log in to view chats")),
      );
    } else {
      // User logged in, proceed to load chat data
      return Scaffold(
          appBar: AppBar(
            title: Text("Chat"),
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
                        String sender = messageData['sender'] ??
                            'Unknown'; // Provide a default value for 'sender'
                        // Create a widget for each message
                        messageWidgets
                            .add(MessageWidget(sender: sender, text: text));
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

class MessageWidget extends StatelessWidget {
  final String sender;
  final String text;

  const MessageWidget({
    Key? key,
    required this.sender,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 2),
          Text(
            text,
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
