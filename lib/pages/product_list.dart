import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'product_edit.dart';
import '../scoped_model/products.dart';
import '../models/product.dart';

class ProductListPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant < ProductsModel > (
        builder: (BuildContext context, Widget child, ProductsModel model){
      List<Product> products = model.products;
      if (products.isEmpty)
        return Center(
          child: Text('Empty product'),
        );
      else {
        return ListView.builder(
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key(products[index].title),
                background: Container(
                    color: Colors.red,
                    margin: EdgeInsets.only(bottom: 10)

                ),
                secondaryBackground: Container(
                  color: Colors.green,
                  margin: EdgeInsets.only(bottom: 10),
                ),
                resizeDuration: Duration(seconds: 5),
                onDismissed: (DismissDirection direc) {
                  if (direc == DismissDirection.startToEnd){
                    model.selectedProductIndex = index;
                    model.deleteProduct();
                  }
                  if (direc == DismissDirection.endToStart) {
                    print('end to start');
                  }
                },
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                          backgroundImage: AssetImage(products[index].image)),
                      title: Text(products[index].title),
                      subtitle: Text('\$${products[index].price}'),
                      trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProductEditPage(index:index)));
                          }),
                    ),
                    Divider(
                      color: Theme
                          .of(context)
                          .accentColor,
                    ),
                  ],
                ),
              );
            });
      }

  },);
}
}