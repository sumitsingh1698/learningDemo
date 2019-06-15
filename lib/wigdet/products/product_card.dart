import 'package:flutter/material.dart';

import 'price_tag.dart';
import 'title_text.dart';
import 'address_view.dart';

class ProductCard extends StatelessWidget{
  final Map<String,dynamic> product;
  final int productIndex;
  ProductCard(this.product,this.productIndex);

  @override
  Widget build(BuildContext context) {

    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(product['image']),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10.0),
                child: TitleText(product['title']),
              ),
              SizedBox(width: 10.0,),
              Price_Tag(product['price'].toString()),
            ],
          ),
          AddressView('Sangam Vihar, New Delhi'),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(icon: Icon(Icons.info),  onPressed: () => Navigator.pushNamed<bool>(
                  context, '/product/' + productIndex.toString()),),
              IconButton(icon: Icon(Icons.favorite_border,color: Colors.red,),  onPressed: (){}),
            ],
          )
        ],
      ),
    );
  }
}