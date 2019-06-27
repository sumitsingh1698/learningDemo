import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:zo/wigdet/products/title_text.dart';
import '../scoped_model/main.dart';
import '../models/product.dart';

class ProductPage extends StatelessWidget {

  _showWarningDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('This action cannot be undone!'),
            actions: <Widget>[
              FlatButton(
                child: Text('DISCARD'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('CONTINUE'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return  ScopedModelDescendant<MainModel>(builder: (BuildContext context,Widget child,MainModel model){
        Product product = model.getSelectedProduct;
        return Scaffold(
          appBar: AppBar(
            title: Text(product.title),
            automaticallyImplyLeading: true,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(product.image),
              Container(
                padding: EdgeInsets.all(10.0),
                child: TitleText(product.title),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text('DELETE'),
                  onPressed: () => _showWarningDialog(context),
                ),
              )
            ],
          ),
        );
      },);

  }
}
