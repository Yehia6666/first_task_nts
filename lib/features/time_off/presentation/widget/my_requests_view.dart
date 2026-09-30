import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/time_off_request.dart';
import '../../domain/usecases/filter_time_off_requests.dart';
import '../cubit/time_off_cubit.dart';
import '../states/time_off_state.dart';
import 'time_off_empty_state.dart';
import 'time_off_request_card.dart';
import 'time_off_search_field.dart';

class MyRequestsView extends StatefulWidget {
  const MyRequestsView({super.key});

  @override
  State<MyRequestsView> createState() => _MyRequestsViewState();
}

class _MyRequestsViewState extends State<MyRequestsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimeOffCubit(filterRequests: const FilterTimeOffRequests()),
      child: Builder(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TimeOffSearchField(
                controller: _searchController,
                onChanged: (query) =>
                    context.read<TimeOffCubit>().onSearchChanged(query),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(child: _buildContent(context)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return BlocBuilder<TimeOffCubit, TimeOffState>(
      builder: (context, state) {
        final requests = state is TimeOffRequestsLoaded
            ? state.requests
            : const <TimeOffRequest>[];
        if (requests.isEmpty) {
          return TimeOffEmptyState(
            icon: Icons.event_note_outlined,
            message: state is TimeOffRequestsLoaded &&
                    state.searchQuery.isNotEmpty
                ? 'No requests match your search.'
                : 'No time off requests found.',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
          itemCount: requests.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) => TimeOffRequestCard(
            request: requests[index],
          ),
        );
      },
    );
  }
}
