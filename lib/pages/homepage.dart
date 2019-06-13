import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("learn demo"),
        ),
        body: Container(
          child: RaisedButton(
            onPressed: () {},
            child: Text("Login"),
          ),
        ),
       );

  }
}
