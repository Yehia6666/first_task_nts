import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.height = 80, this.width = 80});
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/home/logo.jpeg',
      height: height,
      width: height,
    );
  }
}
