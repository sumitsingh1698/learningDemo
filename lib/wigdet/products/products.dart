import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_card.dart';
import '../../models/product.dart';
import '../../scoped_model/main.dart';

class Products extends StatelessWidget {

  Widget _buildProductList(List<Product> products,MainModel model) {
    Widget productCards;
    if (products.length > 0) {
      print('sdafja');
      productCards = ListView.builder(
        itemBuilder: (BuildContext context,int index) {
          model.selectProduct(products[index].id);
          return ProductCard();
        },
        itemCount: products.length,
      );
    } else {
      productCards = Container();
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context,Widget child,MainModel model){
      print('the game');
      return _buildProductList(model.displayProducts,model);
    },);
  }
}
