import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../login/presentation/screens/login_screen.dart';
import '../cubit/database_setup_cubit.dart';
import '../states/database_setup_state.dart';
import '../widgets/database_setup_card.dart';

class DatabaseUrlSetupScreen extends StatefulWidget {
  const DatabaseUrlSetupScreen({super.key});

  @override
  State<DatabaseUrlSetupScreen> createState() => _DatabaseUrlSetupScreenState();
}

class _DatabaseUrlSetupScreenState extends State<DatabaseUrlSetupScreen> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  static const double _maxCardWidth = 440;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<DatabaseSetupCubit>().state.url,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _openLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    );
  }

  void _syncField(String url) {
    if (_focusNode.hasFocus || _controller.text == url) return;
    _controller.text = url;
    _controller.selection = TextSelection.collapsed(offset: url.length);
  }

  void _handleSubmit() {
    FocusScope.of(context).unfocus();
    context.read<DatabaseSetupCubit>().onContinuePressed();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DatabaseSetupCubit, DatabaseSetupState>(
      listenWhen: (previous, current) => current.url != previous.url,
      listener: (context, state) => _syncField(state.url),
      child: BlocListener<DatabaseSetupCubit, DatabaseSetupState>(
        listenWhen: (previous, current) => current is DatabaseSetupReady,
        listener: (context, state) => _openLogin(context),
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.surface, AppColors.infoBlueContainer],
              ),
            ),
            child: SafeArea(
              child: BlocBuilder<DatabaseSetupCubit, DatabaseSetupState>(
                builder: (context, state) => _buildLayout(context, state),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLayout(BuildContext context, DatabaseSetupState state) {
    final verticalPadding = AppSpacing.xxxl;

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppResponsive.pagePadding(context),
          vertical: verticalPadding,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            // The window can be laid out before its size is known, and the
            // scroll view already has the padding subtracted, so the remaining
            // height can go negative. A negative minHeight is not a valid
            // constraint and takes the whole screen down with it.
            minHeight: (constraints.maxHeight - verticalPadding * 2)
                .clamp(0.0, double.infinity),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.all(Radius.circular(AppRadius.lg)),
                  child: Image.asset(
                    'assets/images/logo.jpeg',
                    width: AppSizes.logoSize,
                    height: AppSizes.logoSize,
                    fit: BoxFit.cover,
                    semanticLabel: 'App logo',
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _maxCardWidth),
                  child: DatabaseSetupCard(
                    controller: _controller,
                    focusNode: _focusNode,
                    isChecking: state is DatabaseSetupValidating,
                    canContinue: state.canContinue,
                    fieldError: _fieldErrorOf(state),
                    onChanged: context.read<DatabaseSetupCubit>().onUrlChanged,
                    onContinue: _handleSubmit,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _fieldErrorOf(DatabaseSetupState state) =>
      state is DatabaseSetupFailure ? state.message : null;
}