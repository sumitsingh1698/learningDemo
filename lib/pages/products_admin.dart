import 'package:flutter/material.dart';

import './product_edit.dart';
import './product_list.dart';
import '../scoped_model/main.dart';

class ProductsAdminPage extends StatelessWidget {
final MainModel mainModel;
ProductsAdminPage(this.mainModel);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('Choose'),
              ),
              ListTile(
                leading: Icon(Icons.shop),
                title: Text('All Products'),
                onTap: () {
                  if(mainModel.authenticateUser != null)
                  Navigator.pushReplacementNamed(context, '/productspage');
                  else
                    Navigator.pushReplacementNamed(context, '/');
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Manage Products'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: 'Create Product',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'My Products',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[ProductEditPage(), ProductListPage(mainModel)],
        ),
      ),
    );
  }
}
