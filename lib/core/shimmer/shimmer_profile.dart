import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProfile extends StatelessWidget {
  const ShimmerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Shimmer.fromColors(
      baseColor: Colors.grey.withValues(alpha: 0.20),
      highlightColor: Colors.grey.withValues(alpha: 0.10),
      child: ListView(
        children: [
          // ── Profile Card ──
          Container(
            height: height * 0.5,
            margin: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            
          ),

          // ── Contact Information ──
          Container(
            height: height *0.3,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadiusDirectional.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('    '),
                SizedBox(height: 4),
                Text('                   '),
                Divider(color: Colors.grey[100]),
                SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
