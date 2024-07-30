import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:banana_challenge/models/products_model.dart';

class ProductService with ChangeNotifier {
  List<Product>? productsList = [];
  List<Product>? productsSearchList = [];
  bool noResp = true;
  Product productDetail = Product();
  Future<List<Product>?> getProducts() async {
    Uri url = Uri.parse('https://dummyjson.com/products');
    final resp = await http.get(url);
    ProductsModel products = ProductsModel.fromRawJson(resp.body);
    productsList = products.products;

    return productsList;
  }

  Future<List<Product>?> getProductsByQuery(String query) async {
    Uri url = Uri.parse('https://dummyjson.com/products/search?q=$query');
    final resp = await http.get(url);
    ProductsModel products = ProductsModel.fromRawJson(resp.body);
    productsSearchList = products.products;
    if (productsSearchList != []) {
      noResp = false;
    }

    return productsSearchList;
  }

  Future<Product>? getProductDetail(int id) async {
    Uri url = Uri.parse('https://dummyjson.com/products/$id');
    final resp = await http.get(url);
    productDetail = Product.fromRawJson(resp.body);

    return productDetail;
  }
}
