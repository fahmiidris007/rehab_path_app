import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/domain/entities/emergency_contact_entity.dart';
import '../cubit/sos_cubit.dart';

/// Bottom sheet for adding or editing an emergency contact.
///
/// Pass [editIndex] and [initial] to pre-fill the form for editing.
class AddEditContactBottomSheet extends StatefulWidget {
  const AddEditContactBottomSheet({
    super.key,
    this.editIndex,
    this.initial,
  });

  /// Index in the contacts list when editing; null when adding.
  final int? editIndex;

  /// Pre-filled contact data when editing.
  final EmergencyContactEntity? initial;

  @override
  State<AddEditContactBottomSheet> createState() =>
      _AddEditContactBottomSheetState();
}

class _AddEditContactBottomSheetState
    extends State<AddEditContactBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _relationCtrl;
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    _relationCtrl =
        TextEditingController(text: widget.initial?.relationship ?? '');
    _phoneCtrl =
        TextEditingController(text: widget.initial?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _relationCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final contact = EmergencyContactEntity(
      name: _nameCtrl.text.trim(),
      relationship: _relationCtrl.text.trim(),
      phoneNumber: _phoneCtrl.text.trim(),
    );

    final cubit = context.read<SosCubit>();
    if (widget.editIndex != null) {
      cubit.updateContact(widget.editIndex!, contact);
    } else {
      cubit.addContact(contact);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.editIndex != null;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusCard * 2),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.screenPaddingH,
              20,
              AppDimensions.screenPaddingH,
              24,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    isEditing
                        ? l10n.sosEditContactTitle
                        : l10n.sosAddContactTitle,
                    style: AppTextStyles.h3Section.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Name field
                  _ContactTextField(
                    controller: _nameCtrl,
                    label: l10n.sosContactName,
                    hint: l10n.sosContactNameHint,
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l10n.sosContactNameRequired
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Relationship field
                  _ContactTextField(
                    controller: _relationCtrl,
                    label: l10n.sosContactRelationship,
                    hint: l10n.sosContactRelationshipHint,
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l10n.sosContactRelationshipRequired
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Phone field
                  _ContactTextField(
                    controller: _phoneCtrl,
                    label: l10n.sosContactPhone,
                    hint: l10n.sosContactPhoneHint,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9+\-\s()]'),
                      ),
                    ],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return l10n.sosContactPhoneRequired;
                      }
                      final digits = v.replaceAll(RegExp(r'\D'), '');
                      if (digits.length < 7) {
                        return l10n.sosContactPhoneInvalid;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: AppDimensions.primaryButtonH,
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: Text(l10n.sosSaveContact),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactTextField extends StatelessWidget {
  const _ContactTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          validator: validator,
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
