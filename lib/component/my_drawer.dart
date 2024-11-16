import 'package:chatapp/auth/auth_service.dart';
import 'package:chatapp/pages/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  void logout() {
    final _auth = AuthService();
    _auth.signout();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                  child: Center(
                child: Icon(
                  Icons.message,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )),
              Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("H O M E"),
                  leading: Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("S E T T I N G S"),
                  leading: Icon(Icons.settings),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsPage(),
                        ));
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text("L O G O U T"),
              leading: Icon(Icons.logout),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
