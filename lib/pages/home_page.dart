import 'package:chatapp/auth/auth_service.dart';
import 'package:chatapp/chat/chatservices.dart';
import 'package:chatapp/component/my_drawer.dart';
import 'package:chatapp/component/user_tile.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

void logout() {
  final _auth = AuthService();
  _auth.signout();
}

final Chatservices _chatservice = Chatservices();
final AuthService _authService = AuthService();

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Homepage")),
        actions: [
          IconButton(onPressed: () => logout, icon: Icon(Icons.login_outlined))
        ],
      ),
      drawer: MyDrawer(),
      body: _builduserList(),
    );
  }

  Widget _builduserList() {
    return StreamBuilder(
      stream: _chatservice.getuserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("loading....");
        }
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _builduserlistitem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _builduserlistitem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getcurrentuser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverEmail: userData["email"],
                ),
              ));
        },
      );
    } else {
      return SizedBox();
    }
  }
}
