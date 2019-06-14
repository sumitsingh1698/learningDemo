import 'package:flutter/material.dart';

class Price_Tag extends StatelessWidget{
  final String price;
  Price_Tag(this.price);
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 6.0),
      decoration:
      BoxDecoration(color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Text('\$ $price',style: TextStyle(color: Colors.white),),
    );
  }
}