import 'package:chatapp/auth/auth_service.dart';
import 'package:chatapp/chat/chatservices.dart';
import 'package:chatapp/component/chat_bubble.dart';
import 'package:chatapp/component/myTextfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;
  ChatPage({super.key, required this.receiverEmail, required this.receiverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _msgControler = TextEditingController();

  final Chatservices _chatservices = Chatservices();

  final AuthService _authService = AuthService();
  FocusNode myfocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    myfocusNode.addListener(() {
      if (myfocusNode.hasFocus) {
        Future.delayed(
          Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
    Future.delayed(
      Duration(microseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myfocusNode.dispose();
    _msgControler.dispose();
    super.dispose();
  }

  final ScrollController scrollcntroler = ScrollController();
  void scrollDown() {
    scrollcntroler.animateTo(scrollcntroler.position.maxScrollExtent,
        duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  void sendMsg() async {
    if (_msgControler.text.isNotEmpty) {
      await _chatservices.sendmsg(widget.receiverId, _msgControler.text);
      _msgControler.clear();
      scrollDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.receiverEmail.replaceAll("@gmail.com", ""),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _builduserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _authService.getcurrentuser()!.uid;
    return StreamBuilder(
      stream: _chatservices.getMessages(widget.receiverId, senderId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("erorr");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        return ListView(
          controller: scrollcntroler,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageitem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageitem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentuser = data['senderId'] == _authService.getcurrentuser()!.uid;
    var alignmentt =
        isCurrentuser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignmentt,
      child: Column(
        crossAxisAlignment:
            isCurrentuser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data["message"], iscurrentuser: isCurrentuser),
        ],
      ),
    );
  }

  Widget _builduserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, left: 10),
      child: Row(
        children: [
          Expanded(
              child: MyTextfield(
                  focusNode: myfocusNode,
                  hintText: "Type a message...",
                  obsecureText: false,
                  controller: _msgControler)),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            margin: const EdgeInsets.only(right: 35),
            child: IconButton(
              onPressed: sendMsg,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
