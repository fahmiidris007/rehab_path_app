// Widget tests for [LoginPage] phone form structure.
//
// Task 4.5 (`.kiro/specs/app-flow-adjustments/tasks.md`):
//
//   * Phone field is present with `keyboardType: TextInputType.phone` and the
//     hint matches `l10n.authPhoneHint`.
//   * Biometric icon is present with `Semantics(label:
//     l10n.authBiometricSemanticLabel)` AND its rendered tap target measures
//     ≥ 56×56 dp.
//   * When the cubit emits [AuthLegacyAccountNeedsPhone], the legacy banner /
//     SnackBar with `l10n.authLegacyAccountNeedsPhone` text appears.
//
// **Validates: Requirements 1.8, 3.1, 13.3, 13.6, 14.2.**
//
// Test strategy
// -------------
// `LoginPage` reads its [AuthCubit] from a `BlocProvider<AuthCubit>.value` we
// supply directly; the cubit is faked with `bloc_test`'s [MockCubit] so we
// never touch DI / Hive / `local_auth`. `LoginPage.initState` subscribes to
// `AuthCubit.autofillStream`, so the mock must expose a real (empty)
// broadcast `Stream` rather than `null`.
//
// Localizations are real — we plug in `AppLocalizations.delegate` plus the
// global delegates so `AppLocalizations.of(context)!` resolves on the first
// frame.

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teman_lansia/app/cubit/app_cubit.dart';
import 'package:teman_lansia/di/injection.dart';
import 'package:teman_lansia/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:teman_lansia/features/auth/presentation/cubit/auth_state.dart';
import 'package:teman_lansia/features/auth/presentation/pages/login_page.dart';
import 'package:teman_lansia/l10n/app_localizations.dart';
import 'package:teman_lansia/shared/data/datasources/shared_preferences_data_source.dart';
import 'package:teman_lansia/shared/domain/entities/user_entity.dart';
import 'package:teman_lansia/shared/domain/enums/app_enums.dart';

class _MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

class _FakePrefsDataSource extends Mock implements SharedPreferencesDataSource {}

/// English [AppLocalizations] resolved once and reused across every test.
late AppLocalizations _enL10n;

/// Wraps [LoginPage] in a `MaterialApp` whose root provides the supplied
/// [cubit] via `BlocProvider<AuthCubit>.value` and supplies all the
/// localization delegates `LoginPage` needs.
///
/// `LoginPage`'s AppBar embeds a `LanguageSelectorButton` that watches an
/// `AppCubit`; we provide a real one (its constructor has no required
/// dependencies) so the page can mount without a `ProviderNotFoundException`.
Widget _harness(AuthCubit cubit) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<AppCubit>(create: (_) => AppCubit()),
      BlocProvider<AuthCubit>.value(value: cubit),
    ],
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('id')],
      // Force English so the test asserts against the English ARB strings
      // independently of the user's persisted locale (default is `id`).
      locale: const Locale('en'),
      home: const LoginPage(),
    ),
  );
}

UserEntity _legacyUserFixture() => const UserEntity(
      id: 'legacy-1',
      name: 'Legacy User',
      phoneNumber: '',
      age: 70,
      gender: 'female',
      programLevel: ProgramLevel.beginner,
      healthConditions: [],
      emergencyContacts: [],
      email: 'legacy@example.com',
    );

