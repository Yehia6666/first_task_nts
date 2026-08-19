import 'package:flutter/material.dart';

class ProfileCardImage extends StatelessWidget {
  const ProfileCardImage({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey[200],
      child: Icon(Icons.person, color: Colors.grey[500], size: 100),
    );
  }
}
