import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_top_app_bar.dart';
import '../../../../core/widgets/zero_state_widget.dart';
import '../../../../di/injection.dart';
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../features/auth/presentation/cubit/auth_state.dart';
import '../cubit/sos_cubit.dart';
import '../cubit/sos_state.dart';
import '../widgets/emergency_contact_card.dart';

/// Emergency SOS page.
///
/// Provides [SosCubit] via [BlocProvider], loads the current user's emergency
/// contacts on init, and renders them in a [ListView] of [EmergencyContactCard]
/// widgets. A safety reminder is always visible above the list.
class SosPage extends StatelessWidget {
  const SosPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Resolve the current user ID from AuthCubit.
    final authState = context.read<AuthCubit>().state;
    final userId = switch (authState) {
      AuthAuthenticated(:final user) => user.id,
      _ => '',
    };

    return BlocProvider<SosCubit>(
      create: (_) => getIt<SosCubit>()..loadContacts(userId),
      child: const _SosView(),
    );
  }
}

class _SosView extends StatelessWidget {
  const _SosView();

  static const String _safetyReminder =
      'If you have fallen and cannot get up, remain calm and stay on the floor '
      'until help arrives. Call emergency services or a contact below.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopAppBar(title: 'Emergency SOS'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Safety reminder — always visible, never scrolled away
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.screenPaddingH,
              16,
              AppDimensions.screenPaddingH,
              16,
            ),
            child: Text(
              _safetyReminder,
              style: AppTextStyles.body.copyWith(
                fontSize: 18,
                color: AppColors.error,
              ),
            ),
          ),

          // Contact list / states
          Expanded(
            child: BlocBuilder<SosCubit, SosState>(
              builder: (context, state) {
                return switch (state) {
                  SosLoading() => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  SosError(:final message) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.screenPaddingH,
                      ),
                      child: AppErrorWidget(
                        message: message,
                        onRetry: () {
                          final authState =
                              context.read<AuthCubit>().state;
                          final userId = switch (authState) {
                            AuthAuthenticated(:final user) => user.id,
                            _ => '',
                          };
                          context.read<SosCubit>().loadContacts(userId);
                        },
                      ),
                    ),
                  SosCallNotSupported() => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.screenPaddingH,
                      ),
                      child: const AppErrorWidget(
                        message:
                            'Calling is not supported on this device.',
                      ),
                    ),
                  SosLoaded(:final contacts) when contacts.isEmpty =>
                    const ZeroStateWidget(
                      icon: Icon(
                        Icons.contacts_outlined,
                        color: AppColors.textDisabled,
                        size: 64,
                      ),
                      title: 'No emergency contacts',
                      subtitle:
                          'Add emergency contacts in your profile to use this feature.',
                    ),
                  SosLoaded(:final contacts) => ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.screenPaddingH,
                        vertical: 8,
                      ),
                      itemCount: contacts.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppDimensions.cardGap),
                      itemBuilder: (context, index) => EmergencyContactCard(
                        contact: contacts[index],
                      ),
                    ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
