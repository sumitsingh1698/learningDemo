import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../wigdet/products/products.dart';
import '../models/product.dart';
import '../scoped_model/products.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(builder: (BuildContext context,Widget child,ProductsModel model){
      return Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('Choose'),
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Manage Products'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/admin');
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('EasyList'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.favorite,color: Colors.white,),
              onPressed: (){

              },
            )
          ],
        ),
        body: Products(),
      );
    },);
  }
}
