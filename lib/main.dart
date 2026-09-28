import 'package:flutter/material.dart';

import 'app/masary_app.dart';
import 'core/di/injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final AppDependencies dependencies = buildAppDependencies();
  runApp(
    MasaryApp(
      attendanceCubit: dependencies.attendanceCubit,
      expensesCubit: dependencies.expensesCubit,
      homeCubit: dependencies.homeCubit,
      profileCubit: dependencies.profileCubit,
      databaseSetupCubit: dependencies.databaseSetupCubit,
      loginCubit: dependencies.loginCubit,
    ),
  );
}