import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.time,this.isMe);

  final String message;
  final Timestamp time;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: isMe ? Theme.of(context).accentColor : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                  topRight: isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              width: 140,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                    ),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                  SizedBox(height: 8,),
                  Text(DateFormat("hh:mm a").format(time.toDate()),
                  style: TextStyle(color: Colors.black45),)
                ],
              ),
            ),
          ],
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
