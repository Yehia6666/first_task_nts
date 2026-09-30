import 'package:first_task_nts/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:first_task_nts/core/constants/app_colors.dart';
import 'package:first_task_nts/core/constants/app_radius.dart';
import 'package:first_task_nts/core/di/injection_container.dart';
import 'package:first_task_nts/core/utils/app_router.dart';
import 'package:first_task_nts/core/widgets/app_bottom_navigation.dart';
import 'package:first_task_nts/core/widgets/app_search_field.dart';
import 'package:first_task_nts/features/attendance/data/datasources/attendance_local_data_source.dart';
import 'package:first_task_nts/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:first_task_nts/features/attendance/domain/usecases/filter_attendance_logs.dart';
import 'package:first_task_nts/features/attendance/domain/usecases/get_attendance_logs.dart';
import 'package:first_task_nts/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:first_task_nts/features/attendance/presentation/screens/attendance_logs_screen.dart';
import 'package:first_task_nts/features/expenses/data/datasources/expense_local_data_source.dart';
import 'package:first_task_nts/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:first_task_nts/features/expenses/domain/usecases/filter_expenses.dart';
import 'package:first_task_nts/features/expenses/domain/usecases/get_expenses.dart';
import 'package:first_task_nts/features/expenses/domain/usecases/summarize_expenses.dart';
import 'package:first_task_nts/features/expenses/presentation/cubit/expenses_cubit.dart';
import 'package:first_task_nts/features/home/data/data_source/home_local_data_source.dart';
import 'package:first_task_nts/features/home/data/repo/home_repo_imp.dart';
import 'package:first_task_nts/features/home/domain/use_cases/check_in_use_case.dart';
import 'package:first_task_nts/features/home/domain/use_cases/get_today_session_use_case.dart';
import 'package:first_task_nts/features/home/presentation/manager/home_cubit/home_cubit.dart';

AttendanceCubit buildAttendanceCubit() => AttendanceCubit(
      getAttendanceLogs: GetAttendanceLogs(
        AttendanceRepositoryImpl(AttendanceLocalDataSource()),
      ),
      filterAttendanceLogs: const FilterAttendanceLogs(),
    );

ExpensesCubit buildExpensesCubit() => ExpensesCubit(
      getExpenses: GetExpenses(
        ExpenseRepositoryImpl(ExpenseLocalDataSource()),
      ),
      filterExpenses: const FilterExpenses(),
      summarizeExpenses: const SummarizeExpenses(),
    );

HomeCubit buildHomeCubit() {
  final source = HomeLocalDataSource();
  return HomeCubit(
    getTodaySession: GetTodaySessionUseCase(HomeRepoImp(source)),
    checkIn: CheckInUseCase(HomeRepoImp(source)),
  );
}

NtsApp buildApp() => const NtsApp();

/// Renders the app on a phone-sized surface matching the mobile reference.
void usePhoneSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

/// Background color of a drawer item's pill for [label] (transparent when the
/// item is not selected).
Color drawerItemColor(WidgetTester tester, String label) => tester.widget<Material>(
      find.ancestor(
        of: find.descendant(
          of: find.byType(Drawer),
          matching: find.text(label),
        ),
        matching: find.byType(Material),
      ).first,
    ).color!;

/// Whether the bottom-nav item for [label] currently shows the active pill.
bool navItemHasActiveBackground(WidgetTester tester, String label) {
  final decoration = tester.widget<Container>(
    find.ancestor(
      of: find.descendant(
        of: find.byType(AppBottomNavigation),
        matching: find.text(label),
      ),
      matching: find.byType(Container),
    ).first,
  ).decoration! as BoxDecoration;
  return decoration.color == AppColors.primaryContainer;
}

