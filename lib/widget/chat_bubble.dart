import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message,time;
  const ChatBubble({super.key,required this.message,required this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue,
          ),
          child: Text(
            message,
            style: const TextStyle(fontSize: 16,color: Colors.white),
          ),
        ),
        Text(time)
      ],
    );
  }
}

