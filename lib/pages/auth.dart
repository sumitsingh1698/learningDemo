import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './products.dart';
import '../scoped_model/main.dart';

class AuthPage extends StatelessWidget {
  final bool _arrangedTerm = false;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
   String email;
   String password;

  BoxDecoration _buildBackgroundImage() {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/food.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7), BlendMode.dstATop)));
  }

  Widget _buildLoginTextField() {
    return TextFormField(
      onSaved: (String value) {
        email = value;
      },
      validator: (String value){
        if(value.isEmpty || !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value))
             return 'email is required or enter a valid email';
      },
      decoration: InputDecoration(
          labelText: 'Login id',
          filled: true,
          fillColor: Colors.white.withOpacity(0.4)),
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      onSaved: (String value) {
        password = value;
      },

      validator: (String value){
        print('repo email');
        if(value.isEmpty || !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$').hasMatch(value) ) {
          print('repo email 2');
          return 'Password must be at least 4 characters, no more than 8 characters, and must include at least one upper case letter, one lower case letter, and one numeric digit.';
        }
          },
      decoration: InputDecoration(
          labelText: 'Password',
          filled: true,
          fillColor: Colors.white.withOpacity(0.4)),
    );
  }

  Widget _buildSubmitRaisedButton(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context,Widget child,MainModel model){
      return RaisedButton(
        color: Theme.of(context).accentColor,
        child: Text(
          'LOGIN',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          if(!formkey.currentState.validate())
            return;
          else{
            formkey.currentState.save();
            model.login(email, password);
            Navigator.pushReplacementNamed(context, '/productspage');
          }
        },
      );
    },);
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
                  child: Form(
                    key: formkey,
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
                  ))),
        ),
      ),
    );
  }
}
