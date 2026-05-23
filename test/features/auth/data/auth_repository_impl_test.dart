// Property-based tests for [AuthRepositoryImpl].
//
// This file is the home for the registration and login properties of
// task wave 5 in `.kiro/specs/app-flow-adjustments/tasks.md`:
//
//   * Property 2 (task 3.4): Registration persists the normalized phone
//     and is retrievable by any equivalent input.
//     **Validates: Requirements 1.2, 1.4, 2.5**
//
//   * Property 3 (task 3.5): Login produces a uniform credential failure
//     for any non-matching credential.
//     **Validates: Requirements 1.5**
//
//   * Property 4 (task 3.6): Duplicate phone registration is always
//     rejected.
//     **Validates: Requirements 1.3**
//
// Test strategy
// -------------
// `AuthRepositoryImpl` depends on three collaborators:
//   * [HiveDataSource]                — user lookup and persistence.
//   * [SharedPreferencesDataSource]   — session token + flags.
//   * [Logger]                        — pure side-effect.
//
// Each is faked with `mocktail`. The Hive mock is backed by an in-memory
// `Map<String, UserHiveModel>` so that `saveUser` actually persists and
// `getUser` / `getAllUsers` reflect the stored state — the property tests
// rely on real round-trip behavior, not on canned `thenReturn` responses.
//
// Glados drives variation across phone formatting, names, and passwords
// with at least 100 iterations per property. For each tuple we build a
// fresh repository instance to keep each exploration hermetic.
//
// Import note: glados re-exports `package:test_core/scaffolding.dart`,
// which collides with `flutter_test`'s `setUpAll`/`group`/`test`/`expect`.
// We keep the `flutter_test` versions and hide the duplicates from glados.
// Mocktail's `any` also collides with glados's `any` extension receiver,
// so mocktail is imported under the `mt` prefix and accessed as
// `mt.any()`, `mt.when(...)`, etc.

import 'package:flutter_test/flutter_test.dart';
import 'package:glados/glados.dart'
    hide expect, group, test, setUpAll, setUp, tearDown, tearDownAll;
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart' as mt;
import 'package:rehab_path_app/core/errors/failures.dart';
import 'package:rehab_path_app/core/utils/phone_number_normalizer.dart';
import 'package:rehab_path_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:rehab_path_app/shared/data/datasources/hive_data_source.dart';
import 'package:rehab_path_app/shared/data/datasources/shared_preferences_data_source.dart';
import 'package:rehab_path_app/shared/data/models/user_hive_model.dart';

// ── Mocks ────────────────────────────────────────────────────────────────────

class _MockHiveDataSource extends mt.Mock implements HiveDataSource {}

class _MockPrefsDataSource extends mt.Mock
    implements SharedPreferencesDataSource {}

class _MockLogger extends mt.Mock implements Logger {}

// ── Fixture wiring ───────────────────────────────────────────────────────────

/// Wires up a fresh repository whose Hive datasource is backed by the
/// supplied in-memory map. `saveUser` writes to the map; `getUser` and
/// `getAllUsers` read from it. The prefs and logger mocks accept any call.
({
  AuthRepositoryImpl repo,
  Map<String, UserHiveModel> store,
}) _buildRepository({
  Map<String, UserHiveModel>? seed,
}) {
  final store = <String, UserHiveModel>{...?seed};
  final hive = _MockHiveDataSource();
  final prefs = _MockPrefsDataSource();
  final logger = _MockLogger();

  mt.when(() => hive.saveUser(mt.any())).thenAnswer((invocation) async {
    final user = invocation.positionalArguments.first as UserHiveModel;
    store[user.id] = user;
  });
  mt.when(() => hive.getUser(mt.any())).thenAnswer((invocation) {
    final id = invocation.positionalArguments.first as String;
    return store[id];
  });
  mt.when(hive.getAllUsers).thenAnswer((_) => store.values.toList());

  mt
      .when(() => prefs.setString(mt.any(), mt.any()))
      .thenAnswer((_) async {});
  mt.when(() => prefs.setBool(mt.any(), mt.any())).thenAnswer((_) async {});
  mt.when(() => prefs.remove(mt.any())).thenAnswer((_) async {});

  // Logger has all-void methods — no stubs needed.

  return (
    repo: AuthRepositoryImpl(hive, prefs, logger),
    store: store,
  );
}

