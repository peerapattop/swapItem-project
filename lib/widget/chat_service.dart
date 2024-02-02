import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'message.dart';


class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _firebaseRel = FirebaseDatabase.instance;

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final DateTime timeStamp = DateTime.now();

    Message newMessage = Message(
      senderId: currentUserId,
      message: message,
      timestamp: timeStamp,
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



