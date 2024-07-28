import 'package:flutter/material.dart';

class Btn extends StatelessWidget {
  final String text;
  final Function onPressed;
  const Btn({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        onPressed: () => onPressed(),
        elevation: 2,
        highlightElevation: 5,
        color: const Color(0xff9E007E),
        shape: const StadiumBorder(),
        child: Container(
          width: double.infinity,
          height: 45,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }
}
