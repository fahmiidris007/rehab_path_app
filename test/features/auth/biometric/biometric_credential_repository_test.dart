// Property-based tests for [BiometricCredentialRepositoryImpl].
//
// Property 6 (task 5.8 in `.kiro/specs/app-flow-adjustments/tasks.md`):
//   SecureStorage credential round-trip preserves the pair.
//
// **Validates: Requirements 4.4**
//
// Test strategy
// -------------
// `BiometricCredentialRepositoryImpl` depends on four collaborators:
//   * [LocalAuthentication]            — OS biometric prompt (NOT exercised
//                                        by this round-trip property).
//   * [FlutterSecureStorage]           — credential persistence.
//   * [SharedPreferencesDataSource]    — `biometric_enabled` flag (R4.4).
//   * [Logger]                         — pure side effect.
//
// `LocalAuthentication`, `SharedPreferencesDataSource`, and `Logger` are
// faked with `mocktail`. The secure-storage mock is **stateful**: it is
// backed by an in-memory `Map<String, String>` so that
// `write(key:, value:)`, `read(key:)`, and `delete(key:)` actually persist
// and remove keys. The property body relies on real round-trip behavior,
// not on canned `thenReturn` responses (per task 5.8 instructions).
//
// Glados drives variation across phone/password pairs. The phone alphabet
// is intentionally broad — any 1-30 character string — and the password
// alphabet is similarly unconstrained (1-50). The secure storage itself
// is dumb storage and SHALL NOT validate E.164 or password length.
//
// Import note: glados re-exports `package:test_core/scaffolding.dart`,
// which collides with `flutter_test`'s `setUpAll`/`group`/`test`/`expect`.
// We keep the `flutter_test` versions and hide the duplicates from glados.
// Mocktail's `any` also collides with glados's `any` extension receiver,
// so mocktail is imported under the `mt` prefix.

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glados/glados.dart'
    hide expect, group, test, setUpAll, setUp, tearDown, tearDownAll;
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart' as mt;
import 'package:laman_lansia/core/constants/pref_keys.dart';
import 'package:laman_lansia/core/errors/failures.dart';
import 'package:laman_lansia/features/auth/data/repositories/biometric_credential_repository_impl.dart';
import 'package:laman_lansia/shared/data/datasources/shared_preferences_data_source.dart';

// ── Mocks ────────────────────────────────────────────────────────────────────

class _MockLocalAuthentication extends mt.Mock implements LocalAuthentication {}

class _MockSecureStorage extends mt.Mock implements FlutterSecureStorage {}

class _MockPrefsDataSource extends mt.Mock
    implements SharedPreferencesDataSource {}

class _MockLogger extends mt.Mock implements Logger {}

// ── Fixture wiring ───────────────────────────────────────────────────────────

