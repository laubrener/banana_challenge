import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:banana_challenge/models/products_model.dart';
import 'package:banana_challenge/services/auth_service.dart';

class ProductService with ChangeNotifier {
  bool isLoading = false;
  List<Product>? productsList = [];
  List<Product>? productsSearchList = [];
  bool noResp = false;
  Product productDetail = Product();

  Future<List<Product>?> getProducts() async {
    isLoading = true;
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

  Future<Product>? getProductDetail(int id) async {
    Uri url = Uri.parse('$apiUrl/products/$id');
    final resp = await http.get(url);
    productDetail = Product.fromRawJson(resp.body);

    return productDetail;
  }
}
