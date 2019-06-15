import 'package:flutter/material.dart';

import './products.dart';

class AuthPage extends StatelessWidget {
  final bool _arrangedTerm = false;

  BoxDecoration _buildBackgroundImage() {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/food.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7), BlendMode.dstATop)));
  }

  Widget _buildLoginTextField() {
    return TextField(
      onSubmitted: (String value) {},
      decoration: InputDecoration(
          labelText: 'Login id',
          filled: true,
          fillColor: Colors.white.withOpacity(0.4)),
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      onSubmitted: (String value) {},
      decoration: InputDecoration(
          labelText: 'Password',
          filled: true,
          fillColor: Colors.white.withOpacity(0.4)),
    );
  }

  Widget _buildSubmitRaisedButton(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).accentColor,
      child: Text(
        'LOGIN',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/productspage');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double phoneWidth = MediaQuery.of(context).size.width;
    final double size = phoneWidth > 500 ? phoneWidth * 0.7 : phoneWidth * 0.95;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        decoration: _buildBackgroundImage(),
        padding: EdgeInsets.all(15.0),
        child: Center(
          child: SingleChildScrollView(
              child: Container(
            alignment: Alignment.center,
            width: size,
            child: Column(children: [
              _buildLoginTextField(),
              SizedBox(
                height: 15,
              ),
              _buildPasswordTextField(),
              SizedBox(
                height: 20,
              ),
              _buildSubmitRaisedButton(context),
            ]),
          )),
        ),
      ),
    );
  }
}
