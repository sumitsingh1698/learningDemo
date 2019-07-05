import 'dart:convert';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

import '../models/product.dart';
import '../models/user.dart';
import '../models/auth.dart';

class ConnectedModel extends Model {
  List<Product> products = [];
  int selectedProductIndex;
  User authenticateUser;
  bool _isLoading;
  String selectedProductId;
  PublishSubject<bool> _userSubject = PublishSubject();

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
        .post('https://flutterapp-7dbb9.firebaseio.com/products.json?auth=${authenticateUser.token}',
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
          userEmail: authenticateUser.email,);
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

  PublishSubject<bool> get userSubject{
    return _userSubject;
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
            'https://flutterapp-7dbb9.firebaseio.com/products/${getSelectedProduct.id}.json?auth=${authenticateUser.token}')
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
            'https://flutterapp-7dbb9.firebaseio.com/products/${getSelectedProduct.id}.json?auth=${authenticateUser.token}',
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
        .get('https://flutterapp-7dbb9.firebaseio.com/products.json?auth=${authenticateUser.token}')
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
          isFavorite: value['wishlist'] == null? false : (value['wishlist'] as Map<String,dynamic>).containsKey('${authenticateUser.id}'));
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

  void toggleProductFavorite() async{
    Product selectedProduct = getSelectedProduct;
    final isCurrentStatus = selectedProduct.isFavorite;
    final newStatus = !isCurrentStatus;
    http.Response response;
    if(newStatus){
      response = await http.put('https://flutterapp-7dbb9.firebaseio.com/products/${selectedProduct.id}/wishlist/${authenticateUser.id}.json?auth=${authenticateUser.token}',body: json.encode(true));
    }else{
      response = await http.delete('https://flutterapp-7dbb9.firebaseio.com/products/${selectedProduct.id}/wishlist/${authenticateUser.id}.json?auth=${authenticateUser.token}');
    }
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

  Future<Map<String,dynamic>> authentication(String email, String password,[authMode = AuthMode.Login]) async{
    _isLoading = true;
    notifyListeners();
    Map<String, dynamic> data = {
      'email': email,
      'password': password,
      'returnSecureToken' : true,
    };
    http.Response response;
    if(authMode == AuthMode.Login)
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyBMftWPxvFPN0nYBIxvDEtVI3eLrulF2wE',
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'}
      );
    else if(authMode == AuthMode.SignUp)
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyBMftWPxvFPN0nYBIxvDEtVI3eLrulF2wE',
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'}
      );

    Map<String,dynamic> responseData = json.decode(response.body);
    bool success = false;
    String message = 'Something went Wrong!';
    print(responseData);
    if(responseData.containsKey('idToken')){
      success = true;
      authenticateUser = User(id: responseData['localId'], email: email, token: responseData['idToken']);
      autoLogout(int.parse(responseData['expiresIn']));
      final DateTime now = DateTime.now();
      final DateTime expireTime = now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
      final SharedPreferences perf = await SharedPreferences.getInstance();
      perf.setString('idToken', responseData['idToken']);
      perf.setString('userEmail', email);
      perf.setString('userId', responseData['localId']);
      _userSubject.add(true);

      perf.setString('userExpireTime', expireTime.toIso8601String());
      message = 'successfully done!';
    }else if(responseData['error']['message'] == 'EMAIL_EXISTS'){
      success = false;
      message = 'ID Already Exist';
    }
    else if(responseData['error']['message'] == 'EMAIL_NOT_FOUND'){
      success = false;
      message = 'Email not found';
    }else if(responseData['error']['message'] == 'INVALID_PASSWORD'){
      success = false;
      message = 'Invalid password!!';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': success,'message':  message};
  }
  void  getUser() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('idToken');
    String expireTime = pref.getString('userExpireTime');

    if(token != null) {
      DateTime now = DateTime.now();
      DateTime expireOn = DateTime.parse(expireTime);
      if(expireOn.isBefore(now)) {
        authenticateUser = null;
        notifyListeners();
        return;
      }
        String id = pref.getString('userId');
        String email = pref.getString('userEmail');
        final int tokenLifeSpan = expireOn.difference(now).inSeconds;
        autoLogout(tokenLifeSpan);
      _userSubject.add(true);

      authenticateUser = User(id: id, email: email, token: token);
      notifyListeners();
    }

    }
  void logout() async {
    print('logut');
    authenticateUser = null;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('idToken');
    pref.remove('userEmail');
    pref.remove('userId');
    _userSubject.add(false);
  }
  void autoLogout(int time){
    Timer(Duration(seconds:time),logout);
  }
}

class UtilityModel extends ConnectedModel {
  bool get isLoading {
    return _isLoading;
  }
}
