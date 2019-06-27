import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'product_edit.dart';
import '../scoped_model/main.dart';
import '../models/product.dart';

class ProductListPage extends StatefulWidget {

  final MainModel mainModel;
  ProductListPage(this.mainModel);

  @override
  State<StatefulWidget> createState() {

    return _ProductListPageState();
  }
}
class _ProductListPageState extends State<ProductListPage>{

  @override
  void initState() {
    widget.mainModel.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant < MainModel > (
        builder: (BuildContext context, Widget child, MainModel model){
      List<Product> products = model.products;
      if (products.length == null && !model.isLoading)
        return Center(
          child: Text('Empty product'),
        );
      else if(products.length > 0 && !model.isLoading){
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
                    model.deleteProduct().then((bool isWork){

                    });
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
      else {
        return Center(child: CircularProgressIndicator(),);
      }

  },);
}
}