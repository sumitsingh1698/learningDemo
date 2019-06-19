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
    return WillPopScope(
      onWillPop: () {
        print('Back button pressed!');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: ScopedModelDescendant<MainModel>(builder: (BuildContext context,Widget child,MainModel model){
        List<Product> products = model.products;
        int index = model.getSelectedIndex;
        return Scaffold(
          appBar: AppBar(
            title: Text(products[index].title),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(products[index].image),
              Container(
                padding: EdgeInsets.all(10.0),
                child: TitleText(products[index].title),
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
      },),
    );
  }
}
