import 'dart:convert';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/user.dart';

class ConnectedModel extends Model {
  List<Product> products = [];
  int selectedProductIndex;
  User authenticateUser;
  bool _isLoading;

  Future<Null> addProduct(
      String title, String description, double price, String image) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> postProduct = {
      'title': title,
      'description': description,
      'price': price,
      'image': image,
      'userId': authenticateUser.id,
      'userEmail': authenticateUser.email
    };
    return http
        .post('https://flutterapp-7dbb9.firebaseio.com/products.json',
            body: json.encode(postProduct))
        .then((http.Response response) {
      Map<String, dynamic> responseData = json.decode(response.body);

      Product product = Product(
          id: responseData['name'],
          title: title,
          description: description,
          price: price,
          image: image,
          userId: authenticateUser.id,
          userEmail: authenticateUser.email);
      products.add(product);
      print('${authenticateUser.email}email id');
      _isLoading = false;
      notifyListeners();
    });

  }

  bool _showFavorite = false;

  List<Product> get allProducts {
    return List.from(products);
  }

  List<Product> get displayProducts {
    if (_showFavorite)
      return List.from(products.where((Product product) => product.isFavorite));
    return List.from(products);
  }

  int get getSelectedIndex {
    return selectedProductIndex;
  }

  bool get getShowFavorite {
    return _showFavorite;
  }

  Product get getSelectedProduct {
    if (selectedProductIndex == null)
      return null;
    else
      return products[selectedProductIndex];
  }

  void deleteProduct() {
    http.delete('https://flutterapp-7dbb9.firebaseio.com/products/${getSelectedProduct.id}.json');
    products.removeAt(selectedProductIndex);
    selectedProductIndex = null;
  }

  Future<Null> updateProduct(
      String title, String description, double price, String image) {
    _isLoading = true;
    notifyListeners();
    Map<String,dynamic> putData = {
       'id':getSelectedProduct.id,
       'title': title,
       'description': description,
       'price': price,
       'image': image,
       'userId': authenticateUser.id,
       'userEmail': authenticateUser.email
     };
    return http.put('https://flutterapp-7dbb9.firebaseio.com/products/${getSelectedProduct.id}.json',body: json.encode(putData)).then((http.Response response){
      products[selectedProductIndex] = Product(
          id: getSelectedProduct.id,
          title: title,
          description: description,
          price: price,
          image: image,
          userId: authenticateUser.id,
          userEmail: authenticateUser.email);

      selectedProductIndex = null;
      _isLoading = false;
      notifyListeners();
    });

  }
   void toggleIsLoading(){
    _isLoading = !_isLoading;
   }
  Future<Null> fetchData(){
    _isLoading = true;
    notifyListeners();
     return http.get('https://flutterapp-7dbb9.firebaseio.com/products.json').then((http.Response response){
       List<Product> fetchProducts = [];
       Map<String,dynamic> fetchData = json.decode(response.body);
       if(fetchData == null){
         _isLoading = false;
         notifyListeners();
         return;
       }
       fetchData.forEach((String id,dynamic value){
         Product fetchProduct = Product(
           id: id,
           title: value['title'],
           description: value['description'],
           image: value['image'],
           price: value['price'],
           userEmail: value['userEmail'],
           userId: value['userId'],
         );
         fetchProducts.add(fetchProduct);
         _isLoading = false;
         notifyListeners();
       });
       products = fetchProducts;
     });
  }
  
  void selectProduct(int index) {
    selectedProductIndex = index;
  }

  void toggleProductFavorite() {
    final isCurrentStatus = getSelectedProduct.isFavorite;
    final newStatus = !isCurrentStatus;
    final Product product = Product(
      title: getSelectedProduct.title,
      description: getSelectedProduct.description,
      price: getSelectedProduct.price,
      image: getSelectedProduct.image,
      userId: authenticateUser.id,
      userEmail: authenticateUser.email,
      isFavorite: newStatus,
    );
    products[selectedProductIndex] = product;
    notifyListeners();
  }

  void toggleShowFavorite() {
    print('before$_showFavorite');
    _showFavorite = !_showFavorite;
    print('before$_showFavorite');
    notifyListeners();
  }
  void login(String email,String password){
    authenticateUser = User(id: '12345', email: email, password: password);
  }
}

class UtilityModel extends ConnectedModel{
  bool get isLoading {
    return _isLoading;
  }
}