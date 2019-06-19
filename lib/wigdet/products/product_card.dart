import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'price_tag.dart';
import 'title_text.dart';
import 'address_view.dart';
import '../../scoped_model/main.dart';
import '../../models/product.dart';

class ProductCard extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
      return ScopedModelDescendant<MainModel>(builder: (BuildContext context,Widget child,MainModel model){
        Product product = model.getSelectedProduct;
        int productIndex = model.getSelectedIndex;
        print(productIndex.toString()+'index  ');
        return Card(
          child: Column(
            children: <Widget>[
              Image.asset(product.image),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: TitleText(product.title),
                  ),
                  SizedBox(width: 10.0,),
                  Price_Tag(product.price.toString()),
                ],
              ),
              AddressView('Sangam Vihar, New Delhi'),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(icon: Icon(Icons.info),  onPressed: () {
                       model.selectProduct(productIndex);
                    Navigator.pushNamed<bool>(
                        context, '/product/' + productIndex.toString());
                  },),
                  IconButton(icon: Icon(model.products[productIndex].isFavorite == true ? Icons.favorite :Icons.favorite_border,color: Colors.red,),onPressed: (){
                    model.selectProduct(productIndex);
                    model.toggleProductFavorite();
                    print('234222344');
                  }),
                ],
              )
            ],
          ),
        );
      },);

  }
}