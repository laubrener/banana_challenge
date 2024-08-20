import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:banana_challenge/models/products_model.dart';
import 'package:banana_challenge/services/auth_service.dart';

class ProductService with ChangeNotifier {
  List<Product>? _productsList = [];
  List<Product>? _productsSearchList = [];
  bool _noResp = false;
  bool _isLoading = true;

  List<Product>? get productsList => _productsList;
  List<Product>? get productsSearchList => _productsSearchList;

  bool get noResp => _noResp;
  bool get isLoading => _isLoading;

  set noResp(bool value) {
    _noResp = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set productsList(List<Product>? value) {
    _productsList = value;
    notifyListeners();
  }

  set productsSearchList(List<Product>? value) {
    _productsSearchList = value;
    notifyListeners();
  }

  Future<List<Product>?> getProducts() async {
    // isLoading = true;
    Uri url = Uri.parse('$apiUrl/products');
    final resp = await http.get(url);
    ProductsModel products = ProductsModel.fromRawJson(resp.body);
    productsList = products.products;
    isLoading = false;
    return productsList;
  }

  Future<List<Product>?> getProductsByQuery(String query) async {
    isLoading = true;
    Uri url = Uri.parse('$apiUrl/products/search?q=$query');
    final resp = await http.get(url);
    ProductsModel products = ProductsModel.fromRawJson(resp.body);
    productsSearchList = products.products;
    if (products.total != 0) {
      noResp = false;
    } else {
      noResp = true;
    }
    isLoading = false;
    return productsSearchList;
  }
}

class ProductDetailService with ChangeNotifier {
  Product productDetail = Product();

  Future<Product>? getProductDetail(int id) async {
    Uri url = Uri.parse('$apiUrl/products/$id');
    final resp = await http.get(url);
    productDetail = Product.fromRawJson(resp.body);

    return productDetail;
  }
}
