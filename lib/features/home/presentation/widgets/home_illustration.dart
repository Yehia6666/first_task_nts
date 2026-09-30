import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class HomeIllustration extends StatelessWidget {
  const HomeIllustration({super.key, this.size = AppSizes.homeMascotSize});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.tealContainer,
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        'assets/images/home/worker_mascot.svg',
        width: size * 0.82,
        height: size * 0.82,
        fit: BoxFit.contain,
        semanticsLabel: 'Construction worker mascot',
      ),
    );
  }
}
