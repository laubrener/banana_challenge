import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:banana_challenge/helpers/show_alert.dart';
import 'package:banana_challenge/pages/home_page.dart';
import 'package:banana_challenge/services/auth_service.dart';
import 'package:banana_challenge/widgets/btn.dart';
import 'package:banana_challenge/widgets/custom_input.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Bienvenido',
              style: TextStyle(fontSize: 36),
            ),
            LoginForm()
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController userCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = context.watch<AuthService>();

    void isLoginOk(loginOk) {
      if (loginOk == true) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    HomePage(user: authService.user)));
      } else {
        showAlert(context, 'Login incorrect', 'Check your credentials');
      }
    }

    return authService.authenticating
        ? const Center(
            child: CircularProgressIndicator(color: Colors.grey),
          )
        : Column(
            children: [
              CustomInput(
                icon: Icons.person_2_outlined,
                placeholder: 'Usuario',
                textController: userCtrl,
              ),
              CustomInput(
                icon: Icons.lock_outline,
                isPassword: true,
                placeholder: 'Contraseña',
                textController: passwordCtrl,
              ),
              Btn(
                text: 'Ingresar',
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  bool loginOk = await authService.login(
                      userCtrl.text.trim(), passwordCtrl.text.trim());
                  isLoginOk(loginOk);
                },
              )
            ],
          );
  }
}
