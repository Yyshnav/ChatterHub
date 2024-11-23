import 'package:chatapp/auth/auth_service.dart';
import 'package:chatapp/chat/chatservices.dart';
import 'package:chatapp/component/chat_bubble.dart';
import 'package:chatapp/component/myTextfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;

  ChatPage({super.key, required this.receiverEmail, required this.receiverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _msgController = TextEditingController();
  bool _showEmojiPicker = false;

  final Chatservices _chatservices = Chatservices();
  final AuthService _authService = AuthService();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _showEmojiPicker = false; // Hide emoji picker when typing
        });
        Future.delayed(
          Duration(milliseconds: 500),
          () => _scrollDown(),
        );
      }
    });
    Future.delayed(
      Duration(milliseconds: 500),
      () => _scrollDown(),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _sendMsg() async {
    if (_msgController.text.isNotEmpty) {
      await _chatservices.sendmsg(widget.receiverId, _msgController.text);
      _msgController.clear();
      _scrollDown();
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
          if (_showEmojiPicker) _buildEmojiPicker(),
          _buildUserInput(),
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
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderId'] == _authService.getcurrentuser()!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data["message"], iscurrentuser: isCurrentUser),
        ],
      ),
    );
  }

  Widget _buildEmojiPicker() {
    return EmojiPicker(
      onEmojiSelected: (category, emoji) {
        _msgController.text += emoji.emoji;
        _msgController.selection = TextSelection.fromPosition(
          TextPosition(offset: _msgController.text.length),
        );
      },
      config: Config(
        height: 250, // Adjust the height for better visibility
        emojiTextStyle: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20.0,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _showEmojiPicker = !_showEmojiPicker;
              });
              if (_showEmojiPicker) {
                _focusNode
                    .unfocus(); // Hide the keyboard when emoji picker is shown
              } else {
                _focusNode
                    .requestFocus(); // Show the keyboard when emoji picker is hidden
              }
            },
            icon: Icon(Icons.emoji_emotions_outlined),
          ),
          Expanded(
            child: MyTextfield(
              focusNode: _focusNode,
              hintText: "Type a message...",
              obsecureText: false,
              controller: _msgController,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: _sendMsg,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
