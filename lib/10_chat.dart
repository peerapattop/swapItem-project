import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapitem/widget/chat_detail.dart';
import 'package:swapitem/widget/chat_service.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({Key? key}) : super(key: key);

  @override
  _ChatHomePageState createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> getLastMessage(String roomId) async {
    try {
      final DatabaseEvent event = await FirebaseDatabase.instance
          .ref()
          .child('chat_rooms')
          .child(roomId)
          .child('messages')
          .orderByChild('timestamp')
          .limitToLast(1)
          .once();

      final DataSnapshot dataSnapshot = event.snapshot;

      if (dataSnapshot.value != null) {
        var messageMap = dataSnapshot.value as Map?;
        if (messageMap != null && messageMap.isNotEmpty) {
          var message = messageMap.values.first['message'];
          var timestamp = messageMap.values.first['timestamp'];
          return {'message': message, 'timestamp': timestamp};
        } else {
          return {'message': 'No messages', 'timestamp': 0};
        }
      } else {
        return {'message': 'No messages', 'timestamp': 0};
      }
    } catch (e) {
      return {'message': 'Error loading data', 'timestamp': 0};
    }
  }

  Future<String?> getChatRoomIdByUserIds(String senderUid, String receiverUid) async {
    String combinedUid = "$senderUid _$receiverUid";
    DatabaseReference chatRoomsRef = FirebaseDatabase.instance.ref().child('chat_rooms');

    DataSnapshot snapshot = (await chatRoomsRef.orderByChild('messages').equalTo(combinedUid).once()) as DataSnapshot;

    if (snapshot.value != null) {
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      String chatRoomId = values.keys.first;
      return chatRoomId;
    }

    return null; // หากไม่พบ Chat Room ID
  }

  @override
  Widget build(BuildContext context) {
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
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
        stream: _chatService.getUserStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 15),
                  Text('กำลังดาวน์โหลด...'),
                ],
              ),
            );
          }
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData['uid'] != _auth.currentUser?.uid) {
      return Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetail(
                  receiverUid: userData['uid'],
                ),
              ),
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(userData['image_user']),
              radius: 30,
            ),
            title: Text(userData['username'],
                style: const TextStyle(fontSize: 20)),
            subtitle: FutureBuilder<Map<String, dynamic>>(
              future: getLastMessage('H6MO9knsIlayG8vvCEm6QQC2etW2_Z6panzsinkbIOIFOVKAcvOzl33n2'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                } else {
                  var lastMessage = snapshot.data?['message'] ?? 'No messages';
                  var timestamp = snapshot.data?['timestamp'] ?? 0;
                  var lastMessageTime = _formatTime(timestamp);
                  return Row(
                    children: [
                      Expanded(
                        child: Text(
                          '$lastMessage',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '$lastMessageTime',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  String _formatTime(String timestamp) {
    // Remove the " น." suffix (with or without space before "น.")
    timestamp = timestamp.replaceAll(RegExp(r'\s*น\.$'), '');

    // Parse the timestamp to a DateTime object
    var dateTime = DateTime.parse(timestamp);

    var hour = dateTime.hour;
    var minute = dateTime.minute.toString().padLeft(2, '0');
    var period = (hour < 12) ? 'น.' : 'น.';

    if (hour > 12) {
      hour -= 12;
    }
    if (hour == 0) {
      hour = 12;
    }

    return '$hour:$minute $period';
  }
}
