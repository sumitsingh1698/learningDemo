import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../wigdet/products/products.dart';
import '../scoped_model/main.dart';
import '../wigdet/products/listTile.dart';

class ProductsPage extends StatefulWidget {
  final MainModel mainModel;
  ProductsPage(this.mainModel);
  @override
  State<StatefulWidget> createState() {

  return ProductsPageState();

    }
  }

  class ProductsPageState extends State<ProductsPage>{
  @override
  void initState() {
    widget.mainModel.fetchData().then((bool success){

    });
    super.initState();
  }
  Widget buildProducts(){

    return ScopedModelDescendant<MainModel>(builder: (BuildContext context,Widget child,MainModel model){
      Widget display = Center(child: Text('No Product Found'));
       if(model.products.length > 0 && !model.isLoading){
        display = Products();
      }
      else if(model.isLoading){
        display =  Center(child: CircularProgressIndicator());
      }
      return RefreshIndicator(child: display, onRefresh: () => model.fetchData().then((bool success){

      }));
    });
  }
  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<MainModel>(builder: (BuildContext context,Widget child,MainModel model){
      return Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('Choose'),
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Manage Products'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/admin');
                },
              ),
              Divider(),
              ListTileLogout(),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('EasyList'),
          actions: <Widget>[
            IconButton(
              icon: Icon(model.getShowFavorite == true? Icons.favorite:Icons.favorite_border,color: Colors.white,),
              onPressed: (){
                      model.toggleShowFavorite();
              },
            )
          ],
        ),
        body: buildProducts(),
      );
    },);
  }
}
