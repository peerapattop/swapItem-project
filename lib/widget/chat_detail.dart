import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatDetail extends StatefulWidget {
  final String username;
  final String imageUserReceiver;
  final String receiverUid;

  const ChatDetail(
      {Key? key,
      required this.username,
      required this.imageUserReceiver,
      required this.receiverUid})
      : super(key: key);

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  late String username;
  late String imageUserReceiver;
  late String imageUserSender;
  late String receiverUid;

  final TextEditingController _controller = TextEditingController();
  User? get currentUser => FirebaseAuth.instance.currentUser;
  String currentUserUsername = '';

  DatabaseReference get userMessagesRef {
    var user = currentUser;
    if (user != null) {
      return FirebaseDatabase.instance
          .ref()
          .child('users/${user.uid}/messages');
    }
    throw Exception('User not authenticated');
  }

  @override
  void initState() {
    super.initState();
    username = widget.username;
    imageUserReceiver = widget.imageUserReceiver;
    receiverUid = widget.receiverUid;

    getCurrentUsername();
  }

  void getCurrentUsername() {
    var user = currentUser;
    if (user != null) {
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users/${user.uid}');
      userRef.onValue.listen((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          final String username = data['username'] as String? ?? '';
          final String profileImage = data['image_user'] as String? ?? '';
          setState(() {
            currentUserUsername = username;
            imageUserSender = profileImage;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: Padding(
            padding: EdgeInsets.only(top: 1),
            child: AppBar(
              elevation: 20, // ปรับค่านี้ตามต้องการ
              leadingWidth: 30,
              title: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Image.network(
                      imageUserReceiver,
                      height: 45,
                      width: 45,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(username),
                ],
              ),
            ),
          ),
        ),
        body: StreamBuilder(
          stream: userMessagesRef.child(username).onValue,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            Map<dynamic, dynamic> messages =
                snapshot.data!.snapshot.value ?? {};

            // Convert the map to a list and sort it based on timestamp
            List<dynamic> sortedMessages = messages.values.toList();
            sortedMessages.sort((a, b) {
              // Parse the time strings to DateTime objects
              DateTime timeA = DateTime.parse("2000-01-01 " + a['time']);
              DateTime timeB = DateTime.parse("2000-01-01 " + b['time']);

              // Compare the DateTime objects
              return timeA.compareTo(timeB);
            });

            return ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: sortedMessages.length,
              itemBuilder: (context, index) {
                var message = sortedMessages[index];
                String text = message['text'];
                String sender = message['sender'];

                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: sender == currentUserUsername
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: sender == currentUserUsername
                                  ? Colors.blue
                                  : Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$text',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
        bottomSheet: _buildBottomSheet(),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.text_format
          , color: Color(0xFF113953), size: 30),
          SizedBox(width: 10),

          Expanded(
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "พิมพ์ข้อความที่ต้องการ",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Color(0xFF113953), size: 30),
            onPressed: () => _sendMessage(
                currentUserUsername, imageUserReceiver, receiverUid),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String currentUserUsername, String imageUserReceiver,
      String receiverUid) {
    DateTime now = DateTime.now();
    String messageText = _controller.text.trim();
    if (messageText.isNotEmpty && currentUserUsername.isNotEmpty) {
      var senderUid = currentUser?.uid;
      var receiverUidUser = receiverUid;
      String time = now.hour.toString().padLeft(2, '0') +
          ":" +
          now.minute.toString().padLeft(2, '0') +
          ":" +
          now.second.toString().padLeft(2, '0');
      if (senderUid != null) {
        // Sender's message
        userMessagesRef.child(username).push().set({
          'imageUserReceiver': imageUserReceiver,
          'imageUserSender': imageUserSender,
          'text': messageText,
          'sender': currentUserUsername,
          'senderUid': senderUid,
          'receiver': username,
          'receiverUid': receiverUidUser,
          'time': time,
        });

        // Receiver's message
        FirebaseDatabase.instance
            .ref()
            .child('users/$receiverUid/messages/$currentUserUsername')
            .push()
            .set({
              'imageUserReceiver': imageUserReceiver,
              'imageUserSender': imageUserSender,
              'text': messageText,
              'sender': currentUserUsername,
              'senderUid': senderUid,
              'receiver': username,
              'receiverUid': receiverUid,
              'time': time,
            })
            .then((_) => _controller.clear())
            .catchError((error) {
              print("Failed to send message: $error");
            });
      }
    }
  }
}
