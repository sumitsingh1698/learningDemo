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
  String selectedProductId;

  Future<bool> addProduct(
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
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
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
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      print(error);
      return false;
    });
  }

  bool _showFavorite = false;

  List<Product> get allProducts {
    return List.from(products);
  }

  List<Product> get displayProducts {
    if (_showFavorite) {
      List<Product> pro = List.from(products.where((Product product) {
        print(' is fav ${product.isFavorite}');
        return product.isFavorite == true;
      }));
      for (int i = 0; i < pro.length; i++) {
        print(pro[i].title);
      }
      return pro;
    }

    return List.from(products);
  }

  int get getSelectedIndex {
    int i = 0;
    if (selectedProductId == null) {
      print('null selected Productid');
      return null;
    } else {
      print('else is call');

      products.firstWhere((Product product) {
        i++;
        return product.id == selectedProductId;
      });
    }
    selectedProductIndex = i - 1;
    print('sda;lkfjasd dfasdfas dfasd ');
    return selectedProductIndex;
  }

  bool get getShowFavorite {
    return _showFavorite;
  }

  Product get getSelectedProduct {
    if (selectedProductId == null)
      return null;
    else
      return products.firstWhere((Product product) {
        return product.id == selectedProductId;
      });
  }

  Future<bool> deleteProduct() {
    return http
        .delete(
            'https://flutterapp-7dbb9.firebaseio.com/products/${getSelectedProduct.id}.json')
        .then((http.Response response) {
      products.removeAt(getSelectedIndex);
      selectedProductId = null;
      return true;
    }).catchError((error) {
      return false;
    });
  }

  Future<bool> updateProduct(
      String title, String description, double price, String image) {
    _isLoading = true;
    notifyListeners();
    Map<String, dynamic> putData = {
      'id': getSelectedProduct.id,
      'title': title,
      'description': description,
      'price': price,
      'image': image,
      'userId': authenticateUser.id,
      'userEmail': authenticateUser.email
    };
    return http
        .put(
            'https://flutterapp-7dbb9.firebaseio.com/products/${getSelectedProduct.id}.json',
            body: json.encode(putData))
        .then((http.Response response) {
      fetchData();
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void toggleIsLoading() {
    _isLoading = !_isLoading;
  }

  Future<bool> fetchData() {
    _isLoading = true;
    notifyListeners();
    return http
        .get('https://flutterapp-7dbb9.firebaseio.com/products.json')
        .then((http.Response response) {
      List<Product> fetchProducts = [];
      Map<String, dynamic> fetchData = json.decode(response.body);
      if (fetchData == null) {
        _isLoading = false;
        notifyListeners();
        return true;
      }
      fetchData.forEach((String id, dynamic value) {
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
    }).catchError((error) {
      _isLoading = false;
      return false;
    });
  }

  void selectProduct(String id) {
    selectedProductId = id;
  }

  void toggleProductFavorite() {
    Product selectedProduct = getSelectedProduct;
    final isCurrentStatus = selectedProduct.isFavorite;
    final newStatus = !isCurrentStatus;
    print('i am here');
    final Product product = Product(
      id: selectedProduct.id,
      title: selectedProduct.title,
      description: selectedProduct.description,
      price: selectedProduct.price,
      image: selectedProduct.image,
      userId: authenticateUser.id,
      userEmail: authenticateUser.email,
      isFavorite: newStatus,
    );
    print('$getSelectedProduct get selected product');
    products[getSelectedIndex] = product;
    selectedProductId == null;
    notifyListeners();
  }

  void toggleShowFavorite() {
    print('before$_showFavorite');
    _showFavorite = !_showFavorite;
    print('before$_showFavorite');
    notifyListeners();
  }

  void login(String email, String password) {
    authenticateUser = User(id: '12345', email: email, password: password);
  }

  Future<Map<String,dynamic>> signUp(String email, String password) async {
    Map<String, dynamic> signupData = {
      'email': email,
      'password': password,
      'returnSecureToken' : true,
    };
    final http.Response response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyBMftWPxvFPN0nYBIxvDEtVI3eLrulF2wE',
        body: json.encode(signupData),
        headers: {'Content-Type': 'application/json'}
        );
    Map<String,dynamic> responseData = json.decode(response.body);
    bool success = false;
    String message = 'Something went Wrong!';
    print(responseData);
    if(responseData.containsKey('idToken')){
      success = true;
      message = 'successfully done!';
    }else if(responseData['error']['message'] == 'EMAIL_EXISTS'){
      success = false;
      message = 'ID Already Exist';
    }
    return {'success': success,'message':  message};
  }
}

class UtilityModel extends ConnectedModel {
  bool get isLoading {
    return _isLoading;
  }
}
