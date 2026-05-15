import 'package:formz/formz.dart';

enum EmailValidationError { invalid }

class EmailInput extends FormzInput<String, EmailValidationError> {
  const EmailInput.pure() : super.pure('');
  const EmailInput.dirty([super.value = '']) : super.dirty();

  @override
  EmailValidationError? validator(String value) {
    // Valid if: non-empty local part + '@' + non-empty domain
    final parts = value.split('@');
    if (parts.length != 2) return EmailValidationError.invalid;
    if (parts[0].isEmpty || parts[1].isEmpty) return EmailValidationError.invalid;
    return null;
  }
}
