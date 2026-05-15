import 'package:formz/formz.dart';

enum NameValidationError { invalid }

class NameInput extends FormzInput<String, NameValidationError> {
  const NameInput.pure() : super.pure('');
  const NameInput.dirty([super.value = '']) : super.dirty();

  @override
  NameValidationError? validator(String value) {
    // Valid if length is between 1 and 50 characters (inclusive)
    if (value.isEmpty || value.length > 50) {
      return NameValidationError.invalid;
    }
    return null;
  }
}
