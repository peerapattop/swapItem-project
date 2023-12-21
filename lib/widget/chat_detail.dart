import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatDetail extends StatefulWidget {
  final String username;
  final String imageUser;

  ChatDetail({Key? key, required this.username,required this.imageUser}) : super(key: key);

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  late String username;
  late String imageUser;
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
    imageUser = widget.imageUser;
    getCurrentUsername();
  }

  void getCurrentUsername() {
    var user = currentUser;
    if (user != null) {
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users/${user.uid}/username');
      userRef.onValue.listen((event) {
        final String usernameme = event.snapshot.value as String;
        setState(() {
          currentUserUsername = usernameme;
        });
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
                      imageUser,
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

            return ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var message = messages.values.elementAt(index);
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
            onPressed: () => _sendMessage(currentUserUsername,imageUser),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String currentUserUsername,String imageUser) {
    DateTime now = DateTime.now();
    String messageText = _controller.text.trim();
    if (messageText.isNotEmpty && currentUserUsername.isNotEmpty) {
      userMessagesRef
          .child(username)
          .push()
          .set({
            'imageUser':imageUser,
            'text': messageText,
            'sender': currentUserUsername,
            'recevier': username,
            'time': now.hour.toString().padLeft(2, '0') +
                ":" +
                now.minute.toString().padLeft(2, '0')
          })
          .then((_) => _controller.clear())
          .catchError((error) {
            print("Failed to send message: $error");
          });
    }
  }
}
