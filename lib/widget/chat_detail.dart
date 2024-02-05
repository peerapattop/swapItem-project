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

  FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );

    fetchUserData(widget.receiverUid).then((userData) {
      if (userData != null) {
        setState(() {
          username1 = userData['username']!;
          imageUser1 = userData['imageUser']!;
        });
      }
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
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
        scrollDown();
      } catch (error) {
        print("Error sending message: $error");
        // Handle the error as needed
      }
    }
    scrollDown();
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
              child: buildChatWidget(),
            ),
            FutureBuilder<Widget>(
              future: _buildMessageInput(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // or a loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return snapshot.data!;
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChatWidget() {
    Future<Map<String, String>?> fetchUserDataFuture =
        fetchUserData(widget.receiverUid);

    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.receiverUid,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          DataSnapshot dataSnapshot = snapshot.data!.snapshot;
          Map<dynamic, dynamic>? messages =
              (dataSnapshot.value as Map<dynamic, dynamic>?) ?? {};
          List<dynamic> messageList = messages.values.toList();

          // Sort messages by timestamp in ascending order (oldest first)
          messageList.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

          return FutureBuilder<Map<String, String>?>(
            future: fetchUserDataFuture,
            builder: (context, userDataSnapshot) {
              if (userDataSnapshot.connectionState == ConnectionState.waiting) {
                return const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator(), Text('กำลังโหลด...')],
                );
              } else if (userDataSnapshot.hasError) {
                return Text('Error: ${userDataSnapshot.error}');
              } else if (userDataSnapshot.data != null) {
                Map<String, String> userData = userDataSnapshot.data!;
                username1 = userData['username']!;
                imageUser1 = userData['imageUser']!;

                return messageList.isNotEmpty
                    ? ListView.builder(
                        controller: _scrollController,
                        itemCount: messageList.length,
                        itemBuilder: (context, index) {
                          var message = messageList[index];

                          if (message is Map<dynamic, dynamic>) {
                            var alignment = (message['senderId'] ==
                                    _firebaseAuth.currentUser!.uid)
                                ? Alignment.centerRight
                                : Alignment.centerLeft;
                            bool isCurrent = (message['senderId'] ==
                                _firebaseAuth.currentUser!.uid);

                            return Container(
                              alignment: alignment,
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: (message['senderId'] ==
                                        _firebaseAuth.currentUser!.uid)
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                mainAxisAlignment: (message['senderId'] ==
                                        _firebaseAuth.currentUser!.uid)
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  ChatBubble(
                                    message: message['message'],
                                    time: message['timestamp'],
                                    isCurrentUser: isCurrent,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      )
                    : const Center(
                        child: Text(
                          'เริ่มแชทเลย!!',
                          style: TextStyle(fontSize: 20),
                        ),
                      );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        } else {
          // Stream is not active, show loading or handle accordingly
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator(), Text('กำลังดาวน์โหลด...')],
          );
        }
      },
    );
  }

  Future<Widget> _buildMessageInput() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userStatus = ''; // Default value if not found or not premium

    if (currentUser != null) {
      String userId = currentUser.uid;

      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users').child(userId);

      DatabaseEvent event = await userRef.once();
      DataSnapshot dataSnapshot = event.snapshot;

      if (dataSnapshot.value != null) {
        var userMap = dataSnapshot.value as Map?;
        // Assuming 'status_user' is a String field in the database
        userStatus = userMap?['status_user'] ?? '';
      }
    }

    bool userIsPremium = userStatus == 'ผู้ใช้พรีเมี่ยม';

    return Column(
      children: [
        _quickMessage(userIsPremium),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                child: Focus(
                  focusNode: myFocusNode,
                  child: TextFormField(
                    obscureText: false,
                    controller: _messageController,
                    onEditingComplete: () {
                      sendMessage();
                      scrollDown();
                    },
                    decoration: const InputDecoration(
                      hintText: "ส่งข้อความเลย!!",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_sharp, size: 40),
                onPressed: () {
                  sendMessage();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _sendMessageWithQuickReply(String message) {
    _messageController.text = message;
    sendMessage();
  }

  Widget _quickMessage(bool isVip) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        height: 50,
        child: Row(
          children: isVip
              ? [
                  ElevatedButton(
                    onPressed: () {
                      _sendMessageWithQuickReply("สวัสดี");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                    ),
                    child: const Text("สวัสดี",
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      _sendMessageWithQuickReply("ยังมีสิ่งของนี้ไหม?");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                    ),
                    child: const Text(
                      "ยังมีสิ่งของนี้ไหม",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      _sendMessageWithQuickReply("คุณสะดวกวันที่เท่าไหร่");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                    ),
                    child: const Text("คุณสะดวกวันที่เท่าไหร่",
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      _sendMessageWithQuickReply(
                          "สภาพการใช้งานเป็นอย่างไรบ้าง");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                    ),
                    child: const Text("สภาพการใช้งาน",
                        style: TextStyle(color: Colors.white)),
                  ),
                ]
              : [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      "กรุณาสมัคร VIP!! เพื่อใช้แชทด่วน",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
