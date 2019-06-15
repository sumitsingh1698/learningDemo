import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  final Map<String,dynamic> _formdata = {
    'title': null,
    'description': null,
    'price': null,
     'image': 'assets/food.jpg',
  };
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget _productTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Title'),
      validator: (String value) {
        if (value.isEmpty) return 'tile is required';
      },
      onSaved: (String value) {
          _formdata['title'] = value;
      },
    );
  }

  Widget _productDescriptionTextField() {
    return TextFormField(
      maxLines: 4,
      validator: (String value) {
        if (value.isEmpty)
          return 'description can\'t be empty';
        else if (value.trim().length <= 20)
          return 'can\'t less then 20 character';
      },
      decoration: InputDecoration(labelText: 'Product Description'),
      onSaved: (String value) {
          _formdata['description'] = value;
      },
    );
  }

  Widget _productPriceTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Product Price'),
      validator: (String value) {
        if (value.isEmpty || !RegExp(r'^[-+]?[1-9]\d*\.?[0]*$').hasMatch(value))
          return 'price is required and can be a number';
      },
      onSaved: (String value) {
          _formdata['price'] = double.parse(value);
      },
    );
  }

  void _buttonPressed() {
    if (!formKey.currentState.validate()) {
      return;
    }
    formKey.currentState.save();
    widget.addProduct(_formdata);
    Navigator.pushReplacementNamed(context, '/productspage');
  }

  @override
  Widget build(BuildContext context) {
    final double phoneWidth = MediaQuery.of(context).size.width;
    final double viewWidth =
        phoneWidth > 500 ? phoneWidth * 0.8 : phoneWidth * 0.95;
    final double listViewPadding = phoneWidth - viewWidth;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: listViewPadding),
            children: <Widget>[
              _productTitleTextField(),
              _productDescriptionTextField(),
              _productPriceTextField(),
              SizedBox(
                height: 50.0,
              ),
              RaisedButton(
                child: Text('Save'),
                textColor: Colors.white,
                onPressed: _buttonPressed,
              )
            ],
          ),
        ),
      ),
    );
  }
}
