import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:swapitem/widget/chat.dart';

class ChatDetail extends StatefulWidget {
  final String username;

  ChatDetail({Key? key, required this.username}) : super(key: key);

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  late String username;
  final TextEditingController _controller = TextEditingController();
  User? get currentUser => FirebaseAuth.instance.currentUser;
  String currentUserUsername = '';

  @override
  void initState() {
    super.initState();
    username = widget.username;
    getCurrentUsername(); // Call the method to set up the listener
  }

  void getCurrentUsername() {
    var user = currentUser;
    if (user != null) {
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref('users/${user.uid}/username');
      userRef.onValue.listen((event) {
        final String usernameme = event.snapshot.value as String;
        setState(() {
          currentUserUsername = usernameme;
        });
      });
    }
  }

  Stream<QuerySnapshot> getMessagesStream() {
    return FirebaseFirestore.instance
        .collection('chats')
        .orderBy('timestamp')
        .snapshots();
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
                    child: Image.asset(
                      'assets/images/pramepree.png',
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
            stream: getMessagesStream(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<QueryDocumentSnapshot> messages = snapshot.data!.docs;
              return ListView.builder(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var message = messages[index].data() as Map<String, dynamic>;
                  String text = message['text'];
                  String sender = message['sender'];

                  return Container(
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
                            text,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
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
          Icon(Icons.add, color: Color(0xFF113953), size: 30),
          SizedBox(width: 10),
          Icon(Icons.emoji_emotions, color: Color(0xFF113953), size: 30),
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
            onPressed: () => _sendMessage(currentUserUsername),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String currentUserUsername) {
    String messageText = _controller.text.trim();
    if (messageText.isNotEmpty && currentUserUsername.isNotEmpty) {
      FirebaseFirestore.instance.collection('chats').add({
        'text': messageText,
        'sender': currentUserUsername,
        'recipient': username,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _controller.clear();
    }
  }
}