// ── Glados generators ────────────────────────────────────────────────────────

const _digits = '0123456789';
const _nameChars =
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .';
const _passwordChars =
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .!@#\$%^&*';
const _separators = ' \t-()';

/// Splices a base-string with separator runs at every gap (start, between
/// each pair of base chars, end). The formatted result MUST normalize back
/// to [base].
String _spliceFormatting(String base, List<String> runs) {
  final buf = StringBuffer();
  for (var i = 0; i <= base.length; i++) {
    if (i < runs.length) buf.write(runs[i]);
    if (i < base.length) buf.write(base[i]);
  }
  return buf.toString();
}

/// Records used by the property bodies. Plain typedefs keep the Glados
/// shrinker output legible when failures are reported.
typedef _BaseWithTwoVariants = ({
  String base,
  String formatted1,
  String formatted2,
});

typedef _NamesAndPasswords = ({
  String name,
  String password1,
  String password2,
});

typedef _TwoNamesAndPasswords = ({
  String name1,
  String name2,
  String password1,
  String password2,
});

typedef _PhoneAndPassword = ({String phone, String password});

extension _AuthAnys on Any {
  /// Strings of digits with length in `[min, max)`.
  Generator<String> digitsOfLength(int min, int max) =>
      listWithLengthInRange(min, max, choose(_digits.split('')))
          .map((chars) => chars.join());

  /// Strings drawn from [alphabet] with length in `[min, max)`.
  Generator<String> stringOfRange(String alphabet, int min, int max) =>
      listWithLengthInRange(min, max, choose(alphabet.split('')))
          .map((chars) => chars.join());

  /// A single character that `PhoneNumberNormalizer.normalize` strips.
  Generator<String> get separator => choose(_separators.split(''));

  /// A bounded run of separator characters (0-4 inclusive). Bounded so the
  /// formatted variants do not grow without limit across iterations.
  Generator<String> get separatorRun =>
      listWithLengthInRange(0, 5, separator).map((p) => p.join());

  /// `'+' + 8-15 digits` — always a valid E.164 base.
  Generator<String> get validE164Base =>
      digitsOfLength(8, 16).map((d) => '+$d');

  /// `(base, formattedVariant1, formattedVariant2)`. `base` is a valid
  /// E.164 number; both variants normalize back to the same base.
  Generator<_BaseWithTwoVariants> get baseWithTwoVariants {
    return combine3(
      validE164Base,
      listWithLengthInRange(0, 20, separatorRun),
      listWithLengthInRange(0, 20, separatorRun),
      (String base, List<String> runs1, List<String> runs2) {
        return (
          base: base,
          formatted1: _spliceFormatting(base, runs1),
          formatted2: _spliceFormatting(base, runs2),
        );
      },
    );
  }

  /// `(name, password1, password2)` for the auth flows. Used by Property 2.
  Generator<_NamesAndPasswords> get namesAndPasswords {
    return combine3(
      stringOfRange(_nameChars, 1, 21),
      stringOfRange(_passwordChars, 1, 33),
      stringOfRange(_passwordChars, 1, 33),
      (String name, String p1, String p2) =>
          (name: name, password1: p1, password2: p2),
    );
  }

  /// `(name1, name2, password1, password2)` for Property 4.
  Generator<_TwoNamesAndPasswords> get twoNamesAndPasswords {
    return combine4(
      stringOfRange(_nameChars, 1, 21),
      stringOfRange(_nameChars, 1, 21),
      stringOfRange(_passwordChars, 1, 33),
      stringOfRange(_passwordChars, 1, 33),
      (String n1, String n2, String p1, String p2) =>
          (name1: n1, name2: n2, password1: p1, password2: p2),
    );
  }

