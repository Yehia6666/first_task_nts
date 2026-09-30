import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Exposes the [StatefulNavigationShell] and shell-level navigation actions
/// (branch switching and back) to the screens rendered inside the shell.
///
/// The shell provides this scope; branch screens (drawer, headers, buttons)
/// read it to navigate without holding a reference to the shell themselves.
class AppNavScope extends InheritedWidget {
  const AppNavScope({
    super.key,
    required this.navigationShell,
    required this.goBranch,
    required this.goBack,
    required super.child,
  });

  final StatefulNavigationShell navigationShell;

  /// Switches to the branch at [index], remembering the current branch so
  /// [goBack] can return to it.
  final ValueChanged<int> goBranch;

  /// Returns to the branch that was active before the last [goBranch].
  final VoidCallback goBack;

  static AppNavScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppNavScope>();
    assert(scope != null, 'AppNavScope not found in the widget tree');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppNavScope oldWidget) =>
      navigationShell.currentIndex != oldWidget.navigationShell.currentIndex;
}
