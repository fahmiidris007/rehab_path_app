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
  String get authLoginPasswordError => 'Kata sandi minimal 8 karakter.';

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
  String get authRegisterPasswordError => 'Kata sandi minimal 8 karakter.';

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
  String get progressTitle => 'Progres';

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
  String get sosAddContact => 'Tambah Kontak';

  @override
  String get sosAddContactTitle => 'Tambah Kontak Darurat';

  @override
  String get sosEditContactTitle => 'Edit Kontak Darurat';

  @override
  String get sosEditContact => 'Edit';

  @override
  String get sosDeleteContact => 'Hapus';

  @override
  String get sosDeleteContactTitle => 'Hapus Kontak';

  @override
  String sosDeleteContactMessage(String name) {
    return 'Hapus $name dari kontak darurat Anda?';
  }

  @override
  String get sosSaveContact => 'Simpan Kontak';

  @override
  String get sosContactName => 'Nama';

  @override
  String get sosContactNameHint => 'mis. Budi Santoso';

  @override
  String get sosContactNameRequired => 'Masukkan nama.';

  @override
  String get sosContactRelationship => 'Hubungan';

  @override
  String get sosContactRelationshipHint => 'mis. Anak, Tetangga, Saudara';

  @override
  String get sosContactRelationshipRequired => 'Masukkan hubungan.';

  @override
  String get sosContactPhone => 'Nomor Telepon';

  @override
  String get sosContactPhoneHint => 'mis. +62 812 3456 7890';

  @override
  String get sosContactPhoneRequired => 'Masukkan nomor telepon.';

  @override
  String get sosContactPhoneInvalid => 'Masukkan nomor telepon yang valid.';

  @override
  String get sosAddContactsPrompt =>
      'Ketuk tombol di bawah untuk menambahkan kontak darurat pertama Anda.';

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

  @override
  String get navHome => 'Beranda';

  @override
  String get navExercise => 'Latihan';

  @override
  String get navProgress => 'Progres';

  @override
  String get navProfile => 'Profil';

  @override
  String get selectLanguage => 'Pilih Bahasa';

  @override
  String get authLoginNoAccount => 'Belum punya akun?';

  @override
  String get authLoginRegisterLink => 'Daftar';

  @override
  String get authLoginForgotPassword => 'Lupa Kata Sandi?';

  @override
  String get authRegisterHaveAccount => 'Sudah punya akun?';

  @override
  String get authRegisterLoginLink => 'Masuk';

  @override
  String get authRegisterSuccessMessage =>
      'Akun berhasil dibuat! Silakan masuk untuk melanjutkan.';

  @override
  String get authForgotPasswordResetSent => 'Tautan reset terkirim!';

  @override
  String get authForgotPasswordResetBody =>
      'Periksa email Anda untuk tautan reset kata sandi. Jika tidak muncul dalam beberapa menit, periksa folder spam Anda.';

  @override
  String get authForgotPasswordBackToLogin => 'Kembali ke Masuk';

  @override
  String get welcomeGetStarted => 'Mulai';

  @override
  String get welcomeSlide1Title => 'Tetap Stabil';

  @override
  String get welcomeSlide1Subtitle =>
      'Bangun kepercayaan diri dan kurangi risiko jatuh dengan latihan keseimbangan terpandu yang dirancang untuk Anda.';

  @override
  String get welcomeSlide2Title => 'Latihan Setiap Hari';

  @override
  String get welcomeSlide2Subtitle =>
      'Ikuti program FaME dan Otago berbasis bukti yang disesuaikan dengan tingkat kebugaran dan tujuan Anda.';

  @override
  String get welcomeSlide3Title => 'Pantau Progres';

  @override
  String get welcomeSlide3Subtitle =>
      'Pantau perkembangan Anda dari waktu ke waktu dan rayakan pencapaian dalam perjalanan rehabilitasi Anda.';

  @override
  String get homeNoExercisesToday => 'Tidak ada latihan hari ini';

  @override
  String get homeRestDayMessage =>
      'Nikmati hari istirahat Anda atau jelajahi latihan yang direkomendasikan di bawah.';

  @override
  String get homeNoRecommendations => 'Tidak ada rekomendasi tersedia.';

  @override
  String get homeRecommendedFor => 'Direkomendasikan untuk Anda';

  @override
  String get homeTodayWorkout => 'Latihan Hari Ini';

  @override
  String get homeExerciseSingular => 'Latihan';

  @override
  String get homeExercisePlural => 'Latihan';

  @override
  String get homeMinutes => 'Menit';

  @override
  String get homeDone => 'Selesai';

  @override
  String get homeAllDoneToday => 'Semua Selesai Hari Ini 🎉';

  @override
  String homeContinueLeft(int remaining) {
    return 'Lanjutkan ($remaining tersisa)';
  }

  @override
  String get homeStatMinutes => 'Menit';

  @override
  String get homeStatSessions => 'Sesi';

  @override
  String get homeStatDayStreak => 'Hari Berturut';

  @override
  String get homeStatDays => 'Hari';

  @override
  String get homeGuestBannerMessage =>
      'Anda dalam mode Tamu. Daftar atau masuk untuk menyimpan kemajuan Anda.';

  @override
  String get guestBannerRegister => 'Daftar';

  @override
  String get exerciseCompletedToday => 'Selesai hari ini';

  @override
  String get exerciseRedoButton => 'Ulangi Latihan';

  @override
  String get exerciseCouldNotLoad => 'Tidak dapat memuat latihan';

  @override
  String get exerciseDifficultyLabel => 'Kesulitan';

  @override
  String get exerciseHowToDoIt => 'Cara melakukannya';

  @override
  String get exerciseSafetyTips => 'Tips Keamanan';

  @override
  String exerciseNext(String name) {
    return 'Berikutnya: $name';
  }

  @override
  String exerciseDurationMin(int duration) {
    return '$duration menit';
  }

  @override
  String exerciseSets(int sets) {
    return '$sets set';
  }

  @override
  String exerciseReps(int reps) {
    return '$reps repetisi';
  }

  @override
  String get exerciseDifficultyEasy => 'Mudah';

  @override
  String get exerciseDifficultyMedium => 'Sedang';

  @override
  String get exerciseDifficultyHard => 'Sulit';

  @override
  String get exercisePlayerPaused => 'Dijeda';

  @override
  String get exerciseSomethingWentWrong => 'Terjadi kesalahan';

  @override
  String get exerciseNoExercisesYet => 'Belum ada latihan';

  @override
  String get exerciseCheckBackSoon =>
      'Kembali lagi segera untuk program latihan Anda.';

  @override
  String get exerciseCategoryWarmUp => 'Pemanasan';

  @override
  String get exerciseCategoryBalanceTraining => 'Latihan Keseimbangan';

  @override
  String get exerciseCategoryStrengthTraining => 'Latihan Kekuatan';

  @override
  String get exerciseCategoryEnduranceAerobic => 'Daya Tahan / Aerobik';

  @override
  String get exerciseCategoryTaiChi => 'Tai Chi';

  @override
  String get exerciseCategoryWalkingProgram => 'Program Berjalan';

  @override
  String get exerciseCategoryGettingUpFromFloor => 'Bangun dari Lantai';

  @override
  String get exerciseCategoryCoolDown => 'Pendinginan';

  @override
  String get exerciseSelfReportBodyPosition => 'Posisi tubuh';

  @override
  String get progressMyProgress => 'Progres Saya';

  @override
  String get progressAdherence => 'Kepatuhan';

  @override
  String get progressThisWeek => 'Minggu Ini';

  @override
  String get progressThisMonth => 'Bulan Ini';

  @override
  String get progressNoDataYet => 'Belum ada data';

  @override
  String get progressCompleteExercises =>
      'Selesaikan latihan untuk melihat kemajuan Anda.';

  @override
  String get progressBalanceScoreTrend => 'Tren Skor Keseimbangan';

  @override
  String get progressNoBalanceData => 'Belum ada data keseimbangan';

  @override
  String get progressCompleteAssessments =>
      'Selesaikan penilaian keseimbangan untuk melacak tren Anda.';

  @override
  String get progressFallRecorded => 'Jatuh tercatat — ketuk untuk menghapus';

  @override
  String get progressNoBadgesYet => 'Belum ada lencana';

  @override
  String get progressKeepExercising =>
      'Terus berlatih untuk mendapatkan lencana pertama Anda!';

  @override
  String get progressBodyAreasThisWeek => 'Area Tubuh yang Dilatih Minggu Ini';

  @override
  String get progressNoAreasTracked => 'Belum ada area yang dilacak';

  @override
  String get progressCompleteThisWeek =>
      'Selesaikan latihan minggu ini untuk melihat kelompok otot yang telah Anda latih.';

  @override
  String profileYearsOld(int age) {
    return '$age tahun';
  }

  @override
  String get profileProgramLevelBeginner => 'Pemula';

  @override
  String get profileProgramLevelIntermediate => 'Menengah';

  @override
  String get profileProgramLevelAdvanced => 'Mahir';

  @override
  String get profileOutcomeGoal => 'Tujuan Hasil';

  @override
  String get profileBehaviouralGoal => 'Tujuan Perilaku';

  @override
  String get profileEmergencyContacts => 'Kontak Darurat';

  @override
  String get profileLogOut => 'Keluar';

  @override
  String get profileLogOutConfirmTitle => 'Keluar';

  @override
  String get profileLogOutConfirmMessage => 'Apakah Anda yakin ingin keluar?';

  @override
  String get profileLogOutConfirmCancel => 'Batal';

  @override
  String get profileLogOutConfirmButton => 'Keluar';

  @override
  String get editProfileTitle => 'Edit Profil';

  @override
  String get editProfileFullName => 'Nama Lengkap';

  @override
  String get editProfileNameHint => 'Masukkan nama lengkap Anda';

  @override
  String get editProfileNameEmpty => 'Nama tidak boleh kosong';

  @override
  String get editProfileSave => 'Simpan';

  @override
  String get editProfileFailedToUpdate =>
      'Gagal memperbarui profil. Silakan coba lagi.';

  @override
  String get editProfilePhoneUpdated => 'Nomor telepon diperbarui';

  @override
  String get settingsVoiceCues => 'Isyarat Suara';

  @override
  String get settingsVoiceCuesSubtitle => 'Putar petunjuk audio selama latihan';

  @override
  String get settingsDailyReminderSubtitle =>
      'Terima pengingat harian untuk menyelesaikan latihan Anda';

  @override
  String get settingsAccount => 'Akun';

  @override
  String get settingsNotificationPermissionDeniedTitle =>
      'Izin Notifikasi Ditolak';

  @override
  String get settingsNotificationPermissionDeniedMessage =>
      'Izin notifikasi ditolak. Aktifkan notifikasi di pengaturan perangkat Anda untuk menerima pengingat.';

  @override
  String get sosNoEmergencyContacts => 'Tidak ada kontak darurat';

  @override
  String get sosAddContactsMessage =>
      'Tambahkan kontak darurat di profil Anda untuk menggunakan fitur ini.';

  @override
  String get sosCallingNotSupported =>
      'Panggilan tidak didukung di perangkat ini.';

  @override
  String get sosSafetyReminderFull =>
      'Jika Anda jatuh dan tidak bisa bangun, tetap tenang dan tetap di lantai sampai bantuan tiba. Hubungi layanan darurat atau kontak di bawah.';

  @override
  String get commonRetry => 'Coba Lagi';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Batal';

  @override
  String get commonConfirm => 'Konfirmasi';

  @override
  String get loadingDashboard => 'Memuat dasbor…';

  @override
  String get onboardingStep4Question =>
      'Apakah Anda menggunakan alat bantu jalan?';

  @override
  String get onboardingYes => 'Ya';

  @override
  String get onboardingNo => 'Tidak';

  @override
  String get onboardingStep1AgeLabel => 'Usia Anda';

  @override
  String get onboardingStep1AgeHint => 'Masukkan usia Anda';

  @override
  String get onboardingStep1AgeSuffix => 'tahun';

  @override
  String get onboardingStep1AgeRequired => 'Silakan masukkan usia Anda';

  @override
  String get onboardingStep1AgeRange => 'Usia harus antara 18 dan 120';

  @override
  String get onboardingStep1GenderLabel => 'Jenis Kelamin';

  @override
  String get onboardingStep1GenderMale => 'Laki-laki';

  @override
  String get onboardingStep1GenderFemale => 'Perempuan';

  @override
  String get onboardingStep1GenderOther => 'Lainnya';

  @override
  String get onboardingStep1GenderPreferNotToSay => 'Tidak ingin menyebutkan';

  @override
  String get onboardingStep2Question =>
      'Berapa kali Anda jatuh dalam 12 bulan terakhir?';

  @override
  String get onboardingStep2Hint => 'Masukkan jumlah jatuh';

  @override
  String get onboardingStep2Suffix => 'kali';

  @override
  String get onboardingStep2Required =>
      'Silakan masukkan jumlah jatuh (masukkan 0 jika tidak ada)';

  @override
  String get onboardingStep2Invalid =>
      'Silakan masukkan angka yang valid (0 atau lebih)';

  @override
  String get onboardingStep3Question =>
      'Apakah Anda memiliki kondisi kesehatan berikut?';

  @override
  String get onboardingStep3SelectAll => 'Pilih semua yang berlaku';

  @override
  String get onboardingStep3Musculoskeletal => 'Muskuloskeletal';

  @override
  String get onboardingStep3MusculoskeletalSub => 'Masalah sendi/tulang';

  @override
  String get onboardingStep3Circulatory => 'Sirkulasi';

  @override
  String get onboardingStep3CirculatorySub => 'Jantung/tekanan darah';

  @override
  String get onboardingStep3Respiratory => 'Pernapasan';

  @override
  String get onboardingStep3RespiratorySub => 'Masalah pernapasan';

  @override
  String get onboardingStep3Neurological => 'Neurologis';

  @override
  String get onboardingStep3NeurologicalSub => 'Kondisi saraf/otak';

  @override
  String get onboardingStep3Other => 'Lainnya';

  @override
  String get onboardingStep5Question => 'Seberapa khawatir Anda tentang jatuh?';

  @override
  String get onboardingStep5Level1 => 'Sama sekali tidak khawatir';

  @override
  String get onboardingStep5Level2 => 'Sedikit khawatir';

  @override
  String get onboardingStep5Level3 => 'Cukup khawatir';

  @override
  String get onboardingStep5Level4 => 'Sangat khawatir';

  @override
  String get onboardingStep5Level5 => 'Sangat amat khawatir';

  @override
  String get onboardingStep6TimeLabel => 'Waktu latihan yang disukai';

  @override
  String get onboardingStep6TimeHint => 'Pilih waktu';

  @override
  String get onboardingStep6DurationLabel => 'Durasi sesi';

  @override
  String get onboardingStep6DurationHint => 'Masukkan durasi';

  @override
  String get onboardingStep6DurationSuffix => 'menit';

  @override
  String get onboardingStep6DurationRequired => 'Silakan masukkan durasi sesi';

  @override
  String get onboardingStep6DurationRange =>
      'Durasi harus antara 10 dan 120 menit';

  @override
  String get onboardingStep6FrequencyLabel => 'Frekuensi mingguan';

  @override
  String get onboardingStep6FrequencyHint => 'Masukkan frekuensi';

  @override
  String get onboardingStep6FrequencySuffix => 'hari per minggu';

  @override
  String get onboardingStep6FrequencyRequired =>
      'Silakan masukkan frekuensi mingguan';

  @override
  String get onboardingStep6FrequencyRange =>
      'Frekuensi harus antara 1 dan 7 hari per minggu';

  @override
  String get onboardingStep7OutcomeLabel => 'Tujuan Hasil';

  @override
  String get onboardingStep7OutcomeHint =>
      'Apa yang ingin Anda capai? (mis., Berjalan ke pasar secara mandiri)';

  @override
  String get onboardingStep7OutcomeRequired =>
      'Silakan jelaskan apa yang ingin Anda capai';

  @override
  String get onboardingStep7BehaviouralLabel => 'Tujuan Perilaku';

  @override
  String get onboardingStep7BehaviouralHint =>
      'Latihan apa yang akan Anda lakukan dan kapan? (mis., Latihan setiap pagi)';

  @override
  String get onboardingStep7BehaviouralRequired =>
      'Silakan jelaskan rencana latihan Anda';

  @override
  String get authPhoneLabel => 'Nomor telepon';

  @override
  String get authPhoneHint => '08...';

  @override
  String get authPhoneInvalid =>
      'Masukkan nomor telepon minimal 10 digit (mis. 081234567890)';

  @override
  String get authPhoneAlreadyTaken => 'Nomor telepon ini sudah terdaftar';

  @override
  String get authInvalidCredentials => 'No HP atau kata sandi salah';

  @override
  String get authBiometricSemanticLabel => 'Masuk dengan biometrik';

  @override
  String get authBiometricUnavailable =>
      'Biometrik tidak tersedia di perangkat ini';

  @override
  String get authBiometricNotEnabled =>
      'Aktifkan login biometrik di menu Pengaturan setelah login';

  @override
  String get authBiometricReason => 'Verifikasi untuk masuk ke RehabPath';

  @override
  String get authBiometricSessionExpired =>
      'Sesi biometrik telah kedaluwarsa, silakan login ulang';

  @override
  String get authLegacyAccountNeedsPhone =>
      'Tambahkan nomor telepon ke akun Anda untuk tetap dapat masuk';

  @override
  String get authBiometricFailed => 'Verifikasi biometrik gagal';

  @override
  String get authLegacyAccountAddPhoneCta => 'Tambahkan nomor telepon';

  @override
  String get exerciseListAllExercises => 'Semua Latihan';

  @override
  String get exerciseListTodayExercises => 'Latihan Hari Ini';

  @override
  String get exerciseListNoneToday => 'Tidak ada latihan hari ini';

  @override
  String get exerciseListAllDoneToday => 'Semua latihan hari ini selesai';

  @override
  String get dashboardDateSelectorPrev => 'Minggu sebelumnya';

  @override
  String get dashboardDateSelectorNext => 'Minggu berikutnya';

  @override
  String dashboardViewingDate(String date) {
    return 'Melihat: $date';
  }

  @override
  String get dashboardBackToToday => 'Kembali ke Hari Ini';

  @override
  String get dashboardStartOnlyToday => 'Hanya tersedia di hari berjalan';

  @override
  String get dashboardNotYetStarted => 'Belum berlangsung';

  @override
  String get settingsBiometricToggle => 'Login biometrik';

  @override
  String get settingsBiometricEnableTitle => 'Aktifkan login biometrik';

  @override
  String get settingsBiometricVerifyPassword =>
      'Masukkan ulang kata sandi untuk konfirmasi';

  @override
  String get settingsBiometricEnableFailed =>
      'Gagal mengaktifkan login biometrik';

  @override
  String get dashboardBiometricPromptTitle => 'Aktifkan login biometrik?';

  @override
  String get dashboardBiometricPromptMessage =>
      'Masuk lebih cepat lain kali dengan sidik jari atau wajah Anda. Anda dapat mengaktifkannya dari menu Pengaturan.';

  @override
  String get dashboardBiometricPromptDontShowAgain => 'Jangan tampilkan lagi';

  @override
  String get dashboardBiometricPromptConfirm => 'Buka Pengaturan';

  @override
  String get authBiometricSimpleTitle => 'Selamat datang kembali';

  @override
  String get authBiometricSimpleSubtitle =>
      'Ketuk ikon di bawah untuk masuk dengan biometrik';

  @override
  String get authUsePasswordInstead => 'Gunakan kata sandi';

  @override
  String get commonLoading => 'Memuat…';
}
