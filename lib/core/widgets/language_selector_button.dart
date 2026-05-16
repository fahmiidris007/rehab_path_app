import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/cubit/app_cubit.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/domain/enums/app_enums.dart';

/// A popup menu button that lets the user switch between English and Indonesian.
///
/// Reads and writes locale via [AppCubit]. Designed to be placed in an
/// [AppBar.actions] list or anywhere in the widget tree.
class LanguageSelectorButton extends StatelessWidget {
  const LanguageSelectorButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = context.watch<AppCubit>().state.locale;

    return PopupMenuButton<AppLocale>(
      tooltip: l10n.selectLanguage,
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.language, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            currentLocale == AppLocale.id ? 'ID' : 'EN',
            style: AppTextStyles.bodySemiBold.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      onSelected: (locale) {
        context.read<AppCubit>().changeLocale(locale);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: AppLocale.en,
          child: Row(
            children: [
              if (currentLocale == AppLocale.en)
                const Icon(Icons.check, size: 18, color: AppColors.primary)
              else
                const SizedBox(width: 18),
              const SizedBox(width: 8),
              Text(l10n.settingsLanguageEn),
            ],
          ),
        ),
        PopupMenuItem(
          value: AppLocale.id,
          child: Row(
            children: [
              if (currentLocale == AppLocale.id)
                const Icon(Icons.check, size: 18, color: AppColors.primary)
              else
                const SizedBox(width: 18),
              const SizedBox(width: 8),
              Text(l10n.settingsLanguageId),
            ],
          ),
        ),
      ],
    );
  }
}
