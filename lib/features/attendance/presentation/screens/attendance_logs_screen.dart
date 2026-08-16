import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../domain/entities/attendance_filters.dart';
import '../cubit/attendance_cubit.dart';
import '../states/attendance_state.dart';
import '../widgets/attendance_filter_row.dart';
import '../widgets/attendance_filter_sheet.dart';
import '../widgets/attendance_header.dart';
import '../widgets/attendance_search_field.dart';
import '../widgets/attendance_section.dart';

/// Mobile-first Attendance Logs screen. Header, search, filters and a scrollable
/// list of day sections, all driven by [AttendanceCubit].
class AttendanceLogsScreen extends StatefulWidget {
  const AttendanceLogsScreen({super.key});

  @override
  State<AttendanceLogsScreen> createState() => _AttendanceLogsScreenState();
}

class _AttendanceLogsScreenState extends State<AttendanceLogsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterSheet(BuildContext context, AttendanceCubit cubit, AttendanceStatusFilter current) {
    showAttendanceFilterSheet(
      context,
      selectedStatus: current,
      onStatusSelected: (status) {
        cubit.onStatusFilterChanged(status);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.sm),
                  child: AttendanceHeader(),
                ),
                const SizedBox(height: AppSpacing.xl),
                BlocBuilder<AttendanceCubit, AttendanceState>(
                  buildWhen: (previous, current) =>
                      previous is AttendanceLoaded &&
                      current is AttendanceLoaded &&
                      previous.searchQuery != current.searchQuery,
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.pagePadding(context),
                      ),
                      child: AttendanceSearchField(
                        controller: _searchController,
                        onChanged: (query) =>
                            context.read<AttendanceCubit>().onSearchChanged(query),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                BlocBuilder<AttendanceCubit, AttendanceState>(
                  buildWhen: (previous, current) =>
                      previous is AttendanceLoaded &&
                      current is AttendanceLoaded &&
                      previous.typeFilter != current.typeFilter,
                  builder: (context, state) {
                    final typeFilter = state is AttendanceLoaded
                        ? state.typeFilter
                        : AttendanceTypeFilter.all;
                    return AttendanceFilterRow(
                      selectedType: typeFilter,
                      onTypeSelected: (filter) =>
                          context.read<AttendanceCubit>().onTypeFilterChanged(filter),
                      onFilterTap: () {
                        final currentStatus = state is AttendanceLoaded
                            ? state.statusFilter
                            : AttendanceStatusFilter.all;
                        _openFilterSheet(context, context.read<AttendanceCubit>(), currentStatus);
                      },
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      builder: (context, state) {
        return switch (state) {
          AttendanceInitial() || AttendanceLoading() => const AppLoadingState(
              message: 'Loading attendance logs…',
            ),
          AttendanceError() => AppErrorState(
              message: state.message,
              onRetry: () => context.read<AttendanceCubit>().load(),
            ),
          AttendanceLoaded() => state.sections.isEmpty
              ? const AppEmptyState(
                  icon: Icons.history_rounded,
                  title: 'No attendance records found',
                  message: 'Try adjusting your search or filters.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                  itemCount: state.sections.length,
                  itemBuilder: (context, index) =>
                      AttendanceSection(section: state.sections[index]),
                ),
        };
      },
    );
  }
}
