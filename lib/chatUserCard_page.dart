import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        child: const ListTile(
          leading: CircleAvatar(
            child: Icon(CupertinoIcons.person),
          ),
          title: Text('Demo'),
          subtitle: Text('Last Message',maxLines: 1,),
          trailing: Text(
            '12:00 น.',
            style: TextStyle(color: Colors.black54,fontSize: 17),
          ),
        ),
      ),
    );
  }
}
