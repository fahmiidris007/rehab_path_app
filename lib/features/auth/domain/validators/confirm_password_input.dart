import 'package:formz/formz.dart';

enum ConfirmPasswordValidationError { mismatch }

class ConfirmPasswordInput
    extends FormzInput<String, ConfirmPasswordValidationError> {
  final String password;

  const ConfirmPasswordInput.pure({this.password = ''}) : super.pure('');
  const ConfirmPasswordInput.dirty({required this.password, String value = ''})
      : super.dirty(value);

  @override
  ConfirmPasswordValidationError? validator(String value) {
    return value == password ? null : ConfirmPasswordValidationError.mismatch;
  }
}
