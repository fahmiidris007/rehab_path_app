// Property-based tests for [UserHiveModel] ↔ [UserEntity] round-tripping.
//
// **Validates: Requirements 2.1, 2.2, 6.5, 10.6, 14.1, 14.4**
//
// Property 7: Hive round-trip preserves entity equality (including legacy
//             records).
//
// The contract under test:
//   * `UserHiveModel.fromEntity(entity).toEntity() == entity`
//     for every well-formed [UserEntity], with the documented email
//     normalisation rule (null ↔ ''). To keep the property clean, the
//     generators below produce `email` only as `null` or as a non-empty
//     string — empty strings are treated as the same equivalence class as
//     `null` and would conflate the two states under the round-trip.
//
//   * Legacy records — i.e. those written by an older app version that
//     pre-dates [HiveField(10)] (`phoneNumber`) — load with
//     `phoneNumber == ''` thanks to `defaultValue: ''`. The legacy fixture
//     constructs a [UserHiveModel] directly with `phoneNumber: ''` and asserts
//     `toEntity().phoneNumber == ''` while the rest of the fields are
//     preserved verbatim.
//
//   * Hive binary round-trip — for the in-memory shape above, `put`-then-`get`
//     through a real Hive box yields a `UserHiveModel` whose `toEntity()` is
//     equal to the original entity. This catches `@HiveField` numbering
//     regressions that pure in-memory round-trips cannot.
//
// Glados runs each property at least 100 iterations (the default
// `ExploreConfig.numRuns`).

import 'package:glados/glados.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:laman_lansia/shared/data/models/emergency_contact_hive_model.dart';
import 'package:laman_lansia/shared/data/models/onboarding_profile_hive_model.dart';
import 'package:laman_lansia/shared/data/models/user_hive_model.dart';
import 'package:laman_lansia/shared/domain/entities/emergency_contact_entity.dart';
import 'package:laman_lansia/shared/domain/entities/onboarding_profile_entity.dart';
import 'package:laman_lansia/shared/domain/entities/user_entity.dart';
import 'package:laman_lansia/shared/domain/enums/app_enums.dart';

// ── Generators ───────────────────────────────────────────────────────────────

const _digits = '0123456789';
// Printable, well-behaved characters for free-text fields. Avoid surrogate
// pairs and control characters so generated strings round-trip cleanly through
// the Hive binary codec.
const _textChars =
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ '
    '0123456789._-';

extension _UserEntityAnys on Any {
  /// Strings of digits with length in `[min, max)`.
  Generator<String> _digitsOfLength(int min, int max) =>
      listWithLengthInRange(min, max, choose(_digits.split('')))
          .map((chars) => chars.join());

  /// Valid E.164 phone number: '+' followed by 8-15 digits.
  Generator<String> get e164PhoneNumber =>
      _digitsOfLength(8, 16).map((d) => '+$d');

  /// Free-text strings of length in `[min, max)`. Drawn from a printable
  /// alphabet so equality comparisons are stable and Hive can encode them.
  Generator<String> _textOfLength(int min, int max) =>
      listWithLengthInRange(min, max, choose(_textChars.split('')))
          .map((chars) => chars.join());

  /// User name: 1-20 characters of printable text.
  Generator<String> get userName => _textOfLength(1, 21);

  /// Gender: a small bounded vocabulary keeps the round-trip space tight.
  Generator<String> get gender =>
      choose(<String>['female', 'male', 'non_binary', 'prefer_not_to_say']);

  /// Age in `[18, 100]`.
  Generator<int> get age => intInRange(18, 101);

  /// Program level drawn uniformly from the enum.
  Generator<ProgramLevel> get programLevel => choose(ProgramLevel.values);

  /// Health-condition labels: 0-3 short strings.
  Generator<List<String>> get healthConditions =>
      listWithLengthInRange(0, 4, _textOfLength(1, 16));

  /// Emergency-contact entity: name, relationship, valid E.164 phone.
  Generator<EmergencyContactEntity> get emergencyContact => combine3(
        _textOfLength(1, 16),
        _textOfLength(1, 16),
        e164PhoneNumber,
        (String name, String relationship, String phone) =>
            EmergencyContactEntity(
              name: name,
              relationship: relationship,
              phoneNumber: phone,
            ),
      );

  /// 0-3 emergency contacts.
  Generator<List<EmergencyContactEntity>> get emergencyContacts =>
      listWithLengthInRange(0, 4, emergencyContact);

  /// Avatar path: nullable, non-empty when present.
  Generator<String?> get avatarPath => _textOfLength(1, 32).nullable;

  /// Email: nullable, non-empty when present (see file header for rationale).
  Generator<String?> get email => _textOfLength(1, 32).nullable;

  /// Onboarding profile with realistic ranges.
  Generator<OnboardingProfileEntity> get onboardingProfile => combine10(
        age,
        gender,
        intInRange(0, 11), // fallsInLastYear: 0-10
        healthConditions,
        any.bool,
        intInRange(1, 11), // fearOfFallingScore: 1-10
        choose(<String>['morning', 'afternoon', 'evening']),
        intInRange(5, 61), // sessionDurationMinutes: 5-60
        intInRange(3, 7), // weeklyFrequencyTarget: 3-6
        programLevel,
        (
          int a,
          String g,
          int falls,
          List<String> conds,
          bool aid,
          int fear,
          String time,
          int duration,
          int weekly,
          ProgramLevel level,
        ) =>
            OnboardingProfileEntity(
              age: a,
              gender: g,
              fallsInLastYear: falls,
              healthConditions: conds,
              usesWalkingAid: aid,
              fearOfFallingScore: fear,
              preferredExerciseTime: time,
              sessionDurationMinutes: duration,
              weeklyFrequencyTarget: weekly,
              outcomeGoal: 'goal',
              behaviouralGoal: 'b_goal',
              programLevel: level,
              lastCompletedStep: null,
            ),
      );

