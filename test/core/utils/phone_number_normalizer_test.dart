// Property-based tests for [PhoneNumberNormalizer].
//
// **Validates: Requirements 1.6, 2.6**
//
// Property 1: Phone number normalization and validation is total and stable.
//
// The contract under test (see design.md, Glossary "No_HP"):
//   * `normalize(raw)` strips whitespace, hyphens, and parentheses; it does
//     NOT add a leading '+'.
//   * `isValidE164(raw)` returns true iff `normalize(raw)` matches
//     `^\+\d{8,15}$`.
//
// Each Glados test below runs at least 100 iterations (the default
// `ExploreConfig.numRuns`).

import 'package:glados/glados.dart';
import 'package:teman_lansia/core/utils/phone_number_normalizer.dart';

const _digits = '0123456789';
const _letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

// Characters that `normalize` SHALL strip.
const _separators = ' \t-()';

// A broad, deduplicated alphabet used by the "any string" properties.
// Includes digits, letters, separators, '+', and a few other symbols so
// totality / idempotence get exposed to the characters that actually matter.
const _arbitraryChars = '$_digits$_letters$_separators+.@_/';

extension _PhoneNumberAnys on Any {
  /// Strings drawn from [_arbitraryChars]. Length is unconstrained (may be
  /// empty). Exercises totality, idempotence, and stripping properties.
  Generator<String> get arbitraryPhoneInput => stringOf(_arbitraryChars);

  /// Strings of digits with length in `[min, max)`.
  Generator<String> digitsOfLength(int min, int max) =>
      listWithLengthInRange(min, max, choose(_digits.split('')))
          .map((chars) => chars.join());

  /// Valid base under the project's tightened rule: '+' followed by
  /// 11-15 digits. The minimum is 11 (not E.164's 8) because product
  /// requires at least 10 typed digits in `08…` form, which converts to
  /// `+628` + 8 digits = 11 digits.
  Generator<String> get validE164Base =>
      digitsOfLength(11, 16).map((d) => '+$d');

  /// A single character that `normalize` strips.
  Generator<String> get separator => choose(_separators.split(''));

  /// A possibly-empty run of separator characters.
  Generator<String> get separatorRun =>
      list(separator).map((parts) => parts.join());

  /// A valid E.164 base spliced with random separator runs at every position
  /// (start, between every pair of base chars, end). The formatted string
  /// MUST normalize back to the original base and remain valid.
  Generator<({String base, String formatted})> get e164WithFormatting {
    return combine2(
      validE164Base,
      list(separatorRun),
      (String base, List<String> runs) {
        final buf = StringBuffer();
        for (var i = 0; i <= base.length; i++) {
          if (i < runs.length) buf.write(runs[i]);
          if (i < base.length) buf.write(base[i]);
        }
        return (base: base, formatted: buf.toString());
      },
    );
  }

  /// '+' followed by 0-10 digits. Always invalid (too short under the
  /// tightened minimum of 11).
  Generator<String> get tooShortE164 =>
      digitsOfLength(0, 11).map((d) => '+$d');

  /// '+' followed by 16-30 digits. Always invalid (too long).
  Generator<String> get tooLongE164 =>
      digitsOfLength(16, 31).map((d) => '+$d');

  /// 8-30 digits with no leading '+', also rejecting any value that starts
  /// with `08` (which `normalize` now converts to a valid `+628...` form).
  /// Always invalid — the only reason for rejection is the missing/wrong
  /// country-code prefix.
  Generator<String> get missingPlusDigits => digitsOfLength(8, 31)
      .map((d) => d.startsWith('08') ? '9$d' : d);

  /// '+' followed by a string that contains at least one non-digit character
  /// that survives `normalize` (i.e. a letter or symbol that is not stripped).
  /// Always invalid.
  Generator<String> get plusWithNonDigit {
    return combine3(
      digitsOfLength(0, 8),
      choose(('$_letters.@_/').split('')),
      digitsOfLength(0, 8),
      (String pre, String letter, String post) => '+$pre$letter$post',
    );
  }
}

void main() {
  group('PhoneNumberNormalizer — Property 1: total and stable', () {
    // Idempotence: normalize(normalize(x)) == normalize(x).
    Glados(any.arbitraryPhoneInput).test(
      'normalize is idempotent',
      (input) {
        final once = PhoneNumberNormalizer.normalize(input);
        final twice = PhoneNumberNormalizer.normalize(once);
        expect(twice, equals(once));
      },
    );

    // Stripping: normalize(x) contains no whitespace, hyphens, or parens.
    Glados(any.arbitraryPhoneInput).test(
      'normalize strips all whitespace, hyphens, and parentheses',
      (input) {
        final normalized = PhoneNumberNormalizer.normalize(input);
        expect(RegExp(r'[\s\-()]').hasMatch(normalized), isFalse);
      },
    );

    // Totality: isValidE164 never throws and returns a pure bool.
    Glados(any.arbitraryPhoneInput).test(
      'isValidE164 is total — never throws, always returns a bool',
      (input) {
        final dynamic result = PhoneNumberNormalizer.isValidE164(input);
        expect(result, isA<bool>());
      },
    );

    // Stability under formatting: inserting whitespace, hyphens, or parens
    // between characters of a valid E.164 base preserves both the normalize
    // output and the validity result.
    Glados(any.e164WithFormatting).test(
      'formatting variations on a valid base yield the same normalized form',
      (sample) {
        expect(
          PhoneNumberNormalizer.normalize(sample.formatted),
          equals(sample.base),
        );
        expect(
          PhoneNumberNormalizer.isValidE164(sample.formatted),
          isTrue,
        );
      },
    );

    // Validity bounds — too short.
    Glados(any.tooShortE164).test(
      "'+' followed by 10-or-fewer digits is invalid",
      (input) {
        expect(PhoneNumberNormalizer.isValidE164(input), isFalse);
      },
    );

    // Validity bounds — too long.
    Glados(any.tooLongE164).test(
      "'+' followed by 16-or-more digits is invalid",
      (input) {
        expect(PhoneNumberNormalizer.isValidE164(input), isFalse);
      },
    );

    // Validity bounds — missing leading '+'.
    Glados(any.missingPlusDigits).test(
      'digits without a leading plus are invalid',
      (input) {
        expect(PhoneNumberNormalizer.isValidE164(input), isFalse);
      },
    );

    // Validity bounds — non-digits after '+'.
    Glados(any.plusWithNonDigit).test(
      "'+' followed by a string containing a non-digit character is invalid",
      (input) {
        expect(PhoneNumberNormalizer.isValidE164(input), isFalse);
      },
    );

    // Local Indonesian mobile format (`08...`) is converted to its E.164
    // canonical form (`+628...`) and is valid when the total typed length
    // is in `[10, 14]` digits — equivalently `08` + N digits where
    // N ∈ [8, 12]. Idempotence still holds: re-normalizing the result is
    // a no-op because the output starts with `+`.
    Glados(any.digitsOfLength(8, 13)).test(
      "'08' + 8-12 digits normalizes to '+628…' and is valid",
      (digits) {
        final input = '08$digits';
        final normalized = PhoneNumberNormalizer.normalize(input);
        expect(normalized, equals('+628$digits'));
        expect(PhoneNumberNormalizer.isValidE164(input), isTrue);
        // Idempotence on the converted form.
        expect(
          PhoneNumberNormalizer.normalize(normalized),
          equals(normalized),
        );
      },
    );
  });
}
