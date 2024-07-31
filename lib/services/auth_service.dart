import 'dart:convert';

import 'package:banana_challenge/models/login_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String apiUrl = 'https://dummyjson.com';

class AuthService with ChangeNotifier {
  User user = User();
  bool _authenticating = false;

  bool get authenticating => _authenticating;
  set authenticating(bool value) {
    _authenticating = value;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    authenticating = true;

    final data = {
      'username': username,
      'password': password,
    };

    Uri url = Uri.parse('$apiUrl/auth/login');
    final resp = await http.post(url, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
    });

    authenticating = false;
    if (resp.statusCode == 200) {
      user = User.fromRawJson(resp.body);

      return true;
    } else {
      return false;
    }
  }
}
