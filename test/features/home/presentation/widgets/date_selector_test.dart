// Widget tests for [DateSelector].
//
// Task 11.3 (`.kiro/specs/app-flow-adjustments/tasks.md`):
//
//   * 7 cells rendered, each ≥ 48 × 48 dp.
//   * Tapping a cell dispatches `onDateSelected` with the correct
//     [DateTime].
//   * Each cell exposes a non-empty [Semantics] label.
//   * Prev / Next chevrons expose localized [Semantics] labels matching
//     `l10n.dashboardDateSelectorPrev` / `next`.
//
// **Validates: Requirements 9.1, 13.3, 13.6.**
//
// Test strategy
// -------------
// `DateSelector` is purely presentational, so we pump it directly inside a
// `MaterialApp` that wires up `AppLocalizations.delegate` plus the global
// localization delegates. The locale is forced to English so label
// assertions match the English ARB strings independently of the device
// default.
//
// Day cells are located via the per-cell `Semantics` widget (the only
// `Semantics` nodes in the subtree whose `properties.selected` is non-null).
// This keeps the finder robust against layout changes that introduce
// additional `InkWell`s — for instance, the chevron `IconButton`s each
// render an `InkResponse`/`InkWell` that would otherwise inflate a naive
// `find.byType(InkWell)` count to nine.
//
// `weekStart` is `DateTime(2024, 1, 1)` — a Monday — so the seven generated
// cells map cleanly onto Mon..Sun within the same month and the dates are
// stable across test runs.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teman_lansia/features/home/presentation/widgets/date_selector.dart';
import 'package:teman_lansia/l10n/app_localizations.dart';

/// Wraps [DateSelector] in the minimum harness it needs:
/// `AppLocalizations` delegates, English locale, and a [Scaffold] body so
/// the layout has a finite, well-defined width for `getSize`.
Widget _harness({
  required DateTime weekStart,
  required DateTime todayLocal,
  required DateTime selectedDate,
  required ValueChanged<DateTime> onDateSelected,
  VoidCallback? onPrevWeek,
  VoidCallback? onNextWeek,
}) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('id')],
    locale: const Locale('en'),
    home: Scaffold(
      body: DateSelector(
        weekStart: weekStart,
        todayLocal: todayLocal,
        selectedDate: selectedDate,
        onDateSelected: onDateSelected,
        onPrevWeek: onPrevWeek ?? () {},
        onNextWeek: onNextWeek ?? () {},
      ),
    ),
  );
}

/// Finds the seven day-cell [Semantics] nodes in the [DateSelector]
/// subtree. They are uniquely identifiable because they are the only
/// [Semantics] widgets in the subtree whose `properties.selected` is set
/// (the chevron buttons set `button: true` but leave `selected` null).
Finder _dayCellSemantics() {
  return find.descendant(
    of: find.byType(DateSelector),
    matching: find.byWidgetPredicate(
      (w) => w is Semantics && w.properties.selected != null,
    ),
  );
}

