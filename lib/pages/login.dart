import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("learn demo"),
        ),
        body: Container(
          child: RaisedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
            child: Text("Login"),
          ),
        ),
      ),
    );
  }
}
