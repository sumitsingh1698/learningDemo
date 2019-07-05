import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
// import 'package:flutter/rendering.dart';

import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import 'scoped_model/main.dart';


void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  MainModel mainModel = MainModel();
  bool _isAuthenticated = false;
  @override
  void initState() {
    mainModel.getUser();
    mainModel.userSubject.listen((bool isAuthnticated){
      setState((){
        _isAuthenticated = isAuthnticated;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return ScopedModel<MainModel>(
      model: mainModel,
      child: MaterialApp(
        // debugShowMaterialGrid: true,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.orange,
          buttonColor: Colors.deepPurple,
          backgroundColor: Colors.deepPurple,
          primaryColorDark: Colors.orange,
          iconTheme: IconThemeData(color: Colors.deepPurple),
        ),
//        home: ScopedModelDescendant(builder: (BuildContext context,Widget child,MainModel model){
//          return model.authenticateUser == null? AuthPage(): ProductsPage(mainModel);
//        }),
        routes: {
        '/': (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductsPage(mainModel),
          '/productspage': (BuildContext context) => !_isAuthenticated ? AuthPage() :ProductsPage(mainModel),
          '/admin': (BuildContext context) => !_isAuthenticated ? AuthPage() :ProductsAdminPage(mainModel),
          '/product': (BuildContext context) => !_isAuthenticated ? AuthPage() :ProductPage(),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            final int index = int.parse(pathElements[2]);
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) =>
                  ProductPage(),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage(mainModel));
        },
      ),
    );
  }
}