  /// `(formattedPhone, password)` — a fully-formed valid login attempt.
  Generator<_PhoneAndPassword> get phoneAndPassword {
    return combine3(
      validE164Base,
      listWithLengthInRange(0, 20, separatorRun),
      stringOfRange(_passwordChars, 1, 33),
      (String base, List<String> runs, String password) =>
          (phone: _spliceFormatting(base, runs), password: password),
    );
  }
}

// ── Tests ────────────────────────────────────────────────────────────────────

void main() {
  setUpAll(() {
    // Mocktail fallback for non-nullable positional / named args used with
    // `mt.any()`. `saveUser` takes a `UserHiveModel`.
    mt.registerFallbackValue(
      UserHiveModel(
        id: '_fallback',
        name: '_fallback',
        email: '',
        age: 0,
        gender: '',
        programLevel: 'beginner',
        healthConditions: const [],
        emergencyContacts: const [],
        phoneNumber: '',
      ),
    );
  });

  // ───────────────────────────────────────────────────────────────────────────
  // Property 2 (task 3.4): Registration persists the normalized phone and is
  // retrievable by any equivalent input.
  // **Validates: Requirements 1.2, 1.4, 2.5**
  // ───────────────────────────────────────────────────────────────────────────
  group(
      'Property 2: Registration persists the normalized phone and is '
      'retrievable by any equivalent input', () {
    Glados2<_BaseWithTwoVariants, _NamesAndPasswords>(
      any.baseWithTwoVariants,
      any.namesAndPasswords,
    ).test(
      'register(formatted) then login(other formatted, any password) yields '
      'the same user with the normalized phone persisted',
      (phones, creds) async {
        final wired = _buildRepository();

        final registerResult = await wired.repo.register(
          name: creds.name,
          phoneNumber: phones.formatted1,
          password: creds.password1,
        );

        expect(
          registerResult.isRight(),
          isTrue,
          reason: 'Registering a fresh phone must succeed; got '
              '$registerResult for base=${phones.base}',
        );
        final registeredUser =
            registerResult.getOrElse(() => throw StateError('unreachable'));

        // Requirement 2.5 — the persisted form is the normalized E.164 base.
        expect(
          registeredUser.phoneNumber,
          equals(phones.base),
          reason: 'Expected the normalized form to be persisted; '
              'formatted input was "${phones.formatted1}"',
        );

        // Requirement 1.4 — login by ANY equivalent formatting variant of
        // the same base, with a possibly different password, returns the
        // same user.
        final loginResult = await wired.repo.login(
          phones.formatted2,
          creds.password2,
        );

        expect(
          loginResult.isRight(),
          isTrue,
          reason: 'Login with an equivalent formatting variant must '
              'succeed; got $loginResult for variant '
              '"${phones.formatted2}"',
        );
        final loggedInUser =
            loginResult.getOrElse(() => throw StateError('unreachable'));

        expect(loggedInUser.id, equals(registeredUser.id));
        expect(loggedInUser.phoneNumber, equals(phones.base));
      },
    );
  });

  // ───────────────────────────────────────────────────────────────────────────
  // Property 3 (task 3.5): Login produces a uniform credential failure for
  // any non-matching credential.
  // **Validates: Requirements 1.5**
  // ───────────────────────────────────────────────────────────────────────────
  group(
      'Property 3: Login produces a uniform credential failure for any '
      'non-matching credential', () {
    // 3a: a single user is registered with phoneA; any login attempt with
    // a phoneB that normalizes to a different base SHALL fail with the
    // uniform `Failure.cache(message: 'authInvalidCredentials')`.
    Glados2<_BaseWithTwoVariants, _PhoneAndPassword>(
      any.baseWithTwoVariants,
      any.phoneAndPassword,
    ).test(
      'login with a phone that normalizes differently than the seeded '
      "user's phone returns Failure.cache('authInvalidCredentials')",
      (seedPhones, attempt) async {
        // Skip iterations where the attempt happens to normalize to the
        // same base as the seeded phone — that would be a valid login,
        // not the case under test.
        final seededBase = seedPhones.base;
        final attemptedNormalized =
            PhoneNumberNormalizer.normalize(attempt.phone);
        if (attemptedNormalized == seededBase) return;

        final wired = _buildRepository();
        final registerResult = await wired.repo.register(
          name: 'seed_user',
          phoneNumber: seedPhones.formatted1,
          password: 'seed_password',
        );
        expect(registerResult.isRight(), isTrue);

        final loginResult =
            await wired.repo.login(attempt.phone, attempt.password);

        expect(loginResult.isLeft(), isTrue);
        final failure = loginResult.fold(
          (f) => f,
          (_) => throw StateError('unreachable'),
        );
        expect(failure, isA<CacheFailure>());
        expect(
          (failure as CacheFailure).message,
          equals('authInvalidCredentials'),
          reason: 'Non-matching credential failure must use the uniform '
              'message; got "${failure.message}" for attempt '
              '"${attempt.phone}" against seeded base "$seededBase"',
        );
      },
    );

    // 3b: with no users in Hive, ANY login attempt SHALL also produce the
    // uniform `Failure.cache(message: 'authInvalidCredentials')` — there
    // are no legacy records either, so the legacy banner SHALL NOT trigger.
    Glados<_PhoneAndPassword>(any.phoneAndPassword).test(
      'login against an empty Hive returns the same uniform failure',
      (attempt) async {
        final wired = _buildRepository();

        final loginResult =
            await wired.repo.login(attempt.phone, attempt.password);

        expect(loginResult.isLeft(), isTrue);
        final failure = loginResult.fold(
          (f) => f,
          (_) => throw StateError('unreachable'),
        );
        expect(failure, isA<CacheFailure>());
        expect(
          (failure as CacheFailure).message,
          equals('authInvalidCredentials'),
          reason: 'Empty-Hive login must yield the uniform '
              '`authInvalidCredentials` message; got "${failure.message}" '
              'for attempt "${attempt.phone}"',
        );
      },
    );
  });

  // ───────────────────────────────────────────────────────────────────────────
  // Property 4 (task 3.6): Duplicate phone registration is always rejected.
  // **Validates: Requirements 1.3**
  // ───────────────────────────────────────────────────────────────────────────
  group('Property 4: Duplicate phone registration is always rejected', () {
    Glados2<_BaseWithTwoVariants, _TwoNamesAndPasswords>(
      any.baseWithTwoVariants,
      any.twoNamesAndPasswords,
    ).test(
      'second register with any equivalent formatting of the same base is '
      'rejected with Failure.validation(field: phoneNumber, message: '
      'authPhoneAlreadyTaken) and no second user is persisted',
      (phones, creds) async {
        final wired = _buildRepository();

        final firstResult = await wired.repo.register(
          name: creds.name1,
          phoneNumber: phones.formatted1,
          password: creds.password1,
        );
        expect(
          firstResult.isRight(),
          isTrue,
          reason: 'First registration must succeed; got $firstResult',
        );

        final secondResult = await wired.repo.register(
          name: creds.name2,
          phoneNumber: phones.formatted2,
          password: creds.password2,
        );

        expect(
          secondResult.isLeft(),
          isTrue,
          reason: 'Second registration with the same normalized phone '
              'must fail; got $secondResult',
        );
        final failure = secondResult.fold(
          (f) => f,
          (_) => throw StateError('unreachable'),
        );
        expect(failure, isA<ValidationFailure>());
        final validation = failure as ValidationFailure;
        expect(validation.field, equals('phoneNumber'));
        expect(validation.message, equals('authPhoneAlreadyTaken'));

        // Requirement 1.3 — only the first user must be persisted.
        expect(
          wired.store.values.length,
          equals(1),
          reason: 'getAllUsers() size must remain 1 after duplicate '
              'registration; saw ${wired.store.values.length}',
        );
      },
    );
  });
}
