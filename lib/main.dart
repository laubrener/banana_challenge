import 'package:banana_challenge/pages/home_page.dart';
import 'package:banana_challenge/pages/login.dart';
import 'package:banana_challenge/pages/product_detail_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Banana Challenge',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'login': (_) => const LoginPage(),
          'home': (_) => const HomePage(),
          'detail': (_) => const ProductPage()
        },
        theme: ThemeData.light().copyWith(
          appBarTheme: const AppBarTheme(color: Color(0xff9E007E)),
        ));
  }
}
