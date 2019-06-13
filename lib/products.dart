import 'package:flutter/material.dart';

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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 6.0),
              decoration:
                BoxDecoration(color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(6.0),
                ),
              child: Text('\$ ${products[index]['price'].toString()}',style: TextStyle(color: Colors.white),),
            ),
          ],
          ),
          Container(
            decoration: BoxDecoration(border: Border.all(width: 1.0,color: Colors.grey),borderRadius: BorderRadius.circular(5.0)),
            child:Text('Sangam Vihar, New Delhi'),
            padding: EdgeInsets.symmetric(horizontal: 6.0,vertical: 6.0),),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('Details'),
                onPressed: () => Navigator.pushNamed<bool>(
                    context, '/product/' + index.toString()),
              )
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
