import 'package:first_task_nts/features/auth/presentation/widget/database_container.dart';
import 'package:flutter/material.dart';

class ServerScreenBody extends StatelessWidget {
  const ServerScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 70),
        Image.asset('assets/images/home/logo.jpeg', height: 80, width: 80),
        DatabaseContainer(),
      ],
    );
  }
}
