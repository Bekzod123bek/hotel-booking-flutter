// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Бронирование отелей';

  @override
  String get languageName => 'Русский';

  @override
  String get navExplore => 'Обзор';

  @override
  String get navFavorites => 'Избранное';

  @override
  String get navBookings => 'Брони';

  @override
  String get navProfile => 'Профиль';

  @override
  String get onb1Title => 'Найдите, где остановиться';

  @override
  String get onb1Text =>
      'Отобранные отели в Ташкенте, Самарканде, Бухаре, Хиве и других городах.';

  @override
  String get onb2Title => 'Сравнивайте и выбирайте';

  @override
  String get onb2Text =>
      'Фильтруйте по цене, рейтингу и удобствам, читайте отзывы гостей.';

  @override
  String get onb3Title => 'Бронируйте в пару касаний';

  @override
  String get onb3Text =>
      'Выберите даты и номер — все брони будут в одном месте.';

  @override
  String get skip => 'Пропустить';

  @override
  String get next => 'Далее';

  @override
  String get getStarted => 'Начать';

  @override
  String get welcomeBack => 'С возвращением';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get signInSubtitle => 'Войдите, чтобы продолжить планировать поездку.';

  @override
  String get signUpSubtitle =>
      'Зарегистрируйтесь, чтобы сохранять избранное и брони.';

  @override
  String get signIn => 'Войти';

  @override
  String get signUp => 'Регистрация';

  @override
  String get fullName => 'Имя и фамилия';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get showPassword => 'Показать пароль';

  @override
  String get hidePassword => 'Скрыть пароль';

  @override
  String get enterName => 'Введите имя';

  @override
  String get enterValidEmail => 'Введите корректный email';

  @override
  String passwordMin(int count) {
    return 'Не менее $count символов';
  }

  @override
  String get demoNote => 'Демо-режим: данные не покидают ваше устройство.';

  @override
  String get cloudNote => 'Ваш аккаунт и брони надёжно хранятся в облаке.';

  @override
  String get errInvalidCredentials => 'Неверный email или пароль.';

  @override
  String get errEmailInUse => 'Аккаунт с таким email уже существует.';

  @override
  String get errWeakPassword => 'Слишком простой пароль.';

  @override
  String get errNetwork => 'Нет интернета. Попробуйте ещё раз.';

  @override
  String get errTooMany => 'Слишком много попыток. Повторите позже.';

  @override
  String get errGeneric => 'Что-то пошло не так. Попробуйте ещё раз.';

  @override
  String helloUser(String name) {
    return 'Привет, $name 👋';
  }

  @override
  String get traveller => 'путешественник';

  @override
  String get whereNext => 'Куда отправимся?';

  @override
  String get searchHint => 'Поиск отеля или города';

  @override
  String get clearSearch => 'Очистить поиск';

  @override
  String get filters => 'Фильтры';

  @override
  String get all => 'Все';

  @override
  String get featuredStays => 'Рекомендуемые';

  @override
  String get popularHotels => 'Популярные отели';

  @override
  String staysFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Найдено $count места',
      many: 'Найдено $count мест',
      few: 'Найдено $count места',
      one: 'Найдено $count место',
    );
    return '$_temp0';
  }

  @override
  String get noHotelsTitle => 'Отели не найдены';

  @override
  String get noHotelsMessage => 'Попробуйте другой город или смягчите фильтры.';

  @override
  String get clearAllFilters => 'Сбросить фильтры';

  @override
  String get sort => 'Сортировка';

  @override
  String get loadFailed => 'Не удалось загрузить отели.';

  @override
  String get retry => 'Повторить';

  @override
  String get sortNearest => 'Сначала ближайшие';

  @override
  String get nearMe => 'Рядом со мной';

  @override
  String get findingLocation => 'Определяем ваше местоположение…';

  @override
  String distanceKm(String km) {
    return '$km км от вас';
  }

  @override
  String distanceM(int m) {
    return '$m м от вас';
  }

  @override
  String get locationDenied =>
      'Доступ к геолокации не разрешён, поэтому сортировка по расстоянию недоступна.';

  @override
  String get locationDeniedForever =>
      'Геолокация запрещена для приложения. Разрешить её можно в настройках.';

  @override
  String get locationServiceOff => 'Геолокация выключена на устройстве.';

  @override
  String get locationUnavailable =>
      'Не удалось определить местоположение. Попробуйте ещё раз.';

  @override
  String get openSettings => 'Настройки';

  @override
  String get mapView => 'Карта';

  @override
  String get listView => 'Список';

  @override
  String get hotelsOnMap => 'Отели на карте';

  @override
  String get youAreHere => 'Вы здесь';

  @override
  String get sampleDataNote =>
      'Примерные данные: отели и их расположение вымышлены.';

  @override
  String get sortRecommended => 'Рекомендуемые';

  @override
  String get sortPriceLow => 'Цена: по возрастанию';

  @override
  String get sortPriceHigh => 'Цена: по убыванию';

  @override
  String get sortRating => 'С высоким рейтингом';

  @override
  String get filtersTitle => 'Фильтры';

  @override
  String get reset => 'Сбросить';

  @override
  String get sortBy => 'Сортировать';

  @override
  String priceRange(int min, int max, String plus) {
    return 'Цена за ночь: \$$min – \$$max$plus';
  }

  @override
  String get minimumRating => 'Минимальный рейтинг';

  @override
  String get any => 'Любой';

  @override
  String get amenities => 'Удобства';

  @override
  String get showResults => 'Показать результаты';

  @override
  String get amenityWifi => 'Wi-Fi';

  @override
  String get amenityBreakfast => 'Завтрак';

  @override
  String get amenityPool => 'Бассейн';

  @override
  String get amenitySpa => 'Спа';

  @override
  String get amenityGym => 'Спортзал';

  @override
  String get amenityParking => 'Парковка';

  @override
  String get amenityRestaurant => 'Ресторан';

  @override
  String get amenityAirConditioning => 'Кондиционер';

  @override
  String get addToFavorites => 'Добавить в избранное';

  @override
  String get removeFromFavorites => 'Убрать из избранного';

  @override
  String addedToFavorites(String name) {
    return '$name добавлен в избранное';
  }

  @override
  String removedFromFavorites(String name) {
    return '$name убран из избранного';
  }

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count отзыва',
      many: '$count отзывов',
      few: '$count отзыва',
      one: '$count отзыв',
    );
    return '$_temp0';
  }

  @override
  String get perNight => ' /ночь';

  @override
  String get back => 'Назад';

  @override
  String get about => 'Описание';

  @override
  String get showLess => 'Свернуть';

  @override
  String get readMore => 'Читать далее';

  @override
  String get location => 'Расположение';

  @override
  String get reviews => 'Отзывы';

  @override
  String get openInMaps => 'Открыть в картах';

  @override
  String get mapUnavailable => 'Не удалось открыть приложение карт.';

  @override
  String get from => 'От';

  @override
  String get share => 'Поделиться';

  @override
  String get bookNow => 'Забронировать';

  @override
  String get copied => 'Данные отеля скопированы';

  @override
  String get selectRoom => 'Выбрать номер';

  @override
  String get bookYourStay => 'Бронирование';

  @override
  String get roomType => 'Тип номера';

  @override
  String get roomStandard => 'Стандарт';

  @override
  String get roomStandardDesc => 'Двуспальная кровать, вид на город';

  @override
  String get roomDeluxe => 'Делюкс';

  @override
  String get roomDeluxeDesc => 'Большая кровать, балкон, завтрак';

  @override
  String get roomSuite => 'Люкс';

  @override
  String get roomSuiteDesc => 'Отдельная гостиная, лучший вид';

  @override
  String get dates => 'Даты';

  @override
  String get checkIn => 'Заезд';

  @override
  String get checkOut => 'Выезд';

  @override
  String get addDate => 'Выберите дату';

  @override
  String get selectYourStay => 'Выберите даты проживания';

  @override
  String get done => 'Готово';

  @override
  String get guests => 'Гости';

  @override
  String guestsUpTo(int max, String room) {
    return 'До $max гостей в номере «$room»';
  }

  @override
  String get fewerGuests => 'Меньше гостей';

  @override
  String get moreGuests => 'Больше гостей';

  @override
  String nightsPrice(int rate, int nights) {
    String _temp0 = intl.Intl.pluralLogic(
      nights,
      locale: localeName,
      other: '$nights ночи',
      many: '$nights ночей',
      few: '$nights ночи',
      one: '$nights ночь',
    );
    return '\$$rate × $_temp0';
  }

  @override
  String serviceFee(int percent) {
    return 'Сервисный сбор ($percent%)';
  }

  @override
  String get total => 'Итого';

  @override
  String confirmAndBook(int total) {
    return 'Подтвердить и забронировать  •  \$$total';
  }

  @override
  String get selectDatesToContinue => 'Выберите даты, чтобы продолжить';

  @override
  String get guestDetails => 'Данные гостя';

  @override
  String get guestName => 'Имя гостя';

  @override
  String get guestPhone => 'Номер телефона';

  @override
  String get enterPhone => 'Введите корректный номер телефона';

  @override
  String get paymentMethod => 'Оплата';

  @override
  String get payAtHotel => 'Оплата в отеле';

  @override
  String get payAtHotelDesc => 'Сейчас платить не нужно. Оплата при заселении.';

  @override
  String get payOnline => 'Онлайн-оплата (демо)';

  @override
  String get payOnlineDesc => 'Имитация оплаты. Деньги не списываются.';

  @override
  String get processingPayment => 'Обработка платежа…';

  @override
  String get bookingConfirmed => 'Бронь подтверждена';

  @override
  String bookingCode(String code) {
    return 'Код брони: $code';
  }

  @override
  String get great => 'Отлично';

  @override
  String get findInBookings => 'Её можно найти во вкладке «Брони»';

  @override
  String notAvailable(String room) {
    return 'На эти даты не осталось свободных номеров «$room». Выберите другие даты или тип номера.';
  }

  @override
  String maxStay(int count) {
    return 'За один раз можно забронировать не более $count ночей.';
  }

  @override
  String get alreadyBooked => 'У вас уже есть бронь в этом отеле на эти даты.';

  @override
  String get bookingFailed =>
      'Не удалось завершить бронирование. Попробуйте ещё раз.';

  @override
  String get myBookings => 'Мои брони';

  @override
  String get noTripsTitle => 'Пока нет броней';

  @override
  String get noTripsMessage => 'Забронированные отели появятся здесь.';

  @override
  String get cancelBookingQ => 'Отменить бронь?';

  @override
  String cancelBody(String hotel) {
    return 'Бронь в отеле $hotel будет отменена.';
  }

  @override
  String get keep => 'Оставить';

  @override
  String get cancelBooking => 'Отменить бронь';

  @override
  String bookingCancelled(String hotel) {
    return 'Бронь в отеле $hotel отменена';
  }

  @override
  String get upcoming => 'Предстоит';

  @override
  String get confirmed => 'Подтверждена';

  @override
  String nightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ночи',
      many: '$count ночей',
      few: '$count ночи',
      one: '$count ночь',
    );
    return '$_temp0';
  }

  @override
  String roomWithName(String room) {
    return 'Номер «$room»';
  }

  @override
  String guestsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count гостя',
      many: '$count гостей',
      few: '$count гостя',
      one: '$count гость',
    );
    return '$_temp0';
  }

  @override
  String totalAmount(int total) {
    return 'Итого \$$total';
  }

  @override
  String codeLabel(String code) {
    return 'Код $code';
  }

  @override
  String get noFavoritesTitle => 'В избранном пока пусто';

  @override
  String get noFavoritesMessage =>
      'Нажмите на сердечко у отеля, чтобы сохранить его здесь.';

  @override
  String get darkMode => 'Тёмная тема';

  @override
  String get language => 'Язык';

  @override
  String get aboutApp => 'О приложении';

  @override
  String get aboutBody =>
      'Портфолио-проект на Flutter, Cubit, get_it, Firebase и Clean Architecture. Отели — примерные данные, фото с Unsplash.';

  @override
  String get logOut => 'Выйти';

  @override
  String get logOutQ => 'Выйти из аккаунта?';

  @override
  String get logOutBody => 'Вы сможете войти снова в любой момент.';

  @override
  String get cancel => 'Отмена';

  @override
  String get guest => 'Гость';
}