  /// Optional onboarding profile.
  Generator<OnboardingProfileEntity?> get optionalOnboardingProfile =>
      onboardingProfile.nullable;

  /// User id: non-empty short text.
  Generator<String> get userId => _textOfLength(1, 16);

  /// Fully-formed [UserEntity] with all fields exercised.
  Generator<UserEntity> get userEntity {
    // Combine in two stages because `combine10` is the largest builder
    // exposed by glados and we have 11 dimensions of variation.
    final core = combine9(
      userId,
      userName,
      e164PhoneNumber,
      age,
      gender,
      programLevel,
      healthConditions,
      emergencyContacts,
      email,
      (
        String id,
        String name,
        String phone,
        int a,
        String g,
        ProgramLevel level,
        List<String> conds,
        List<EmergencyContactEntity> contacts,
        String? em,
      ) => UserEntity(
        id: id,
        name: name,
        phoneNumber: phone,
        age: a,
        gender: g,
        programLevel: level,
        healthConditions: conds,
        emergencyContacts: contacts,
        email: em,
      ),
    );
    return combine3(
      core,
      avatarPath,
      optionalOnboardingProfile,
      (UserEntity u, String? avatar, OnboardingProfileEntity? profile) =>
          u.copyWith(avatarPath: avatar, onboardingProfile: profile),
    );
  }
}

void main() {
  group('UserHiveModel round-trip — Property 7', () {
    setUpAll(() async {
      await setUpTestHive();
      Hive.registerAdapter(UserHiveModelAdapter());
      Hive.registerAdapter(EmergencyContactHiveModelAdapter());
      Hive.registerAdapter(OnboardingProfileHiveModelAdapter());
    });

    tearDownAll(() async {
      await tearDownTestHive();
    });

    // In-memory round-trip: pure mapping, no Hive box involved.
    Glados(any.userEntity).test(
      'fromEntity then toEntity is the identity',
      (entity) {
        final model = UserHiveModel.fromEntity(entity);
        final round = model.toEntity();
        expect(round, equals(entity));
      },
    );

    // Hive binary round-trip: catches @HiveField numbering regressions.
    Glados(any.userEntity).test(
      'put/get through a Hive box preserves the entity',
      (entity) async {
        // Per-iteration box keeps the test hermetic and avoids state bleed
        // between Glados explorations / shrink steps.
        final boxName = 'user_round_trip_${entity.id.hashCode.toRadixString(16)}'
            '_${DateTime.now().microsecondsSinceEpoch}';
        final box = await Hive.openBox<UserHiveModel>(boxName);
        try {
          await box.put('user', UserHiveModel.fromEntity(entity));
          final loaded = box.get('user');
          expect(loaded, isNotNull);
          expect(loaded!.toEntity(), equals(entity));
        } finally {
          await box.close();
          await Hive.deleteBoxFromDisk(boxName);
        }
      },
    );

    // Legacy record fixture: a [UserHiveModel] written by an older app
    // version that pre-dates `phoneNumber` defaults to '' on read. The
    // generated adapter's `defaultValue: ''` guarantees this in-memory shape;
    // here we simulate it by constructing the model directly.
    test('legacy record (phoneNumber == "") loads with empty phoneNumber '
        'and preserves all other fields', () {
      final legacy = UserHiveModel(
        id: 'legacy_user_1',
        name: 'Aisyah Pre-migration',
        email: 'aisyah@example.com',
        age: 67,
        gender: 'female',
        programLevel: ProgramLevel.beginner.name,
        healthConditions: const ['hypertension'],
        emergencyContacts: [
          EmergencyContactHiveModel(
            name: 'Budi',
            relationship: 'son',
            phoneNumber: '+6281234567890',
          ),
        ],
        phoneNumber: '', // simulates legacy record (no HiveField(10) value)
        avatarPath: null,
        onboardingProfile: null,
      );

      final entity = legacy.toEntity();

      expect(entity.phoneNumber, equals(''));
      expect(entity.id, equals('legacy_user_1'));
      expect(entity.name, equals('Aisyah Pre-migration'));
      expect(entity.email, equals('aisyah@example.com'));
      expect(entity.age, equals(67));
      expect(entity.gender, equals('female'));
      expect(entity.programLevel, equals(ProgramLevel.beginner));
      expect(entity.healthConditions, equals(const ['hypertension']));
      expect(entity.emergencyContacts, hasLength(1));
      expect(entity.emergencyContacts.single.phoneNumber,
          equals('+6281234567890'));
      expect(entity.avatarPath, isNull);
      expect(entity.onboardingProfile, isNull);
    });

    // Legacy record + null email round-trip: empty email also normalises to
    // null on read, matching the documented mapping rule.
    test('legacy record with empty email round-trips email as null', () {
      final legacy = UserHiveModel(
        id: 'legacy_user_2',
        name: 'Pak Joko',
        email: '', // legacy users may have no email
        age: 72,
        gender: 'male',
        programLevel: ProgramLevel.intermediate.name,
        healthConditions: const [],
        emergencyContacts: const [],
        phoneNumber: '',
        avatarPath: null,
        onboardingProfile: null,
      );

      final entity = legacy.toEntity();

      expect(entity.email, isNull);
      expect(entity.phoneNumber, equals(''));
    });
  });
}
