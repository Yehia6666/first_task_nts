import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeIllustration extends StatelessWidget {
  const HomeIllustration({super.key, this.height = 176});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Center(
        child: SvgPicture.asset(
          'assets/images/home/worker_mascot.svg',
          width: height * 1.18,
          fit: BoxFit.contain,
          semanticsLabel: 'Construction worker mascot',
        ),
      ),
    );
  }
}