void main() {
  setUp(() async {
    AppRouter.router.go(AppRouter.home);
    await resetServiceLocator();
    await setupServiceLocator();
  });

  testWidgets('Attendance Logs screen loads sections from static data', (tester) async {
    final cubit = buildAttendanceCubit();
    addTearDown(cubit.close);

    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: const MaterialApp(home: AttendanceLogsScreen()),
      ),
    );

    // Initial frame renders the loading state.
    expect(find.text('Attendance Logs'), findsOneWidget);

    // Let the static data source finish (400ms simulated delay).
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Yesterday'), findsOneWidget);
    expect(find.text('Check In'), findsWidgets);
    expect(find.text('Check Out'), findsWidgets);
  });

  testWidgets('Attendance search filters records and clearing restores all', (tester) async {
    final cubit = buildAttendanceCubit();
    addTearDown(cubit.close);

    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: const MaterialApp(home: AttendanceLogsScreen()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));

    // All records are shown initially.
    expect(find.text('No attendance records found'), findsNothing);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Yesterday'), findsOneWidget);

    // A query matching nothing shows the empty state immediately.
    await tester.enterText(find.byType(TextField), 'zzzz');
    await tester.pump();
    expect(find.text('No attendance records found'), findsOneWidget);

    // A query matching a visible field (status label) restores records.
    await tester.enterText(find.byType(TextField), 'pending');
    await tester.pump();
    expect(find.text('No attendance records found'), findsNothing);

    // Clearing the search field restores every attendance item.
    await tester.enterText(find.byType(TextField), '');
    await tester.pump();
    expect(find.text('No attendance records found'), findsNothing);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Yesterday'), findsOneWidget);
  });

  testWidgets('AppSearchField defaults match the Expense reference design', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppSearchField(controller: controller, hintText: 'Search expenses...'),
        ),
      ),
    );

    // White surface, large radius, ~48px height, subtle shadow, no border.
    final container = tester.widget<Container>(
      find
          .descendant(of: find.byType(AppSearchField), matching: find.byType(Container))
          .first,
    );
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, AppColors.surface);
    expect(decoration.borderRadius, BorderRadius.circular(AppRadius.xl));
    expect(decoration.border, isNull);
    expect(decoration.boxShadow, isNotEmpty);
    expect(container.constraints?.maxHeight, 48);

    // Muted gray search icon on the left and muted gray hint text.
    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.decoration?.prefixIcon, isA<Icon>());
    expect((textField.decoration!.prefixIcon! as Icon).color, AppColors.textMuted);
    expect(textField.decoration?.hintStyle?.color, AppColors.textMuted);
  });

  testWidgets('Home screen loads the check-in card and session card', (tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(buildApp());

    // Home is the initial tab; let the static data source finish.
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Ready to Start?'), findsOneWidget);
    expect(find.text('EARLIEST EVENT'), findsOneWidget);
    expect(find.text('09:00 AM'), findsOneWidget);
    expect(find.text('TARGET END'), findsOneWidget);
    expect(find.text('05:00 PM'), findsOneWidget);
    expect(find.text('ELAPSED'), findsOneWidget);
    expect(find.textContaining('%'), findsOneWidget);
    expect(find.text('One Tap Check In'), findsOneWidget);
    expect(find.text('Current Session'), findsOneWidget);
    expect(find.text('LOG HISTORY'), findsOneWidget);

    // The live clock renders with seconds (e.g. 02:34:23 PM).
    expect(
      find.textContaining(RegExp(r'^\d{2}:\d{2}:\d{2} (AM|PM)$')),
      findsOneWidget,
    );
  });

  testWidgets('One Tap Check In updates the session through the Cubit', (tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(buildApp());
    await tester.pump(const Duration(milliseconds: 600));

    await tester.tap(find.text('One Tap Check In'));
    await tester.pump();
    // The check-in goes through two 400ms simulated delays, so give it enough
    // time to complete before asserting.
    await tester.pump(const Duration(milliseconds: 900));

    // Button label flips to a done state and the session card turns "Present".
    expect(find.text('Checked In'), findsWidgets);
    expect(find.text('Present'), findsOneWidget);
    expect(find.textContaining('Checked in at'), findsOneWidget);

    // Let the snackbar dismiss timer finish so no timers stay pending.
    await tester.pump(const Duration(seconds: 5));
    await tester.pump(const Duration(milliseconds: 400));
  });

  testWidgets('Hamburger button opens the application drawer', (tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(buildApp());
    await tester.pump(const Duration(milliseconds: 600));

    await tester.tap(find.byTooltip('Open menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Header brand and all navigation items are present.
    expect(find.text('HitekNOFAL'), findsOneWidget);
    for (final label in ['Home', 'Time Off', 'Payroll', 'Expense', 'Attendance', 'Settings']) {
      expect(find.descendant(of: find.byType(Drawer), matching: find.text(label)), findsOneWidget);
    }

    // Home is the active drawer item.
    expect(drawerItemColor(tester, 'Home'), AppColors.primaryContainer);
    for (final label in ['Time Off', 'Payroll', 'Expense', 'Attendance', 'Settings']) {
      expect(drawerItemColor(tester, label), Colors.transparent);
    }

    // Selecting an item navigates to its destination and closes the drawer.
    await tester.tap(find.descendant(of: find.byType(Drawer), matching: find.text('Payroll')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(Drawer), findsNothing);
    expect(find.text('Payroll'), findsWidgets);
  });

  testWidgets('Drawer selection stays synchronized with the current destination', (tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(buildApp());
    await tester.pump(const Duration(milliseconds: 600));

    Future<void> openDrawer() async {
      await tester.tap(find.byTooltip('Open menu'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
    }

    // Open the drawer: Home is selected.
    await openDrawer();
    expect(drawerItemColor(tester, 'Home'), AppColors.primaryContainer);

    // Navigate to Expense from the drawer.
    await tester.tap(find.descendant(of: find.byType(Drawer), matching: find.text('Expense')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(Drawer), findsNothing);
    expect(find.text('Expenses'), findsOneWidget);

    // Return Home via the bottom nav, then reopen the drawer: Home is active.
    await tester.tap(find.text('Home'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await openDrawer();
    expect(drawerItemColor(tester, 'Home'), AppColors.primaryContainer);
    for (final label in ['Time Off', 'Payroll', 'Expense', 'Attendance', 'Settings']) {
      expect(drawerItemColor(tester, label), Colors.transparent);
    }
  });

  testWidgets('Drawer Attendance item opens the attendance screen', (tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(buildApp());
    await tester.pump(const Duration(milliseconds: 600));

    await tester.tap(find.byTooltip('Open menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Navigate to the existing attendance screen from the drawer.
    await tester.tap(find.descendant(of: find.byType(Drawer), matching: find.text('Attendance')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // The drawer closes and the attendance destination is shown.
    expect(find.byType(Drawer), findsNothing);
    expect(find.text('Attendance Logs'), findsOneWidget);

    // The existing attendance screen loads its sections.
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Today'), findsOneWidget);

    // Attendance is drawer-only, so no bottom-nav item is highlighted; the nav
    // stays synchronized with the current (attendance) route.
    for (final label in ['Home', 'Time Off', 'Payroll', 'Expense']) {
      expect(navItemHasActiveBackground(tester, label), isFalse,
          reason: '$label must not be highlighted while Attendance is active');
    }
  });

  testWidgets('LOG HISTORY navigates to the attendance logs screen', (tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(buildApp());
    await tester.pump(const Duration(milliseconds: 600));

    await tester.tap(find.text('LOG HISTORY'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Attendance Logs'), findsOneWidget);

    // The back button pops the pushed route back to Home.
    await tester.tap(find.byTooltip('Back'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Attendance Logs'), findsNothing);
    expect(find.text('Ready to Start?'), findsOneWidget);
  });

  testWidgets('Expenses screen loads summary cards and expense list', (tester) async {
    await tester.pumpWidget(buildApp());

    // Navigate to the Expense tab.
    await tester.pump(const Duration(milliseconds: 600));
    await tester.tap(find.text('Expense'));
    await tester.pump();

    expect(find.text('Expenses'), findsOneWidget);

    // Let the static data sources finish.
    await tester.pump(const Duration(milliseconds: 600));

    // Summary card labels.
    expect(find.text('TO REPORT'), findsWidgets);
    expect(find.text('PENDING'), findsWidgets);
    expect(find.text('TOTAL PAID'), findsOneWidget);

    // Expense titles from the mock data.
    expect(find.text('Team lunch'), findsOneWidget);
    expect(find.text('Client taxi'), findsOneWidget);

    // The third card is below the fold; scroll the list to reveal it.
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pump();
    expect(find.text('Hotel – Cairo'), findsOneWidget);

    // Summary amounts.
    expect(find.text('\$45.00'), findsWidgets);
    expect(find.text('\$18.50'), findsWidgets);
    expect(find.text('\$120.00'), findsWidgets);

    // Section header count for the active My Expenses tab (3 records).
    expect(find.text('3 EXPENSES'), findsOneWidget);

    // Bottom navigation active item.
    expect(find.text('Expense'), findsWidgets);
  });

  testWidgets('Tapping an expense card opens its details screen', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pump(const Duration(milliseconds: 600));

    // Navigate to the Expense tab, then open the first expense.
    await tester.tap(find.text('Expense'));
    await tester.pump();
    await tester.tap(find.text('Team lunch'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Expense Details'), findsOneWidget);
    expect(find.text('La Trattoria, Downtown Cairo'), findsOneWidget);
    expect(find.text('Card'), findsOneWidget);
    expect(find.text('RCP-2026-0831'), findsOneWidget);
    expect(find.textContaining('weekly sync'), findsOneWidget);
  });

  testWidgets('Bottom navigation switches between destinations', (tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(buildApp());
    await tester.pump(const Duration(milliseconds: 600));

    // Home is the selected destination initially.
    expect(find.text('Ready to Start?'), findsOneWidget);

    await tester.tap(find.text('Expense'));
    await tester.pump();
    expect(find.text('Expenses'), findsOneWidget);
    expect(find.text('Team lunch'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pump();
    expect(find.text('Ready to Start?'), findsOneWidget);
  });

  testWidgets('Bottom navigation active visual state moves with the selection', (tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(buildApp());
    await tester.pump(const Duration(milliseconds: 600));

    BoxDecoration itemDecoration(String label) => tester.widget<Container>(
          find.ancestor(
            of: find.descendant(
              of: find.byType(AppBottomNavigation),
              matching: find.text(label),
            ),
            matching: find.byType(Container),
          ).first,
        ).decoration! as BoxDecoration;

    bool hasActiveBackground(String label) =>
        itemDecoration(label).color == AppColors.primaryContainer;

    bool hasShadow(String label) =>
        (itemDecoration(label).boxShadow ?? const []).isNotEmpty;

    // Home starts selected; every other item is plain with no shadow.
    expect(hasActiveBackground('Home'), isTrue);
    expect(hasShadow('Home'), isTrue);
    for (final label in ['Time Off', 'Payroll', 'Expense']) {
      expect(hasActiveBackground(label), isFalse);
      expect(hasShadow(label), isFalse);
    }

    // Home → Time Off → Payroll → Expense → Home. After each switch exactly
    // one item keeps the active background + shadow.
    const labels = ['Time Off', 'Payroll', 'Expense', 'Home'];
    for (var i = 0; i < labels.length; i++) {
      await tester.tap(find.text(labels[i]));
      await tester.pump(const Duration(milliseconds: 250));

      for (final label in labels) {
        if (label == labels[i]) {
          expect(hasActiveBackground(label), isTrue,
              reason: '$label should be the active item');
          expect(hasShadow(label), isTrue,
              reason: '$label should keep the active shadow');
        } else {
          expect(hasActiveBackground(label), isFalse,
              reason: '$label must not keep the active background');
          expect(hasShadow(label), isFalse,
              reason: '$label must not keep a shadow after switching');
        }
      }
    }
  });

  testWidgets('Drawer opens from the Expenses screen', (tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(buildApp());
    await tester.pump(const Duration(milliseconds: 600));

    // Go to the Expenses destination, then open its drawer via the menu button.
    await tester.tap(find.text('Expense'));
    await tester.pump();
    await tester.tap(find.byTooltip('Menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // The same application drawer is available and Expense is selected.
    expect(find.text('HitekNOFAL'), findsOneWidget);
    for (final label in ['Home', 'Time Off', 'Payroll', 'Expense', 'Attendance', 'Settings']) {
      expect(
        find.descendant(of: find.byType(Drawer), matching: find.text(label)),
        findsOneWidget,
      );
    }
    expect(drawerItemColor(tester, 'Expense'), AppColors.primaryContainer);
    expect(drawerItemColor(tester, 'Home'), Colors.transparent);

    // Selecting Home from this drawer navigates there and closes the drawer.
    await tester.tap(find.descendant(of: find.byType(Drawer), matching: find.text('Home')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(Drawer), findsNothing);
    expect(find.text('Ready to Start?'), findsOneWidget);
  });

  testWidgets('Attendance back button returns to the previous destination', (tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(buildApp());
    await tester.pump(const Duration(milliseconds: 600));

    // Expense → Attendance via the drawer, then Back returns to Expense.
    await tester.tap(find.text('Expense'));
    await tester.pump();
    await tester.tap(find.byTooltip('Menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.descendant(of: find.byType(Drawer), matching: find.text('Attendance')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Attendance Logs'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 600));

    await tester.tap(find.byTooltip('Back'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Back returns to the previous destination (Expense), not Home.
    expect(find.text('Attendance Logs'), findsNothing);
    expect(find.text('Expenses'), findsOneWidget);
    expect(navItemHasActiveBackground(tester, 'Expense'), isTrue);
  });
}
