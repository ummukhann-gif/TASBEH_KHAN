enum AppLanguage {
  english('English'),
  uzbek("O'zbekcha"),
  russian('Русский');

  const AppLanguage(this.label);

  final String label;
}

class AppStrings {
  const AppStrings(this.language);

  final AppLanguage language;

  String get appTitle => 'Terra Tasbih';
  String get counter => _pick('Counter', 'Counter', 'Счётчик');
  String get dhikr => _pick('Dhikr', 'Zikr', 'Зикр');
  String get stats => _pick('Stats', 'Statistika', 'Статистика');
  String get settings => _pick('Settings', 'Sozlamalar', 'Настройки');
  String get currentDhikr =>
      _pick('Current Dhikr', 'Joriy zikr', 'Текущий зикр');
  String get quickSelection =>
      _pick('Quick Selection', 'Tez tanlash', 'Быстрый выбор');
  String get tap => _pick('Tap', 'Bos', 'Нажми');
  String get reset => _pick('Reset', 'Tozalash', 'Сброс');
  String get sound => _pick('Sound', 'Ovoz', 'Звук');
  String get haptic => _pick('Haptic', 'Vibratsiya', 'Вибрация');
  String get target => _pick('Target', 'Maqsad', 'Цель');
  String get sessionGoal =>
      _pick('Session Goal', 'Sessiya maqsadi', 'Цель сессии');
  String get defaultGoal => _pick('Default', 'Standart', 'По умолчанию');
  String get customGoal => _pick('Custom target', 'Boshqa son', 'Своя цель');
  String get infinity => _pick('Infinity', 'Cheksiz', 'Бесконечно');
  String get dailyGoalReached => _pick(
    'Daily Goal Reached',
    'Kunlik maqsad bajarildi',
    'Дневная цель достигнута',
  );
  String get todayFocus =>
      _pick('Today Focus', 'Bugungi amaliyot', 'Сегодняшняя практика');
  String get totalDhikr => _pick('Total Dhikr', 'Jami zikr', 'Всего зикров');
  String get currentStreak =>
      _pick('Current Streak', 'Joriy streak', 'Текущая серия');
  String get timeSpent =>
      _pick('Time Spent', 'Sarflangan vaqt', 'Потрачено времени');
  String get weeklyProgress =>
      _pick('Weekly Progress', 'Haftalik progress', 'Недельный прогресс');
  String get dailyDhikrCount => _pick(
    'Daily dhikr count activity',
    'Kunlik zikr faolligi',
    'Дневная активность зикра',
  );
  String get last7Days =>
      _pick('Last 7 Days', 'Oxirgi 7 kun', 'Последние 7 дней');
  String get pastSessions =>
      _pick('Past Sessions', 'O‘tgan sessiyalar', 'Прошлые сессии');
  String get viewAll => _pick('View All', 'Barchasi', 'Все');
  String get buildHabit =>
      _pick('Build your habit', 'Odatni mustahkamlang', 'Развивайте привычку');
  String get buildHabitBody => _pick(
    'Consistency is the key to inner peace. Keep going!',
    'Barqarorlik ichki xotirjamlikka olib boradi. Davom eting.',
    'Постоянство помогает обрести внутренний покой. Продолжайте.',
  );
  String get completed => _pick('Completed', 'Bajarildi', 'Завершено');
  String get saved => _pick('Saved', 'Saqlangan', 'Сохранено');
  String get dailyDhikrTitle =>
      _pick('Daily Dhikr', 'Kunlik zikr', 'Ежедневный зикр');
  String get selectRemembrance => _pick(
    'Select a remembrance to begin your session',
    'Sessiyani boshlash uchun zikr tanlang',
    'Выберите зикр, чтобы начать сессию',
  );
  String get select => _pick('Select', 'Tanlash', 'Выбрать');
  String get addDhikr =>
      _pick('Add Dhikr', "Yangi zikr qo'shish", 'Добавить зикр');
  String get cancel => _pick('Cancel', 'Bekor qilish', 'Отмена');
  String get save => _pick('Save', 'Saqlash', 'Сохранить');
  String get newDhikrTitle =>
      _pick('Add New Dhikr', "Yangi zikr qo'shish", 'Новый зикр');
  String get newDhikrBody => _pick(
    'Enter your dhikr details and set the target.',
    "Yangi zikr ma'lumotlarini kiriting va maqsadni belgilang.",
    'Введите данные зикра и выберите цель.',
  );
  String get dhikrName => _pick('Dhikr Name', 'Dhikr nomi', 'Название зикра');
  String get arabicText =>
      _pick('Arabic Text', 'Arabcha matni', 'Арабский текст');
  String get optional => _pick('(Optional)', '(Ixtiyoriy)', '(Необязательно)');
  String get targetCount =>
      _pick('Target Count', 'Maqsadli soni', 'Количество цели');
  String get enterCustomTarget =>
      _pick('Enter custom target (e.g. 100)', 'Masalan: 100', 'Например: 100');
  String get maximumValue => _pick(
    'Maximum value: 9,999',
    'Maksimal qiymat: 9 999',
    'Максимум: 9 999',
  );
  String get infoHint => _pick(
    'Each dhikr keeps its own history. You can view daily progress and total count in Stats.',
    "Har bir zikr o‘z tarixiga ega bo‘ladi. Siz kunlik progress va jami miqdorni Statistikada ko‘rasiz.",
    'У каждого зикра своя история. Ежедневный прогресс и общий счёт можно посмотреть в статистике.',
  );
  String get textAppearance =>
      _pick('Text Appearance', 'Matn ko‘rinishi', 'Размер текста');
  String get appLanguage =>
      _pick('App Language', 'Ilova tili', 'Язык приложения');
  String get appTheme => _pick('App Theme', 'Ilova mavzusi', 'Тема приложения');
  String get darkMode => _pick('Dark Mode', 'Tungi rejim', 'Тёмный режим');
  String get hapticDesc => _pick(
    'Vibrate on count',
    'Har sanashda vibratsiya',
    'Вибрация при нажатии',
  );
  String get soundDesc =>
      _pick('Audible feedback', 'Tovushli feedback', 'Звуковая отдача');
  String get defaultTextSize => _pick('Default', 'Standart', 'Обычный');
  String get largerTextSize => _pick('Larger', 'Kattaroq', 'Крупнее');
  String get resetAllProgress => _pick(
    'Reset All Session Progress',
    'Barcha session progressini tozalash',
    'Сбросить весь прогресс сессий',
  );
  String get confirmResetTitle =>
      _pick('Reset progress?', 'Progress tozalansinmi?', 'Сбросить прогресс?');
  String get confirmResetBody => _pick(
    'This clears every saved session and custom goal.',
    'Bu barcha saqlangan sessiyalar va custom targetlarni o‘chiradi.',
    'Это удалит все сохранённые сессии и пользовательские цели.',
  );
  String get today => _pick('Today', 'Bugun', 'Сегодня');
  String get yesterday => _pick('Yesterday', 'Kecha', 'Вчера');
  String get sessions => _pick('sessions', 'sessiya', 'сессий');
  String get minutes => _pick('min', 'daq', 'мин');
  String get days => _pick('days', 'kun', 'дней');
  String get hours => _pick('hrs', 'soat', 'ч');
  String get noSessionsYet => _pick(
    'Your completed dhikr sessions will appear here.',
    'Yakunlangan zikr sessiyalari shu yerda chiqadi.',
    'Завершённые сессии появятся здесь.',
  );
  String get current => _pick('Current', 'Joriy', 'Текущий');
  String get savedSuccessfully =>
      _pick('Dhikr saved', 'Zikr saqlandi', 'Зикр сохранён');
  String get sessionComplete =>
      _pick('Session completed', 'Sessiya tugadi', 'Сессия завершена');
  String get enterNameError => _pick(
    'Please enter a dhikr name.',
    'Dhikr nomini kiriting.',
    'Введите название зикра.',
  );
  String get enterTargetError => _pick(
    'Please enter a valid target.',
    'Yaroqli target kiriting.',
    'Введите корректную цель.',
  );

  String sessionSummary(int sessionCount, int minuteCount) {
    return switch (language) {
      AppLanguage.english => '$sessionCount sessions • $minuteCount min total',
      AppLanguage.uzbek => '$sessionCount sessiya • jami $minuteCount daqiqa',
      AppLanguage.russian => '$sessionCount сессий • всего $minuteCount мин',
    };
  }

  String weekChangeText(int percent) {
    return switch (language) {
      AppLanguage.english => '$percent% more than last week',
      AppLanguage.uzbek => "O‘tgan haftadan $percent% ko‘p",
      AppLanguage.russian => 'На $percent% больше прошлой недели',
    };
  }

  String relativeDate(String label, String time) => '$label • $time';

  String _pick(String english, String uzbek, String russian) {
    return switch (language) {
      AppLanguage.english => english,
      AppLanguage.uzbek => uzbek,
      AppLanguage.russian => russian,
    };
  }
}
