import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String message, time;
  final bool isCurrentUser;
  const ChatBubble(
      {super.key,
      required this.message,
      required this.time,
      required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(time);

    String formattedTime = DateFormat('hh:mm a').format(dateTime.toLocal());
    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isCurrentUser ? Colors.green : Colors.grey.shade500,
          ),
          child: Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        // Text("ส่งเมื่อ $formattedTime",style: TextStyle(fontSize: 12),)
      ],
    );
  }
}
