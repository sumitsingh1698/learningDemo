import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_model/main.dart';

enum AuthMode { Login, SignUp }

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  AuthMode _authMode = AuthMode.Login;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
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
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                .hasMatch(value))
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
      obscureText: true,
      controller: _passwordController,
      validator: (String value) {
        print('repo email');
        if (value.isEmpty ||
            !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                .hasMatch(value)) {
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

  Widget _buildConfirmPasswordTextField() {
    if (_authMode == AuthMode.Login)
      return SizedBox(
        height: 10,
      );
    return TextFormField(
      obscureText: true,
      validator: (String value) {
        if (_passwordController.text != value) {
          return 'Password not match';
        }
      },
      decoration: InputDecoration(
          labelText: 'Password',
          filled: true,
          fillColor: Colors.white.withOpacity(0.4)),
    );
  }

  Widget _buildSubmitRaisedButton(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        Map<String, dynamic> returnData;
        return RaisedButton(
          color: Theme.of(context).accentColor,
          child: Text(
            'LOGIN',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            if (!formKey.currentState.validate()) return;
            formKey.currentState.save();
            if (_authMode == AuthMode.SignUp) {
              final returnData = await model.signUp(email, password);
              if (returnData['success']) {
                Navigator.pushReplacementNamed(context, '/productspage');
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Have an Error'),
                        content: Text(returnData['message']),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Okay'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      );
                    });
              }
            } else {
              model.login(email, password);
            }
          },
        );
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
                  child: Form(
                    key: formKey,
                    child: Column(children: [
                      _buildLoginTextField(),
                      SizedBox(
                        height: 15,
                      ),
                      _buildPasswordTextField(),
                      SizedBox(
                        height: 20,
                      ),
                      _buildConfirmPasswordTextField(),
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                          onPressed: () {
                            setState(() {
                              if (_authMode == AuthMode.Login)
                                _authMode = AuthMode.SignUp;
                              else
                                _authMode = AuthMode.Login;
                            });
                          },
                          child: Text(
                              'Swtich to ${_authMode == AuthMode.Login ? 'SignUp' : 'Login'}')),
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
