/// Utility for normalizing and validating phone numbers used by the
/// phone-first authentication flow.
///
/// The app stores phone numbers in normalized form so that values entered
/// with formatting variations (whitespace, hyphens, parentheses) compare
/// equal during lookup and persistence. Validation follows the E.164
/// recommendation: a leading `+` and 8-15 digits.
///
/// Both methods are pure and have no side effects, making them safe to
/// invoke from any layer (presentation, domain, data).
class PhoneNumberNormalizer {
  const PhoneNumberNormalizer._();

  /// Strips whitespace, hyphens, and parentheses from [raw], then converts
  /// Indonesian local-mobile format (`08...`) to its E.164 canonical form
  /// (`+628...`). An input that already starts with `+` passes through
  /// unchanged, so the function is idempotent:
  /// `normalize(normalize(x)) == normalize(x)` for every input.
  ///
  /// This means callers can store and compare phone numbers in their
  /// canonical `+62...` form regardless of whether the user typed
  /// `081234567890` or `+6281234567890`.
  static String normalize(String raw) {
    final stripped = raw.replaceAll(RegExp(r'[\s\-()]'), '');
    if (stripped.startsWith('08')) {
      return '+62${stripped.substring(1)}';
    }
    return stripped;
  }

  /// Returns `true` iff [raw] (after [normalize]) matches the canonical
  /// pattern `^\+\d{11,15}$`.
  ///
  /// The lower bound is tightened to 11 digits (vs. the E.164 minimum of
  /// 8) to express the product rule "phone number must be at least 10
  /// typed digits in `08…` form": `08` + 8 digits is the shortest legal
  /// input, which converts to `+628` + 8 digits = 11 digits after the
  /// `+`. Inputs typed directly in `+62…` form follow the same length
  /// envelope.
  static bool isValidE164(String raw) =>
      RegExp(r'^\+\d{11,15}$').hasMatch(normalize(raw));
}
