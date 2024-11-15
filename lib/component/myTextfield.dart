import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final bool obsecureText;
  final TextEditingController controller;
  MyTextfield({
    super.key,
    required this.hintText,
    required this.obsecureText,
    required this.controller,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28),
      child: TextField(
        controller: controller,
        obscureText: obsecureText,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.tertiary),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary)),
            fillColor: Theme.of(context).colorScheme.secondary,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            )),
      ),
    );
  }
}
