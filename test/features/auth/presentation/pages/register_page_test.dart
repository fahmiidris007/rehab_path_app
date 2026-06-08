// Widget tests for [RegisterPage] phone form structure.
//
// Task 4.5 (`.kiro/specs/app-flow-adjustments/tasks.md`):
//
//   * Phone field is present with phone keyboard and the localized hint.
//   * Inline error reflects duplicate phone state when
//     `AuthError(message: 'authPhoneAlreadyTaken')` is emitted: the field's
//     error text is `l10n.authPhoneAlreadyTaken`.
//
// **Validates: Requirements 1.8, 3.1, 13.3, 13.6, 14.2.**
//
// Test strategy
// -------------
// The cubit is faked with `bloc_test`'s [MockCubit] so the DI graph is not
// touched. RegisterPage does not subscribe to `autofillStream`, but mocking
// the cubit consistently keeps the harness identical between the login and
// register tests. State changes are streamed via `whenListen` so we can
// observe the inline error rendered in response to `AuthError`.

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teman_lansia/app/cubit/app_cubit.dart';
import 'package:teman_lansia/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:teman_lansia/features/auth/presentation/cubit/auth_state.dart';
import 'package:teman_lansia/features/auth/presentation/pages/register_page.dart';
import 'package:teman_lansia/l10n/app_localizations.dart';

class _MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

late AppLocalizations _enL10n;

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
      // regardless of any persisted locale.
      locale: const Locale('en'),
      home: const RegisterPage(),
    ),
  );
}

/// Resolves the [TextFormField] used for the phone field. RegisterPage has
/// four fields in DOM order: name, phone, password, confirm-password.
Finder _phoneFieldFinder() => find.byType(TextFormField).at(1);

void main() {
  setUpAll(() async {
    _enL10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group('RegisterPage phone form structure', () {
    testWidgets(
      'renders the phone field with TextInputType.phone and the localized '
      'hint (Requirements 1.8)',
      (tester) async {
        final cubit = _MockAuthCubit();
        when(() => cubit.state).thenReturn(const AuthState.initial());
        when(() => cubit.stream)
            .thenAnswer((_) => const Stream<AuthState>.empty());

        await tester.pumpWidget(_harness(cubit));
        await tester.pumpAndSettle();

        final phoneFinder = _phoneFieldFinder();
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
      "surfaces the localized duplicate-phone message inline on the phone "
      "field when AuthError('authPhoneAlreadyTaken') is emitted "
      '(Requirements 1.8, 14.2)',
      (tester) async {
        final cubit = _MockAuthCubit();
        // Stream a duplicate-phone error after the initial state.
        whenListen(
          cubit,
          Stream<AuthState>.fromIterable(
            const [AuthState.error('authPhoneAlreadyTaken')],
          ),
          initialState: const AuthState.initial(),
        );

        await tester.pumpWidget(_harness(cubit));
        // Pump once to deliver the streamed state to the BlocListener, then
        // again to flush the resulting `setState`.
        await tester.pump();
        await tester.pump();

        // Inline error: the InputDecorator under the phone field SHALL
        // expose the localized authPhoneAlreadyTaken string as `errorText`.
        final inputDecorator = tester.widget<InputDecorator>(
          find.descendant(
            of: _phoneFieldFinder(),
            matching: find.byType(InputDecorator),
          ),
        );
        expect(
          inputDecorator.decoration.errorText,
          _enL10n.authPhoneAlreadyTaken,
          reason: 'Phone field MUST surface authPhoneAlreadyTaken inline on '
              'duplicate-phone errors (R1.8, R14.2).',
        );

        // The same string MUST be visible in the rendered tree. Use the
        // localized string lookup so the test stays in sync with the ARB
        // contents.
        expect(
          find.text(_enL10n.authPhoneAlreadyTaken),
          findsOneWidget,
          reason: 'The localized authPhoneAlreadyTaken copy MUST render '
              'exactly once below the phone field (R14.2).',
        );
      },
    );
  });
}
