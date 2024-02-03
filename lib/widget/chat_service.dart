import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'message.dart';


class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _firebaseRel = FirebaseDatabase.instance;


  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firebaseRel.ref('users').onValue.map((DatabaseEvent event) {
      // Process the snapshot data and convert it into a list of maps
      List<Map<String, dynamic>> userList = [];

      DataSnapshot dataSnapshot = event.snapshot;
      Map<dynamic, dynamic> data = dataSnapshot.value as Map<dynamic, dynamic>;

      data.forEach((key, value) {
        userList.add(Map<String, dynamic>.from(value));
      });

      return userList;
    });
  }



  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final DateTime timeStamp = DateTime.now();
    String time = "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";

    Message newMessage = Message(
      senderId: currentUserId,
      message: message,
      timestamp: time,
      receiverId: receiverId,
    );


    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    // Use timestamp in milliseconds as a unique key
    String messageId = timeStamp.millisecondsSinceEpoch.toString();

    // Set the message data under the unique key
    await _firebaseRel
        .ref('chat_rooms')
        .child(chatRoomId)
        .child('messages')
        .child(messageId)
        .set(newMessage.toMap());
  }

  Stream getMessages(String receiverUid, String senderUid) {
    List<String> ids = [receiverUid, senderUid];
    ids.sort();
    String chatRoomId = ids.join("_");

    return FirebaseDatabase.instance
        .ref('chat_rooms')
        .child(chatRoomId)
        .child('messages')
        .orderByChild('timestamp')
        .onValue;
  }

}




