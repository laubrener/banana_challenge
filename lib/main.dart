import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:banana_challenge/pages/login_page.dart';
import 'package:banana_challenge/services/auth_service.dart';
import 'package:banana_challenge/services/product_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductService()),
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
          title: 'Banana Challenge',
          debugShowCheckedModeBanner: false,
          initialRoute: 'login',
          routes: {
            'login': (_) => const LoginPage(),
          },
          theme: ThemeData.light().copyWith(
            appBarTheme: const AppBarTheme(color: Color(0xff9E007E)),
          )),
    );
  }
}
