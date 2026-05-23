import '../../../../shared/domain/entities/exercise_entity.dart';

/// Pure routing decision used by the exercise player after a session is
/// saved.
///
/// The runtime side-effects (calling `context.goNamed`, showing snackbars,
/// resolving cubit references) live in `exercise_player_page.dart`. This
/// helper isolates the *decision* — "where do we go next?" — into a small,
/// dependency-free function that can be exercised by property tests without
/// spinning up a widget tree.
///
/// **Validates: Requirement 10.5** — post-save navigation always advances
/// the user to either the next incomplete exercise in today's schedule or
/// back to home.
class PostSaveNavigation {
  PostSaveNavigation._();

  /// Decides where to route after a session is saved. Pure: depends only
  /// on `(nextExercise, allTodayDone)`.
  ///
  /// Returns:
  /// - [PostSaveRoute.exerciseDetail] with `nextExercise.id` when there is
  ///   a next incomplete exercise *and* not all of today's schedule has
  ///   been completed.
  /// - [PostSaveRoute.home] with `allTodayDone: true` when all of today's
  ///   schedule is complete.
  /// - [PostSaveRoute.home] with `allTodayDone: false` when there is no
  ///   next exercise but the schedule is also not fully complete (edge
  ///   case — e.g. an empty schedule on initial load).
  static PostSaveRoute decide({
    required ExerciseEntity? nextExercise,
    required bool allTodayDone,
  }) {
    if (nextExercise != null && !allTodayDone) {
      return PostSaveRoute.exerciseDetail(nextExercise.id);
    }
    return PostSaveRoute.home(allTodayDone: allTodayDone);
  }
}

/// Sealed result type returned by [PostSaveNavigation.decide].
///
/// Two concrete shapes are exposed via factory constructors so callers can
/// pattern-match exhaustively against [ExerciseDetailRoute] and [HomeRoute].
sealed class PostSaveRoute {
  const PostSaveRoute();

  /// Route to the exercise detail page for the given [id].
  factory PostSaveRoute.exerciseDetail(String id) = ExerciseDetailRoute;

  /// Route back to the home dashboard. [allTodayDone] indicates whether the
  /// caller should also surface a "Semua latihan hari ini selesai" message.
  factory PostSaveRoute.home({required bool allTodayDone}) = HomeRoute;
}

/// Navigate to `/exercises/{id}`.
final class ExerciseDetailRoute extends PostSaveRoute {
  const ExerciseDetailRoute(this.id);
  final String id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseDetailRoute && other.id == id);

  @override
  int get hashCode => Object.hash(runtimeType, id);

  @override
  String toString() => 'ExerciseDetailRoute(id: $id)';
}

/// Navigate back to the home dashboard.
final class HomeRoute extends PostSaveRoute {
  const HomeRoute({required this.allTodayDone});
  final bool allTodayDone;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HomeRoute && other.allTodayDone == allTodayDone);

  @override
  int get hashCode => Object.hash(runtimeType, allTodayDone);

  @override
  String toString() => 'HomeRoute(allTodayDone: $allTodayDone)';
}
