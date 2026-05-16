import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/domain/entities/emergency_contact_entity.dart';
import '../cubit/sos_cubit.dart';
import 'add_edit_contact_bottom_sheet.dart';

/// A card displaying an emergency contact with shortcut buttons for
/// calling (dial) and WhatsApp, plus edit and delete actions.
class EmergencyContactCard extends StatelessWidget {
  const EmergencyContactCard({
    super.key,
    required this.contact,
    required this.index,
  });

  final EmergencyContactEntity contact;
  final int index;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.cardInnerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Contact info + action menu ──────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar circle
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    contact.name.isNotEmpty
                        ? contact.name[0].toUpperCase()
                        : '?',
                    style: AppTextStyles.bodySemiBold.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name + relationship
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: AppTextStyles.bodySemiBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      contact.relationship,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      contact.phoneNumber,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textDisabled,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              // Edit / Delete menu
              _ContactMenu(contact: contact, index: index),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 12),

          // ── Shortcut action buttons ─────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _ShortcutButton(
                  icon: Icons.phone_outlined,
                  label: l10n.sosCallButton,
                  color: AppColors.primary,
                  onTap: () =>
                      context.read<SosCubit>().callContact(contact.phoneNumber),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ShortcutButton(
                  icon: Icons.chat_outlined,
                  label: 'WhatsApp',
                  color: const Color(0xFF25D366), // WhatsApp green
                  onTap: () =>
                      context.read<SosCubit>().openWhatsApp(contact.phoneNumber),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Shortcut button ─────────────────────────────────────────────────────────

class _ShortcutButton extends StatelessWidget {
  const _ShortcutButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withAlpha(20),
      borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.bodySemiBold.copyWith(
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Edit / Delete popup menu ─────────────────────────────────────────────────

class _ContactMenu extends StatelessWidget {
  const _ContactMenu({required this.contact, required this.index});

  final EmergencyContactEntity contact;
  final int index;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<_MenuAction>(
      icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
      onSelected: (action) {
        switch (action) {
          case _MenuAction.edit:
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => BlocProvider.value(
                value: context.read<SosCubit>(),
                child: AddEditContactBottomSheet(
                  editIndex: index,
                  initial: contact,
                ),
              ),
            );
          case _MenuAction.delete:
            _confirmDelete(context, l10n);
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: _MenuAction.edit,
          child: Row(
            children: [
              const Icon(Icons.edit_outlined, size: 20),
              const SizedBox(width: 8),
              Text(l10n.sosEditContact),
            ],
          ),
        ),
        PopupMenuItem(
          value: _MenuAction.delete,
          child: Row(
            children: [
              const Icon(Icons.delete_outline,
                  size: 20, color: AppColors.error),
              const SizedBox(width: 8),
              Text(
                l10n.sosDeleteContact,
                style: const TextStyle(color: AppColors.error),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l10n.sosDeleteContactTitle),
        content: Text(l10n.sosDeleteContactMessage(contact.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              context.read<SosCubit>().deleteContact(index);
            },
            child: Text(
              l10n.sosDeleteContact,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

enum _MenuAction { edit, delete }
