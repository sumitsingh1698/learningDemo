import 'package:flutter/material.dart';

import './price_tag.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  Products(this.products) {
    print('[Products Widget] Constructor');
  }

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(products[index]['image']),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                products[index]['title'],
                style: TextStyle(
                    fontFamily: 'runner',
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 10.0,),
              Price_Tag(products[index]['price'].toString()),
          ],
          ),
          Container(
            decoration: BoxDecoration(border: Border.all(width: 1.0,color: Colors.grey),borderRadius: BorderRadius.circular(5.0)),
            child:Text('Sangam Vihar, New Delhi'),
            padding: EdgeInsets.symmetric(horizontal: 6.0,vertical: 6.0),),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(icon: Icon(Icons.info),  onPressed: () => Navigator.pushNamed<bool>(
                  context, '/product/' + index.toString()),),
              IconButton(icon: Icon(Icons.favorite_border,color: Colors.red,),  onPressed: (){}),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildProductList() {
    Widget productCards;
    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: _buildProductItem,
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
    return _buildProductList();
  }
}
