import 'package:chatapp/auth/auth_service.dart';
import 'package:chatapp/component/myTextfield.dart';
import 'package:chatapp/component/my_Button.dart';
import 'package:chatapp/pages/login_page.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({
    super.key,
    required this.onTap,
  });
  TextEditingController _emController = TextEditingController();
  TextEditingController _pwController = TextEditingController();
  TextEditingController _cmController = TextEditingController();
  final void Function()? onTap;

  void Register(BuildContext context) async {
    final _auth = AuthService();
    if (_pwController.text == _cmController.text) {
      try {
        _auth.signupWithEmailAndPassword(
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
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("password doenot match"),
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
              "Let's create an account for you",
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
              height: 15,
            ),
            MyTextfield(
              controller: _cmController,
              hintText: "Confirm Password",
              obsecureText: false,
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              text: 'Register',
              onTap: () => Register(context),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already an member? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(onTap: onTap),
                          ));
                    },
                    child: Text(
                      "Login now",
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
