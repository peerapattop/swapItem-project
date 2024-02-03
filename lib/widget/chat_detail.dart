import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:swapitem/widget/chat_service.dart';

import 'chat_bubble.dart';

class ChatDetail extends StatefulWidget {
  final String receiverUid;

  const ChatDetail({
    Key? key,
    required this.receiverUid,
  }) : super(key: key);

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String username1 = '';
  String imageUser1 = '';

  @override
  void initState() {
    super.initState();
    fetchUserData(widget.receiverUid).then((userData) {
      if (userData != null) {
        setState(() {
          username1 = userData['username']!;
          imageUser1 = userData['imageUser']!;
        });
      }
    });
  }

  Future<Map<String, String>?> fetchUserData(String userId) async {
    try {
      DatabaseReference reference = FirebaseDatabase.instance.ref();
      DatabaseEvent event = await reference
          .child('users')
          .orderByChild('uid')
          .equalTo(userId)
          .once();

      DataSnapshot dataSnapshot = event.snapshot;

      if (dataSnapshot.value != null && dataSnapshot.value is Map) {
        Map<dynamic, dynamic> userData =
            dataSnapshot.value as Map<dynamic, dynamic>;
        if (userData.values.isNotEmpty) {
          var user = userData.values.first;
          String username = user['username'];
          String imageUser = user['image_user'];

          Map<String, String> userDataMap = {
            'username': username,
            'imageUser': imageUser,
          };

          // Return the user data
          return userDataMap;
        } else {
          print('ไม่พบข้อมูล user');
          return null;
        }
      } else {
        print('ไม่พบข้อมูล user');
        return null;
      }
    } catch (e) {
      print('เกิดข้อผิดพลาด: $e');
      return null;
    }
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      try {
        await _chatService.sendMessage(
          widget.receiverUid,
          _messageController.text,
        );
        print("Message sent successfully: ${_messageController.text}");
        _messageController.clear();
      } catch (error) {
        print("Error sending message: $error");
        // Handle the error as needed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black, // Specify the border color
                    width: 1.0, // Specify the border width
                  ),
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imageUser1),
                  radius: 20, // Increase the radius to your desired size
                ),
              ),
              const SizedBox(width: 8),
              Text(username1),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.receiverUid,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        DataSnapshot dataSnapshot = snapshot.data!.snapshot;
        Map<dynamic, dynamic> messages =
            (dataSnapshot.value as Map<dynamic, dynamic>) ?? {};
        List<dynamic> messageList = messages.values.toList();

        return ListView.builder(
          itemCount: messageList.length,
          itemBuilder: (context, index) {
            var message = messageList[index];

            // Check if the message is of type Map
            if (message is Map<dynamic, dynamic>) {
              return _buildMessageItem(message);
            } else {
              // Handle the case where the message is not a Map
              return SizedBox.shrink(); // or another appropriate widget
            }
          },
        );
      },
    );
  }

  Widget _buildMessageItem(dynamic message) {
    return FutureBuilder<Map<String, String>?>(
      future: fetchUserData(widget.receiverUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for data, return a loading indicator or placeholder
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If there's an error during fetching, handle it
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data != null) {
          // If data is available, build and return the message item widget
          Map<String, String> userData = snapshot.data!;
          username1 = userData['username']!;
          imageUser1 = userData['imageUser']!;
          var alignment =
              (message['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? Alignment.centerRight
                  : Alignment.centerLeft;

          return Container(
            alignment: alignment,
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment:
                  (message['senderId'] == _firebaseAuth.currentUser!.uid)
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              mainAxisAlignment: (message['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                ChatBubble(message: message['message'],time: message['timestamp'],),
              ],
            ),
          );
        } else {
          // If no data is available, return a placeholder or handle accordingly
          return const Text('No user data available');
        }
      },
    );
  }

  Widget _buildMessageInput() {
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
          const Icon(Icons.text_format, color: Color(0xFF113953), size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "ส่งข้อความเลย!!",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_upward, size: 40),
            onPressed: () {
              sendMessage();
            },
          ),
        ],
      ),
    );
  }
}
