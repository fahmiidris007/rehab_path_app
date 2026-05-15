import 'package:formz/formz.dart';

enum PasswordValidationError { invalid }

class PasswordInput extends FormzInput<String, PasswordValidationError> {
  const PasswordInput.pure() : super.pure('');
  const PasswordInput.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    // Valid if length is between 8 and 64 characters (inclusive)
    if (value.length < 8 || value.length > 64) {
      return PasswordValidationError.invalid;
    }
    return null;
  }
}
