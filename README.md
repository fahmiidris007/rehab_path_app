# RehabPath 🏃‍♂️

<p align="center">
  <img src="assets/images/logo_placeholder.png" alt="RehabPath Logo" width="120" />
</p>

<p align="center">
  A Flutter mobile application supporting fall-prevention rehabilitation programs for community-dwelling older adults.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart" alt="Dart" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey" alt="Platform" />
  <img src="https://img.shields.io/badge/Architecture-Clean%20Architecture-blueviolet" alt="Architecture" />
  <img src="https://img.shields.io/badge/State-flutter__bloc-orange" alt="State Management" />
</p>

---

## 📖 About

RehabPath is inspired by the **TOGETHER Feasibility RCT** research (Hawley-Hague et al., 2023). It delivers evidence-based exercise programs based on the **FaME** (Falls Management Exercise) and **Otago** protocols, applying 12 behavior change techniques (BCTs) including goal-setting, action planning, and behavioral feedback.

The app is designed specifically for **community-dwelling older adults**, with an accessible UI that prioritizes large touch targets, high contrast, and generous spacing.

---

## ✨ Features

### 🔐 Authentication
- Welcome carousel with value proposition slides
- Register & Login with inline form validation
- Guest mode (limited access without account)
- Automatic redirect to login on next app launch

### 🧩 Personalization Onboarding
- 7-step health questionnaire (age, fall history, health conditions, mobility, fear of falling, exercise preferences, goals)
- Automatic **ProgramLevel** assignment: Beginner / Intermediate / Advanced
- Partial progress saved — resume from where you left off

### 🏠 Home Dashboard
- Time-based greeting (Good morning / afternoon / evening)
- 🔥 Streak counter
- Circular progress ring for today's exercises
- Today's workout card with "Start Exercise" CTA
- Quick stats: total minutes, sessions, streak days
- Weekly calendar strip
- Locale-aware motivational messages (EN / ID)
- Recommended exercises filtered by program level

### 💪 Exercise Module
- 32+ exercises across 8 FaME/Otago categories:
  - Warm Up · Balance Training · Strength Training · Endurance/Aerobic
  - Tai Chi · Walking Program · Getting Up From Floor · Cool Down
- Exercise detail: video placeholder, step-by-step instructions, safety tips
- Exercise player: countdown timer, Pause/Resume/Skip
- Self-report form after completion (body condition + support used)

### 📊 Progress & Analytics
- Weekly & monthly adherence bar charts (fl_chart)
- Balance score trend line chart (BERG-like, 0–56)
- Falls diary with monthly calendar (TableCalendar)
- Achievement badges: First Session, 7-Day Streak, 30 Sessions
- Body areas worked visualization

### 👤 Profile
- Avatar with initials, name, age, program level
- Health conditions & goals summary
- Edit profile & update goals
- Emergency contacts (SOS)
- Logout with confirmation dialog

### ⚙️ Settings
- Language: English / Indonesian
- Font size: Default / Large / Extra Large
- Notifications: daily reminder toggle + voice cues toggle
- Privacy Policy & Terms of Service

### 🔔 Notifications
- Daily exercise reminders (scheduled via `flutter_local_notifications`)
- Streak milestone alerts (3, 7, 14, 30 days)
- Re-engagement notification after 2 days of inactivity
- Weekly progress summary (Monday 09:00)

### 🆘 SOS / Emergency
- Quick-access emergency button on home dashboard
- Emergency contact list with one-tap phone dialler
- Safety reminder message

---

## 🏗️ Architecture

RehabPath follows **Clean Architecture** with a strict 3-layer separation:

```
┌─────────────────────────────────────────────────────────┐
│  PRESENTATION LAYER                                      │
│  Pages · Widgets · Cubits · States                       │
│  (flutter_bloc, go_router, flutter_localizations)        │
├─────────────────────────────────────────────────────────┤
│  DOMAIN LAYER                                            │
│  Entities · UseCases · Repository Interfaces · Failures  │
│  (dartz, freezed)                                        │
├─────────────────────────────────────────────────────────┤
│  DATA LAYER                                              │
│  Repository Implementations · Data Sources · Models      │
│  (hive, shared_preferences, json_serializable)           │
└─────────────────────────────────────────────────────────┘
```

**Dependency direction:** Presentation → Domain ← Data. The Domain layer has zero Flutter/package dependencies beyond `dartz` and `freezed`.

### Folder Structure

```
lib/
├── app/                    # Root widget, theme, router, AppCubit
│   ├── cubit/
│   ├── router/
│   └── theme/
├── core/                   # Shared utilities, errors, base classes, widgets
│   ├── constants/
│   ├── errors/
│   ├── usecases/
│   └── widgets/
├── di/                     # GetIt + injectable setup
├── features/               # Feature-first modules
│   ├── auth/
│   ├── exercise/
│   ├── home/
│   ├── notifications/
│   ├── onboarding/
│   ├── profile/
│   ├── progress/
│   ├── settings/
│   └── sos/
├── l10n/                   # ARB localization files (EN / ID)
└── shared/                 # Cross-feature entities, enums, data sources
    ├── data/
    └── domain/
```

---

## 🛠️ Tech Stack

