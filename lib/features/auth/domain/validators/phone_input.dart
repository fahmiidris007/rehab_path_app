import 'package:formz/formz.dart';

import '../../../../core/utils/phone_number_normalizer.dart';

/// Validation errors emitted by [PhoneNumberInput].
///
/// - [empty]: the user has not entered a phone number.
/// - [invalidFormat]: the value does not satisfy the E.164 format
///   (`+` followed by 8-15 digits, after normalization).
/// - [alreadyTaken]: the value is well-formed but a user with the same
///   normalized phone number already exists. This error is set
///   externally by the cubit (after a repository lookup) and is never
///   produced by [PhoneNumberInput.validator].
enum PhoneNumberValidationError { empty, invalidFormat, alreadyTaken }

/// Formz input for a phone number entered during register/login.
///
/// Format validation defers to [PhoneNumberNormalizer.isValidE164] so the
/// rules stay in lockstep with normalization used elsewhere in the auth
/// flow. The [PhoneNumberValidationError.alreadyTaken] state is purely
/// cubit-driven — it cannot be derived from the value alone.
class PhoneNumberInput extends FormzInput<String, PhoneNumberValidationError> {
  const PhoneNumberInput.pure() : super.pure('');
  const PhoneNumberInput.dirty([super.value = '']) : super.dirty();

  @override
  PhoneNumberValidationError? validator(String value) {
    if (value.isEmpty) return PhoneNumberValidationError.empty;
    if (!PhoneNumberNormalizer.isValidE164(value)) {
      return PhoneNumberValidationError.invalidFormat;
    }
    return null;
  }
}
