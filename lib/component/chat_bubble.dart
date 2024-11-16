import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool iscurrentuser;
  const ChatBubble(
      {super.key, required this.message, required this.iscurrentuser});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: iscurrentuser ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
      padding: const EdgeInsets.all(16),
      child: Text(
        message,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
