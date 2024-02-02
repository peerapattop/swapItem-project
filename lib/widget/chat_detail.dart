import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:swapitem/widget/chat_service.dart';

class ChatDetail extends StatefulWidget {
  final String username;
  final String imageUser;
  final String receiverUid;

  const ChatDetail({
    Key? key,
    required this.username,
    required this.imageUser,
    required this.receiverUid,
  }) : super(key: key);

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
    var alignment =
    (message['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        children: [Text(message['message']), Text(message['senderId'])],
      ),
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
                hintText: "Type your message",
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