void main() {
  // Monday, 2024-01-01, normalized to local midnight. Picked so that the
  // seven generated cells (Mon..Sun) all share the same calendar month.
  final weekStart = DateTime(2024, 1, 1);
  final todayLocal = weekStart;
  final selectedDate = weekStart;

  group('DateSelector', () {
    testWidgets(
      'renders 7 day cells, each at least 48 × 48 dp',
      (tester) async {
        await tester.pumpWidget(
          _harness(
            weekStart: weekStart,
            todayLocal: todayLocal,
            selectedDate: selectedDate,
            onDateSelected: (_) {},
          ),
        );

        final cellFinder = _dayCellSemantics();
        expect(cellFinder, findsNWidgets(7));

        for (int i = 0; i < 7; i++) {
          final size = tester.getSize(cellFinder.at(i));
          expect(
            size.width,
            greaterThanOrEqualTo(48.0),
            reason: 'cell $i width should be ≥ 48 dp, got ${size.width}',
          );
          expect(
            size.height,
            greaterThanOrEqualTo(48.0),
            reason: 'cell $i height should be ≥ 48 dp, got ${size.height}',
          );
        }
      },
    );

    testWidgets(
      'tapping the 4th cell dispatches onDateSelected with weekStart + 3 days',
      (tester) async {
        DateTime? captured;

        await tester.pumpWidget(
          _harness(
            weekStart: weekStart,
            todayLocal: todayLocal,
            selectedDate: selectedDate,
            onDateSelected: (date) => captured = date,
          ),
        );

        final cellFinder = _dayCellSemantics();
        expect(cellFinder, findsNWidgets(7));

        // Index 3 → Thursday (the 4th day in a Monday-based week).
        // Tap the InkWell descendant so the gesture is dispatched by the
        // tappable surface rather than the (non-interactive) Semantics
        // wrapper.
        final tappable = find.descendant(
          of: cellFinder.at(3),
          matching: find.byType(InkWell),
        );
        expect(tappable, findsOneWidget);

        await tester.tap(tappable);
        await tester.pump();

        expect(captured, isNotNull);
        expect(captured, equals(weekStart.add(const Duration(days: 3))));
      },
    );

    testWidgets(
      'each day cell exposes a non-empty Semantics label',
      (tester) async {
        await tester.pumpWidget(
          _harness(
            weekStart: weekStart,
            todayLocal: todayLocal,
            selectedDate: selectedDate,
            onDateSelected: (_) {},
          ),
        );

        final cellFinder = _dayCellSemantics();
        expect(cellFinder, findsNWidgets(7));

        for (int i = 0; i < 7; i++) {
          final semantics = tester.widget<Semantics>(cellFinder.at(i));
          final label = semantics.properties.label;

          expect(
            label,
            isNotNull,
            reason: 'cell $i Semantics.label must be non-null',
          );
          expect(
            label,
            isNotEmpty,
            reason: 'cell $i Semantics.label must be non-empty',
          );

          // The cell's accessible label is `DateFormat.MMMEd('en')` of the
          // cell date — for 2024-01-01 (Monday) that is "Mon, Jan 1". We
          // assert that the day-of-month appears in the label rather than
          // pinning to the exact `intl` formatting, which is the
          // intentionally lenient form per the task description.
          final cellDate = weekStart.add(Duration(days: i));
          expect(
            label,
            contains('${cellDate.day}'),
            reason:
                'cell $i Semantics.label "$label" should contain '
                'day-of-month ${cellDate.day}',
          );
        }
      },
    );

    testWidgets(
      'prev/next chevrons expose localized Semantics labels',
      (tester) async {
        await tester.pumpWidget(
          _harness(
            weekStart: weekStart,
            todayLocal: todayLocal,
            selectedDate: selectedDate,
            onDateSelected: (_) {},
          ),
        );

        final context = tester.element(find.byType(DateSelector));
        final l10n = AppLocalizations.of(context)!;

        // Walk up from each chevron icon to the nearest [Semantics]
        // ancestor whose label is explicitly set (the wrapping
        // `Semantics(label: ...)` widget that `DateSelector` builds around
        // each chevron) and assert it matches the localized string.
        Semantics nearestLabeledSemantics(Finder iconFinder) {
          final semanticsFinder = find.ancestor(
            of: iconFinder,
            matching: find.byWidgetPredicate(
              (w) => w is Semantics && w.properties.label != null,
            ),
          );
          expect(semanticsFinder, findsAtLeast(1));
          return tester.widget<Semantics>(semanticsFinder.first);
        }

        final prevSemantics = nearestLabeledSemantics(
          find.byIcon(Icons.chevron_left),
        );
        expect(
          prevSemantics.properties.label,
          equals(l10n.dashboardDateSelectorPrev),
        );

        final nextSemantics = nearestLabeledSemantics(
          find.byIcon(Icons.chevron_right),
        );
        expect(
          nextSemantics.properties.label,
          equals(l10n.dashboardDateSelectorNext),
        );
      },
    );
  });
}
