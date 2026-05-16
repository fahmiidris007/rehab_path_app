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
import '../../../../l10n/app_localizations.dart';
import '../cubit/sos_cubit.dart';
import '../cubit/sos_state.dart';
import '../widgets/emergency_contact_card.dart';

/// Emergency SOS page.
class SosPage extends StatelessWidget {
  const SosPage({super.key});

  @override
  Widget build(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopAppBar(title: l10n.sosTitle),
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
              l10n.sosSafetyReminderFull,
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
                      child: AppErrorWidget(
                        message: l10n.sosCallingNotSupported,
                      ),
                    ),
                  SosLoaded(:final contacts) when contacts.isEmpty =>
                    ZeroStateWidget(
                      icon: const Icon(
                        Icons.contacts_outlined,
                        color: AppColors.textDisabled,
                        size: 64,
                      ),
                      title: l10n.sosNoEmergencyContacts,
                      subtitle: l10n.sosAddContactsMessage,
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

/// Emergency SOS page.
///
/// Provides [SosCubit] via [BlocProvider], loads the current user's emergency
/// contacts on init, and renders them in a [ListView] of [EmergencyContactCard]
/// widgets. A safety reminder is always visible above the list.
