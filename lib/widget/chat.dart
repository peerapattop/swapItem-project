import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';

class ChatPerson extends StatefulWidget {
  const ChatPerson({super.key});

  @override
  State<ChatPerson> createState() => _ChatPersonState();
}

class _ChatPersonState extends State<ChatPerson> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 80),
          child: ClipPath(
            clipper: UpperNipMessageClipper(MessageType.receive),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFE1E1E2),
              ),
              child: Text(
                'Hi, Developer How Are you?',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 80),
            child: ClipPath(
              clipper: LowerNipMessageClipper(MessageType.send),
              child: Container(
                padding:
                    EdgeInsets.only(left: 20, top: 10, bottom: 25, right: 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 81, 81, 250),
                ),
                child: Text(
                  'Hi, Prame I am Fine',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
