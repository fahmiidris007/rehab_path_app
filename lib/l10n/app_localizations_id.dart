// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'RehabPath';

  @override
  String get appTitle => 'RehabPath — Rehabilitasi Pencegahan Jatuh';

  @override
  String get authSplashTagline =>
      'Perjalanan Anda menuju keseimbangan yang lebih baik dimulai di sini.';

  @override
  String get authWelcomeTitle => 'Selamat Datang di RehabPath';

  @override
  String get authWelcomeSubtitle =>
      'Latihan berbasis bukti untuk membantu Anda tetap stabil dan percaya diri.';

  @override
  String get authLoginTitle => 'Masuk';

  @override
  String get authLoginEmailHint => 'Alamat email';

  @override
  String get authLoginEmailError => 'Masukkan alamat email yang valid.';

  @override
  String get authLoginPasswordHint => 'Kata sandi';

  @override
  String get authLoginPasswordError => 'Kata sandi harus 8–64 karakter.';

  @override
  String get authLoginButton => 'Masuk';

  @override
  String get authRegisterTitle => 'Buat Akun';

  @override
  String get authRegisterNameHint => 'Nama lengkap';

  @override
  String get authRegisterNameError => 'Nama harus 1–50 karakter.';

  @override
  String get authRegisterEmailHint => 'Alamat email';

  @override
  String get authRegisterEmailError => 'Masukkan alamat email yang valid.';

  @override
  String get authRegisterPasswordHint => 'Kata sandi';

  @override
  String get authRegisterPasswordError => 'Kata sandi harus 8–64 karakter.';

  @override
  String get authRegisterConfirmPasswordHint => 'Konfirmasi kata sandi';

  @override
  String get authRegisterConfirmPasswordError => 'Kata sandi tidak cocok.';

  @override
  String get authRegisterButton => 'Buat Akun';

  @override
  String get authForgotPasswordTitle => 'Lupa Kata Sandi';

  @override
  String get authForgotPasswordMessage =>
      'Masukkan alamat email Anda dan kami akan mengirimkan tautan untuk mengatur ulang kata sandi Anda.';

  @override
  String get authForgotPasswordButton => 'Kirim Tautan Reset';

  @override
  String get authGuestButton => 'Lanjutkan sebagai Tamu';

  @override
  String get authGuestBannerMessage =>
      'Anda menjelajah sebagai tamu. Buat akun untuk menyimpan kemajuan Anda.';

  @override
  String get authLogoutButton => 'Keluar';

  @override
  String get onboardingTitle => 'Ceritakan Tentang Diri Anda';

  @override
  String onboardingStepIndicator(int current, int total) {
    return 'Langkah $current dari $total';
  }

  @override
  String get onboardingStep1Title => 'Usia & Jenis Kelamin';

  @override
  String get onboardingStep2Title => 'Riwayat Jatuh';

  @override
  String get onboardingStep3Title => 'Kondisi Kesehatan';

  @override
  String get onboardingStep4Title => 'Alat Bantu Jalan';

  @override
  String get onboardingStep5Title => 'Ketakutan Jatuh';

  @override
  String get onboardingStep6Title => 'Preferensi Latihan';

  @override
  String get onboardingStep7Title => 'Tujuan Anda';

  @override
  String get onboardingContinueButton => 'Lanjutkan';

  @override
  String get onboardingBackButton => 'Kembali';

  @override
  String get onboardingFinishButton => 'Selesai';

  @override
  String get onboardingValidationRequired => 'Kolom ini wajib diisi.';

  @override
  String get homeGreetingMorning => 'Selamat pagi';

  @override
  String get homeGreetingAfternoon => 'Selamat siang';

  @override
  String get homeGreetingEvening => 'Selamat malam';

  @override
  String homeStreakDays(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Streak $countString hari',
      one: 'Streak 1 hari',
    );
    return '$_temp0';
  }

  @override
  String get homeTodayActivity => 'Aktivitas Hari Ini';

  @override
  String get homeStartExercise => 'Mulai Latihan';

  @override
  String get homeNoProgram =>
      'Belum ada program yang ditetapkan. Selesaikan orientasi untuk memulai.';

  @override
  String get homeRecommendedTitle => 'Direkomendasikan untuk Anda';

  @override
  String get homeTotalMinutes => 'Total Menit';

  @override
  String get homeTotalSessions => 'Total Sesi';

  @override
  String get exerciseListTitle => 'Latihan';

  @override
  String exerciseDifficulty(String level) {
    return 'Kesulitan: $level';
  }

  @override
  String get exerciseStartButton => 'Mulai Latihan';

  @override
  String get exerciseMarkComplete => 'Tandai Selesai';

  @override
  String get exercisePause => 'Jeda';

  @override
  String get exerciseResume => 'Lanjutkan';

  @override
  String get exerciseSkip => 'Lewati';

  @override
  String get exerciseSelfReportTitle => 'Bagaimana hasilnya?';

  @override
  String get exerciseSelfReportBodyCondition => 'Kondisi tubuh saat latihan';

  @override
  String get exerciseSelfReportSitting => 'Duduk';

  @override
  String get exerciseSelfReportStanding => 'Berdiri';

  @override
  String get exerciseSelfReportSupport => 'Dukungan yang digunakan';

  @override
  String get exerciseSelfReportWalkingAid => 'Alat bantu jalan';

  @override
  String get exerciseSelfReportKitchenWorktop => 'Meja dapur';

  @override
  String get exerciseSelfReportNoSupport => 'Tanpa dukungan';

  @override
  String get exerciseSelfReportSubmit => 'Kirim';

  @override
  String get progressTitle => 'Kemajuan';

  @override
  String get progressWeeklyAdherence => 'Kepatuhan Mingguan';

  @override
  String get progressMonthlyAdherence => 'Kepatuhan Bulanan';

  @override
  String get progressBalanceScore => 'Skor Keseimbangan';

  @override
  String get progressFallsDiary => 'Catatan Jatuh';

  @override
  String get progressAchievements => 'Pencapaian';

  @override
  String get progressBodyAreas => 'Area Tubuh yang Dilatih';

  @override
  String get progressNoData =>
      'Belum ada data. Selesaikan latihan untuk melihat kemajuan Anda.';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileEditButton => 'Edit Profil';

  @override
  String get profileUpdateGoals => 'Perbarui Tujuan';

  @override
  String get profileProgramLevel => 'Tingkat Program';

  @override
  String get profileHealthConditions => 'Kondisi Kesehatan';

  @override
  String get profileGoals => 'Tujuan';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsAppearance => 'Tampilan';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeLight => 'Terang';

  @override
  String get settingsThemeDark => 'Gelap';

  @override
  String get settingsThemeSystem => 'Default sistem';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsLanguageEn => 'Inggris';

  @override
  String get settingsLanguageId => 'Indonesia';

  @override
  String get settingsFontSize => 'Ukuran Font';

  @override
  String get settingsFontSizeDefault => 'Default';

  @override
  String get settingsFontSizeLarge => 'Besar';

  @override
  String get settingsFontSizeExtraLarge => 'Sangat Besar';

  @override
  String get settingsNotifications => 'Notifikasi';

  @override
  String get settingsDailyReminder => 'Pengingat Harian';

  @override
  String get settingsPrivacyPolicy => 'Kebijakan Privasi';

  @override
  String get settingsTermsOfService => 'Syarat Layanan';

  @override
  String get settingsLogout => 'Keluar';

  @override
  String get sosTitle => 'SOS Darurat';

  @override
  String get sosSafetyReminder =>
      'Jika Anda jatuh dan tidak bisa bangun, segera hubungi layanan darurat.';

  @override
  String get sosCallButton => 'Hubungi';

  @override
  String get sosNoContacts => 'Belum ada kontak darurat. Perbarui profil Anda.';

  @override
  String get sosEmergencyButton => 'Hubungi Layanan Darurat';

  @override
  String get notificationDailyReminderTitle => 'Waktunya Latihan!';

  @override
  String get notificationDailyReminderBody =>
      'Sesi rehabilitasi harian Anda sudah siap. Terus semangat!';

  @override
  String get notificationStreakTitle => 'Pencapaian Streak!';

  @override
  String notificationStreakBody(int days) {
    return 'Luar biasa! Anda telah menjaga streak latihan selama $days hari. Pertahankan!';
  }

  @override
  String get notificationReEngagementTitle => 'Kami Merindukanmu!';

  @override
  String get notificationReEngagementBody =>
      'Sudah lama sejak sesi terakhir Anda. Kembali dan lanjutkan kemajuan Anda!';

  @override
  String get notificationWeeklySummaryTitle => 'Ringkasan Mingguan';

  @override
  String notificationWeeklySummaryBody(int rate) {
    return 'Anda menyelesaikan $rate% latihan minggu ini. Kerja bagus!';
  }

  @override
  String get notificationPermissionDeniedMessage =>
      'Izin notifikasi ditolak. Aktifkan notifikasi di pengaturan perangkat Anda untuk menerima pengingat.';

  @override
  String get errorServer =>
      'Terjadi kesalahan server. Silakan coba lagi nanti.';

  @override
  String get errorCache =>
      'Tidak dapat memuat data dari penyimpanan lokal. Silakan mulai ulang aplikasi.';

  @override
  String get errorUnexpected =>
      'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.';

  @override
  String get errorSeedingFailed =>
      'Gagal memuat data awal. Silakan mulai ulang aplikasi.';

  @override
  String get errorPhoneNotSupported =>
      'Panggilan telepon tidak didukung di perangkat ini.';

  @override
  String get errorSaveProfile => 'Gagal menyimpan profil. Silakan coba lagi.';

  @override
  String get errorLoadData => 'Gagal memuat data. Silakan coba lagi.';
}
