import 'package:chatapp/auth/auth_service.dart';
import 'package:chatapp/component/myTextfield.dart';
import 'package:chatapp/component/my_Button.dart';
import 'package:chatapp/pages/register_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key, required this.onTap});
  final void Function()? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emController = TextEditingController();

  TextEditingController _pwController = TextEditingController();

  void login(BuildContext context) async {
    final _authservice = AuthService();
    try {
      await _authservice.signInWithEmailAndPassword(
          _emController.text, _pwController.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 50,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Welcome back you've been missed",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            MyTextfield(
              controller: _emController,
              hintText: "Email",
              obsecureText: false,
            ),
            const SizedBox(
              height: 15,
            ),
            MyTextfield(
              hintText: "Password",
              obsecureText: true,
              controller: _pwController,
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              text: 'Login',
              onTap: () => login(context),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not an member? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RegisterPage(onTap: widget.onTap),
                          ));
                    },
                    child: Text(
                      "Register now",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
