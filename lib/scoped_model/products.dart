import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';

class ProductsModel extends Model{
  List<Product> _products = [];
  int selectedProductIndex;


  List<Product> get products {
    return List.from(_products);
  }
  int get getSelectedIndex{
    return selectedProductIndex;
  }
  Product get getSelectedProduct {
    if(selectedProductIndex == null)
      return null;
    else
      return _products[selectedProductIndex];
  }

  void addProduct(Product product) {
        _products.add(product);

  }
  void deleteProduct() {
    _products.removeAt(selectedProductIndex);
    selectedProductIndex = null;
  }
  void updateProduct(Product value) {
    _products[selectedProductIndex] = value;
     selectedProductIndex = null;
  }
  void selectProduct(int index){
    selectedProductIndex = index;
  }
  void toggleProductFavorite(){
    final isCurrentStatus = getSelectedProduct.isFavorite;
    final newStatus = !isCurrentStatus;
    final Product product = Product(
      title: getSelectedProduct.title,
      description: getSelectedProduct.description,
      price: getSelectedProduct.price,
      image: getSelectedProduct.image,
      isFavorite: newStatus,
    );
    _products[selectedProductIndex] = product;
    notifyListeners();
  }
}












