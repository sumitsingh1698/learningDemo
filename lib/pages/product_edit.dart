import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../scoped_model/main.dart';

class ProductEditPage extends StatefulWidget {
  final int index;

  ProductEditPage({this.index});

  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formdata = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpg',
  };
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget _productTitleTextField(String title) {
    return TextFormField(
      initialValue: title == null ? '' : title,
      decoration: InputDecoration(labelText: 'Product Title'),
      validator: (String value) {
        if (value.isEmpty) return 'tile is required';
      },
      onSaved: (String value) {
        _formdata['title'] = value;
      },
    );
  }

  Widget _productDescriptionTextField(String descrip) {
    return TextFormField(
      initialValue: descrip == null ? '' : descrip,
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

  Widget _productPriceTextField(String price) {
    return TextFormField(
      initialValue: price == null ? '' : price,
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

  void _buttonPressed(MainModel model) {
    if (!formKey.currentState.validate()) {
      return;
    }
    formKey.currentState.save();

    if (widget.index != null) {
      print('update');
      model.selectProduct(model.products[widget.index].id);
      model
          .updateProduct(_formdata['title'], _formdata['description'],
              _formdata['price'], _formdata['image'])
          .then((bool success) {
        Navigator.pushReplacementNamed(context, '/productspage');
      });
    } else
      model
          .addProduct(_formdata['title'], _formdata['description'],
              _formdata['price'], _formdata['image'])
          .then((bool success) {
        if (success)
          Navigator.pushReplacementNamed(context, '/productspage');
        else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Went something worng!'),
                  content: Text('please try again.'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Okay'),
                    )
                  ],
                );
              });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    final double phoneWidth = MediaQuery.of(context).size.width;
    final double viewWidth =
        phoneWidth > 500 ? phoneWidth * 0.8 : phoneWidth * 0.95;
    final double listViewPadding = phoneWidth - viewWidth;
    Widget pageEdit = GestureDetector(onTap: () {
      FocusScope.of(context).requestFocus(FocusNode());
    }, child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      List<Product> products = model.products;
      String title = '';
      String descip = '';
      String price = '';
      if (widget.index != null) {
        title = products[widget.index].title;
        descip = products[widget.index].description;
        price = products[widget.index].price.toString();
      }
      return Container(
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: listViewPadding),
            children: <Widget>[
              _productTitleTextField(title),
              _productDescriptionTextField(descip),
              _productPriceTextField(price),
              SizedBox(
                height: 50.0,
              ),
              model.isLoading == true
                  ? Center(child: CircularProgressIndicator())
                  : RaisedButton(
                      child: Text('Save'),
                      textColor: Colors.white,
                      onPressed: () => _buttonPressed(model),
                    )
            ],
          ),
        ),
      );
    }));
    return widget.index == null
        ? pageEdit
        : Scaffold(
            appBar: AppBar(
              title: Text("Edit Product"),
            ),
            body: pageEdit,
          );
  }
}