void main() {
  setUpAll(() async {
    _enL10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  setUp(() {
    // `LoginPage` resolves [SharedPreferencesDataSource] from `getIt` to
    // read/write the legacy-account warning flag. Register a `mocktail` fake
    // that returns `false` (no prior warning) and accepts any setBool calls
    // so the banner path is exercised.
    final prefs = _FakePrefsDataSource();
    when(() => prefs.getBool(any())).thenReturn(false);
    when(() => prefs.setBool(any(), any())).thenAnswer((_) async {});

    if (getIt.isRegistered<SharedPreferencesDataSource>()) {
      getIt.unregister<SharedPreferencesDataSource>();
    }
    getIt.registerSingleton<SharedPreferencesDataSource>(prefs);
  });

  tearDown(() {
    if (getIt.isRegistered<SharedPreferencesDataSource>()) {
      getIt.unregister<SharedPreferencesDataSource>();
    }
  });

  Future<_MockAuthCubit> buildIdleCubit({
    Stream<({String phoneNumber, String password})>? autofillStream,
  }) async {
    final cubit = _MockAuthCubit();
    when(() => cubit.state).thenReturn(const AuthState.initial());
    when(() => cubit.stream)
        .thenAnswer((_) => const Stream<AuthState>.empty());
    when(() => cubit.autofillStream).thenAnswer(
      (_) => autofillStream ?? const Stream<({String phoneNumber, String password})>.empty(),
    );
    return cubit;
  }

  group('LoginPage phone form structure', () {
    testWidgets(
      'renders the phone field with TextInputType.phone and the localized '
      'hint (Requirements 1.8)',
      (tester) async {
        final cubit = await buildIdleCubit();
        await tester.pumpWidget(_harness(cubit));
        await tester.pumpAndSettle();

        // The login page has two TextFormFields: phone, then password.
        final phoneFinder = find.byType(TextFormField).first;
        expect(phoneFinder, findsOneWidget);

        // `TextFormField` does not expose `keyboardType` directly — it forwards
        // it to its inner `TextField`. Inspect that descendant instead.
        final TextField innerPhoneField = tester.widget<TextField>(
          find.descendant(
            of: phoneFinder,
            matching: find.byType(TextField),
          ),
        );
        expect(
          innerPhoneField.keyboardType,
          TextInputType.phone,
          reason: 'Phone field MUST use TextInputType.phone (R1.8).',
        );

        // Read the resolved decoration as it actually rendered via the
        // descendant `InputDecorator`.
        final inputDecorator = tester.widget<InputDecorator>(
          find.descendant(
            of: phoneFinder,
            matching: find.byType(InputDecorator),
          ),
        );
        expect(
          inputDecorator.decoration.hintText,
          _enL10n.authPhoneHint,
          reason: 'Phone field hint MUST be the localized authPhoneHint '
              '(R1.8).',
        );
      },
    );

    testWidgets(
      'renders the biometric icon with the localized semantic label and a '
      'tap target ≥ 56×56 dp (Requirements 3.1, 13.3, 13.6)',
      (tester) async {
        final cubit = await buildIdleCubit();
        await tester.pumpWidget(_harness(cubit));
        await tester.pumpAndSettle();

        final fingerprintIcon = find.byIcon(Icons.fingerprint);
        expect(
          fingerprintIcon,
          findsOneWidget,
          reason: 'A biometric icon MUST be visible on the login page '
              '(R3.1).',
        );

        // Find the Semantics wrapper that owns the localized label. Use
        // `find.ancestor` so we also assert the icon is inside it rather
        // than alongside it.
        final semanticsAncestor = find.ancestor(
          of: fingerprintIcon,
          matching: find.byWidgetPredicate(
            (w) =>
                w is Semantics &&
                w.properties.label == _enL10n.authBiometricSemanticLabel,
          ),
        );
        expect(
          semanticsAncestor,
          findsOneWidget,
          reason: 'Biometric icon MUST be wrapped in a Semantics with the '
              'localized authBiometricSemanticLabel (R13.6).',
        );

        // The page wraps the IconButton in a `SizedBox(width: 56, height:
        // 56)` to enforce the ≥ 56 dp tap target. Measure that ancestor.
        final sizedBoxAncestor = find
            .ancestor(
              of: fingerprintIcon,
              matching: find.byType(SizedBox),
            )
            .first;
        final size = tester.getSize(sizedBoxAncestor);
        expect(
          size.width,
          greaterThanOrEqualTo(56.0),
          reason: 'Biometric tap target width MUST be ≥ 56 dp (R3.1, R13.3); '
              'measured ${size.width}.',
        );
        expect(
          size.height,
          greaterThanOrEqualTo(56.0),
          reason: 'Biometric tap target height MUST be ≥ 56 dp (R3.1, R13.3); '
              'measured ${size.height}.',
        );
      },
    );

    testWidgets(
      'shows the inline legacy-account banner with the localized copy and '
      'CTA when AuthLegacyAccountNeedsPhone is emitted (Requirements 14.2)',
      (tester) async {
        // Stream the legacy state via `whenListen`. The initial state stays
        // `AuthInitial` so the page renders normally before the listener
        // fires.
        final cubit = _MockAuthCubit();
        when(() => cubit.autofillStream).thenAnswer(
          (_) =>
              const Stream<({String phoneNumber, String password})>.empty(),
        );
        whenListen(
          cubit,
          Stream<AuthState>.fromIterable([
            AuthState.legacyAccountNeedsPhone(_legacyUserFixture()),
          ]),
          initialState: const AuthState.initial(),
        );

        await tester.pumpWidget(_harness(cubit));
        // First frame builds the page; the listener fires on the next pump.
        await tester.pump();
        // Allow setState to flush so the banner is in the tree.
        await tester.pump(const Duration(milliseconds: 100));

        expect(
          find.text(_enL10n.authLegacyAccountNeedsPhone),
          findsOneWidget,
          reason: 'The legacy banner copy MUST be the localized '
              'authLegacyAccountNeedsPhone string (R14.2).',
        );
        expect(
          find.text(_enL10n.authLegacyAccountAddPhoneCta),
          findsOneWidget,
          reason: 'The legacy banner MUST surface a CTA to add a phone '
              'number (R14.2).',
        );
      },
    );
  });
}
