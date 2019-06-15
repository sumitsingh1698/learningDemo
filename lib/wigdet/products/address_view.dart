import 'package:flutter/material.dart';

class AddressView extends StatelessWidget{
  final String address;
  AddressView(this.address);

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(border: Border.all(width: 1.0,color: Colors.grey),borderRadius: BorderRadius.circular(5.0)),
      child:Text(address),
      padding: EdgeInsets.symmetric(horizontal: 6.0,vertical: 6.0),);
  }
}