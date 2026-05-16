import 'package:formz/formz.dart';

enum PasswordValidationError { invalid }

class PasswordInput extends FormzInput<String, PasswordValidationError> {
  const PasswordInput.pure() : super.pure('');
  const PasswordInput.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    // Valid if length is at least 8 characters
    if (value.length < 8) {
      return PasswordValidationError.invalid;
    }
    return null;
  }
}
