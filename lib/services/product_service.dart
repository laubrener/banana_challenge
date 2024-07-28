import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:banana_challenge/models/products_model.dart';

class ProductService with ChangeNotifier {
  List<Product>? productsList = [];
  Future<List<Product>?> getProducts() async {
    Uri url = Uri.parse('https://dummyjson.com/products');
    final resp = await http.get(url);
    final products = ProductsModel.fromRawJson(resp.body);
    productsList = products.products;

    return productsList;
  }
}