| Category | Package | Version |
|---|---|---|
| **Framework** | Flutter | 3.x |
| **State Management** | flutter_bloc (Cubit) | ^8.1.6 |
| **Dependency Injection** | get_it + injectable | ^7.7.0 / ^2.4.4 |
| **Navigation** | go_router | ^14.2.7 |
| **Local Storage** | hive + hive_flutter | ^2.2.3 |
| **Session Storage** | shared_preferences | ^2.3.2 |
| **Functional Programming** | dartz | ^0.10.1 |
| **Code Generation** | freezed + json_serializable | 2.5.2 / ^6.8.0 |
| **Form Validation** | formz | ^0.7.0 |
| **Notifications** | flutter_local_notifications | ^17.2.3 |
| **Charts** | fl_chart | ^0.69.0 |
| **Calendar** | table_calendar | ^3.1.2 |
| **Fonts** | google_fonts | ^6.2.1 |
| **Logging** | logger | ^2.4.0 |
| **URL Launcher** | url_launcher | ^6.3.0 |
| **Localization** | flutter_localizations + intl | SDK / ^0.20.2 |

---

## 🎨 Design System

Design tokens are extracted from the [Figma file](https://www.figma.com/design/Pkh1VzLRE0adznde6FmdFi/RehabPath).

### Colors

| Role | Hex | Usage |
|---|---|---|
| Primary | `#00609B` | Buttons, active states, headings |
| Primary Light | `#0079C3` | Active nav tab, motivational card |
| Accent / CTA | `#FFA454` | Streak badge, progress fill, active exercise node |
| Background | `#F9F9F9` | Page background |
| Text Primary | `#1A1C1C` | Main body text |
| Text Secondary | `#404751` | Subtitles, labels |
| Error | `#BA1A1A` | Emergency button, error states |

### Typography

Font: **Public Sans** (via Google Fonts)

| Style | Size | Weight |
|---|---|---|
| Display H1 | 30sp | Bold |
| H2 App Bar | 24sp | Bold |
| H3 Section | 24sp | Bold |
| Body Large | 20sp | Regular |
| Body | 18sp | Regular |
| Button | 18sp | Bold |

### Accessibility

- Minimum body text: **16sp**
- Minimum touch target: **48×48 dp** (recommended 56dp for primary actions)
- WCAG AAA contrast ratio: **7:1** for normal text
- System font scaling support up to **2.0×**
- Generous padding: **24dp** on content screens

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.9.2`
- Dart SDK `^3.9.2`
- Android Studio / Xcode (for device/emulator)

### Installation

```bash
# Clone the repository
git clone https://github.com/your-username/rehab_path_app.git
cd rehab_path_app

# Install dependencies
flutter pub get

# Run code generation (freezed, injectable, hive adapters)
flutter pub run build_runner build --delete-conflicting-outputs

# Generate localization files
flutter gen-l10n

# Run the app
flutter run
```

### Running on a specific platform

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios
```

---

## 📦 Dummy Data

The app ships with static JSON data under `assets/data/` for offline-first demonstration:

| File | Contents |
|---|---|
| `dummy_users.json` | 3 sample users (one per ProgramLevel) with emergency contacts |
| `dummy_exercises.json` | 32 exercises across 8 categories |
| `dummy_programs.json` | Weekly schedules for Beginner / Intermediate / Advanced |
| `dummy_progress.json` | 118 session records spanning 13+ weeks + 8 balance score points |
| `dummy_messages.json` | 24 motivational messages (EN + ID) |

Data is seeded into Hive on first launch and only once (guarded by a `seedingComplete` flag in SharedPreferences).

---

## 🔄 App Flow

```
Launch
  ├── First time user  → Welcome Carousel → Register → Login → Onboarding (7 steps) → Home
  └── Returning user   → Login → Home

Home
  ├── Start Exercise → Exercise Detail → Exercise Player → Self-Report → Home (updated)
  ├── Progress tab   → Adherence charts, Balance trend, Falls diary, Badges
  ├── Exercise tab   → Browse by category → Detail → Player
  └── Profile tab    → View/Edit profile, Update goals, SOS, Logout
```

---

## 🧪 Code Quality

```bash
# Static analysis (zero issues expected)
flutter analyze

# Run tests
flutter test
```

The project enforces:
- `flutter_lints` strict ruleset via `analysis_options.yaml`
- No `print()` calls in production code (use `logger`)
- No hardcoded user-facing strings (all in ARB files)
- `Either<Failure, T>` for all use case return types

---

## 📱 Screenshots

> _Screenshots will be added after the first stable release._

---

## 🗺️ Roadmap

- [ ] Backend integration (REST API via Dio)
- [ ] Real authentication (Firebase Auth / custom backend)
- [ ] Video exercise instructions
- [ ] Voice cue audio playback
- [ ] Dark mode support
- [ ] Wearable device integration
- [ ] Clinician dashboard (web)

---

## 📄 License

This project is for educational and research purposes. See [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgements

- Research basis: **TOGETHER Feasibility RCT** — Hawley-Hague et al. (2023)
- Exercise protocols: **FaME** (Falls Management Exercise) and **Otago Exercise Programme**
- UI Design: [Figma — RehabPath](https://www.figma.com/design/Pkh1VzLRE0adznde6FmdFi/RehabPath)
- Built with [Flutter](https://flutter.dev) ❤️
