import 'package:flutter/material.dart';
import 'package:markflip/models/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel>? _products;

  List<ProductModel>? get products => _products;

  void addProducts(List<ProductModel> products) {
    _products = products;
    // notifyListeners();
  }
}