/// Wires up a fresh repository whose secure-storage mock is backed by the
/// supplied in-memory map. `write` writes to the map; `read` reads from it;
/// `delete` removes the key. The prefs mock also tracks `setBool` writes
/// in [prefsBools] so the test can assert `biometric_enabled` toggled.
({
  BiometricCredentialRepositoryImpl repo,
  Map<String, String> store,
  Map<String, bool> prefsBools,
}) _buildRepository() {
  final store = <String, String>{};
  final prefsBools = <String, bool>{};
  final localAuth = _MockLocalAuthentication();
  final secure = _MockSecureStorage();
  final prefs = _MockPrefsDataSource();
  final logger = _MockLogger();

  // Secure storage — Map-backed so writes/reads/deletes actually persist.
  mt
      .when(() => secure.write(
            key: mt.any(named: 'key'),
            value: mt.any(named: 'value'),
            iOptions: mt.any(named: 'iOptions'),
            aOptions: mt.any(named: 'aOptions'),
            lOptions: mt.any(named: 'lOptions'),
            webOptions: mt.any(named: 'webOptions'),
            mOptions: mt.any(named: 'mOptions'),
            wOptions: mt.any(named: 'wOptions'),
          ))
      .thenAnswer((invocation) async {
    final key = invocation.namedArguments[#key] as String;
    final value = invocation.namedArguments[#value] as String?;
    if (value == null) {
      store.remove(key);
    } else {
      store[key] = value;
    }
  });
  mt
      .when(() => secure.read(
            key: mt.any(named: 'key'),
            iOptions: mt.any(named: 'iOptions'),
            aOptions: mt.any(named: 'aOptions'),
            lOptions: mt.any(named: 'lOptions'),
            webOptions: mt.any(named: 'webOptions'),
            mOptions: mt.any(named: 'mOptions'),
            wOptions: mt.any(named: 'wOptions'),
          ))
      .thenAnswer((invocation) async {
    final key = invocation.namedArguments[#key] as String;
    return store[key];
  });
  mt
      .when(() => secure.delete(
            key: mt.any(named: 'key'),
            iOptions: mt.any(named: 'iOptions'),
            aOptions: mt.any(named: 'aOptions'),
            lOptions: mt.any(named: 'lOptions'),
            webOptions: mt.any(named: 'webOptions'),
            mOptions: mt.any(named: 'mOptions'),
            wOptions: mt.any(named: 'wOptions'),
          ))
      .thenAnswer((invocation) async {
    final key = invocation.namedArguments[#key] as String;
    store.remove(key);
  });

  // SharedPreferences — capture setBool writes for later assertions.
  mt
      .when(() => prefs.setBool(mt.any(), mt.any()))
      .thenAnswer((invocation) async {
    final key = invocation.positionalArguments[0] as String;
    final value = invocation.positionalArguments[1] as bool;
    prefsBools[key] = value;
  });
  mt.when(() => prefs.getBool(mt.any())).thenAnswer((invocation) {
    final key = invocation.positionalArguments[0] as String;
    return prefsBools[key];
  });

  // Logger — all-void methods, no stubs needed.

  return (
    repo: BiometricCredentialRepositoryImpl(localAuth, secure, prefs, logger),
    store: store,
    prefsBools: prefsBools,
  );
}

// ── Glados generators ────────────────────────────────────────────────────────

const _phoneChars =
    '+0123456789-() abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
const _passwordChars =
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .!@#\$%^&*+-=/';

typedef _PhoneAndPassword = ({String phone, String password});

extension _BiometricAnys on Any {
  /// Strings drawn from [alphabet] with length in `[min, max)`.
  Generator<String> stringOfRange(String alphabet, int min, int max) =>
      listWithLengthInRange(min, max, choose(alphabet.split('')))
          .map((chars) => chars.join());

  /// Arbitrary phone string, 1-30 characters. The repository SHALL persist
  /// whatever it is given — the secure-storage layer does not validate
  /// E.164 (R4.4: the storage is dumb).
  Generator<String> get arbitraryPhone => stringOfRange(_phoneChars, 1, 31);

  /// Arbitrary password string, 1-50 characters.
  Generator<String> get arbitraryPassword =>
      stringOfRange(_passwordChars, 1, 51);

  /// `(phone, password)` pair driving the round-trip property.
  Generator<_PhoneAndPassword> get phoneAndPassword => combine2(
        arbitraryPhone,
        arbitraryPassword,
        (String phone, String password) => (phone: phone, password: password),
      );
}

// ── Tests ────────────────────────────────────────────────────────────────────

void main() {
  // ───────────────────────────────────────────────────────────────────────────
  // Property 6 (task 5.8): SecureStorage credential round-trip preserves the
  // pair.
  // **Validates: Requirements 4.4**
  // ───────────────────────────────────────────────────────────────────────────
  group(
      'Property 6: SecureStorage credential round-trip preserves the pair',
      () {
    Glados<_PhoneAndPassword>(any.phoneAndPassword).test(
      'store → read returns the same (phone, password); clear → read returns '
      'Failure.cache(authBiometricSessionExpired); biometric_enabled toggles '
      'true on store and false on clear',
      (creds) async {
        final wired = _buildRepository();

        // 1. Build a fresh repository with empty backing map.
        expect(wired.store, isEmpty);
        expect(wired.prefsBools, isEmpty);

        // 2. storeCredentials returns Right(unit).
        final stored = await wired.repo.storeCredentials(
          phoneNumber: creds.phone,
          password: creds.password,
        );
        expect(
          stored,
          equals(const Right<Failure, Unit>(unit)),
          reason: 'storeCredentials must succeed for arbitrary input; got '
              '$stored for phone="${creds.phone}", password="${creds.password}"',
        );

        // R4.4 — both keys MUST be present in the backing map after store.
        expect(
          wired.store.containsKey('biometric_phone'),
          isTrue,
          reason: 'biometric_phone key must exist after storeCredentials',
        );
        expect(
          wired.store.containsKey('biometric_password'),
          isTrue,
          reason: 'biometric_password key must exist after storeCredentials',
        );

        // R4.4 — `biometric_enabled` flag flipped to true on store.
        expect(
          wired.prefsBools[PrefKeys.biometricEnabled],
          isTrue,
          reason: 'storeCredentials must set biometric_enabled=true; '
              'observed ${wired.prefsBools[PrefKeys.biometricEnabled]}',
        );

        // 3. readCredentials returns Right with the same pair.
        final read = await wired.repo.readCredentials();
        expect(
          read.isRight(),
          isTrue,
          reason: 'readCredentials must succeed after storeCredentials; '
              'got $read',
        );
        final record = read.getOrElse(
          () => throw StateError('unreachable'),
        );
        expect(
          record.phoneNumber,
          equals(creds.phone),
          reason: 'Round-trip must preserve phoneNumber exactly',
        );
        expect(
          record.password,
          equals(creds.password),
          reason: 'Round-trip must preserve password exactly',
        );

        // 4. clearCredentials returns Right(unit).
        final cleared = await wired.repo.clearCredentials();
        expect(
          cleared,
          equals(const Right<Failure, Unit>(unit)),
          reason: 'clearCredentials must succeed; got $cleared',
        );

        // R4.6 — both credential keys are gone after clear.
        expect(
          wired.store.containsKey('biometric_phone'),
          isFalse,
          reason: 'biometric_phone key must be removed after clearCredentials',
        );
        expect(
          wired.store.containsKey('biometric_password'),
          isFalse,
          reason:
              'biometric_password key must be removed after clearCredentials',
        );

        // R4.6 — `biometric_enabled` flag flipped to false on clear.
        expect(
          wired.prefsBools[PrefKeys.biometricEnabled],
          isFalse,
          reason: 'clearCredentials must set biometric_enabled=false; '
              'observed ${wired.prefsBools[PrefKeys.biometricEnabled]}',
        );

        // 5. readCredentials after clear returns Left(Failure.cache(
        //    message: 'authBiometricSessionExpired')) since both keys are
        //    now missing.
        final readAfterClear = await wired.repo.readCredentials();
        expect(
          readAfterClear.isLeft(),
          isTrue,
          reason: 'readCredentials after clearCredentials must fail; '
              'got $readAfterClear',
        );
        final failure = readAfterClear.fold(
          (f) => f,
          (_) => throw StateError('unreachable'),
        );
        expect(failure, isA<CacheFailure>());
        expect(
          (failure as CacheFailure).message,
          equals('authBiometricSessionExpired'),
          reason: 'Failure message must be the localized key '
              '"authBiometricSessionExpired"; got "${failure.message}"',
        );
      },
    );
  });
}
