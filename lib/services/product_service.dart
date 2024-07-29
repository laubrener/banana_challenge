import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:banana_challenge/models/products_model.dart';

class ProductService with ChangeNotifier {
  List<Product>? productsList = [];
  Product productDetail = Product();
  Future<List<Product>?> getProducts() async {
    Uri url = Uri.parse('https://dummyjson.com/products');
    final resp = await http.get(url);
    ProductsModel products = ProductsModel.fromRawJson(resp.body);
    productsList = products.products;

    return productsList;
  }

  Future<Product>? getProductDetail(int id) async {
    Uri url = Uri.parse('https://dummyjson.com/products/$id');
    final resp = await http.get(url);
    productDetail = Product.fromRawJson(resp.body);

    return productDetail;
  }
}
