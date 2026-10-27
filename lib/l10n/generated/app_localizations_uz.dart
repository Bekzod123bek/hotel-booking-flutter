// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appTitle => 'Mehmonxona bron';

  @override
  String get languageName => 'O\'zbekcha';

  @override
  String get navExplore => 'Kashf etish';

  @override
  String get navFavorites => 'Sevimlilar';

  @override
  String get navBookings => 'Bronlar';

  @override
  String get navProfile => 'Profil';

  @override
  String get onb1Title => 'Qolish uchun joy toping';

  @override
  String get onb1Text =>
      'Toshkent, Samarqand, Buxoro, Xiva va boshqa shaharlardagi saralangan mehmonxonalar.';

  @override
  String get onb2Title => 'Solishtiring va tanlang';

  @override
  String get onb2Text =>
      'Narx, reyting va qulayliklar bo\'yicha saralang, mehmonlar sharhlarini o\'qing.';

  @override
  String get onb3Title => 'Bir necha bosishda bron qiling';

  @override
  String get onb3Text =>
      'Sana va xonani tanlang, barcha bronlaringiz bir joyda saqlanadi.';

  @override
  String get skip => 'O\'tkazib yuborish';

  @override
  String get next => 'Keyingi';

  @override
  String get getStarted => 'Boshlash';

  @override
  String get welcomeBack => 'Qaytganingiz bilan';

  @override
  String get createAccount => 'Hisob yaratish';

  @override
  String get signInSubtitle =>
      'Sayohatingizni rejalashtirishda davom etish uchun kiring.';

  @override
  String get signUpSubtitle =>
      'Sevimlilar va bronlarni saqlash uchun ro\'yxatdan o\'ting.';

  @override
  String get signIn => 'Kirish';

  @override
  String get signUp => 'Ro\'yxatdan o\'tish';

  @override
  String get fullName => 'Ism va familiya';

  @override
  String get email => 'Email';

  @override
  String get password => 'Parol';

  @override
  String get showPassword => 'Parolni ko\'rsatish';

  @override
  String get hidePassword => 'Parolni yashirish';

  @override
  String get enterName => 'Ismingizni kiriting';

  @override
  String get enterValidEmail => 'To\'g\'ri email kiriting';

  @override
  String passwordMin(int count) {
    return 'Kamida $count ta belgi';
  }

  @override
  String get demoNote => 'Demo rejim: ma\'lumotlar qurilmangizdan chiqmaydi.';

  @override
  String get cloudNote =>
      'Hisobingiz va bronlaringiz bulutda xavfsiz saqlanadi.';

  @override
  String get errInvalidCredentials => 'Email yoki parol noto\'g\'ri.';

  @override
  String get errEmailInUse => 'Bu email bilan hisob allaqachon mavjud.';

  @override
  String get errWeakPassword => 'Parol juda oddiy.';

  @override
  String get errNetwork => 'Internet yo\'q. Qayta urinib ko\'ring.';

  @override
  String get errTooMany =>
      'Urinishlar ko\'p bo\'ldi. Keyinroq urinib ko\'ring.';

  @override
  String get errGeneric => 'Xatolik yuz berdi. Qayta urinib ko\'ring.';

  @override
  String helloUser(String name) {
    return 'Salom, $name 👋';
  }

  @override
  String get traveller => 'sayyoh';

  @override
  String get whereNext => 'Keyingi manzil qayer?';

  @override
  String get searchHint => 'Mehmonxona yoki shahar';

  @override
  String get clearSearch => 'Qidiruvni tozalash';

  @override
  String get filters => 'Filtrlar';

  @override
  String get all => 'Hammasi';

  @override
  String get featuredStays => 'Tavsiya etilgan joylar';

  @override
  String get popularHotels => 'Mashhur mehmonxonalar';

  @override
  String staysFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta joy topildi',
      one: '1 ta joy topildi',
    );
    return '$_temp0';
  }

  @override
  String get noHotelsTitle => 'Mehmonxona topilmadi';

  @override
  String get noHotelsMessage =>
      'Boshqa shaharni sinab ko\'ring yoki filtrlarni yumshating.';

  @override
  String get clearAllFilters => 'Filtrlarni tozalash';

  @override
  String get sort => 'Saralash';

  @override
  String get loadFailed => 'Mehmonxonalarni yuklab bo\'lmadi.';

  @override
  String get retry => 'Qayta urinish';

  @override
  String get sortNearest => 'Eng yaqin';

  @override
  String get nearMe => 'Menga yaqin';

  @override
  String get findingLocation => 'Joylashuvingiz aniqlanmoqda…';

  @override
  String distanceKm(String km) {
    return '$km km uzoqlikda';
  }

  @override
  String distanceM(int m) {
    return '$m m uzoqlikda';
  }

  @override
  String get locationDenied =>
      'Joylashuvga ruxsat berilmadi, shuning uchun masofa bo\'yicha saralab bo\'lmaydi.';

  @override
  String get locationDeniedForever =>
      'Joylashuv bu ilova uchun taqiqlangan. Sozlamalardan ruxsat berishingiz mumkin.';

  @override
  String get locationServiceOff => 'Qurilmada joylashuv o\'chirilgan.';

  @override
  String get locationUnavailable =>
      'Joylashuvni aniqlab bo\'lmadi. Qayta urinib ko\'ring.';

  @override
  String get openSettings => 'Sozlamalar';

  @override
  String get mapView => 'Xarita';

  @override
  String get listView => 'Ro\'yxat';

  @override
  String get hotelsOnMap => 'Xaritadagi mehmonxonalar';

  @override
  String get youAreHere => 'Siz shu yerdasiz';

  @override
  String get sampleDataNote =>
      'Namunaviy ma\'lumot: mehmonxonalar va ularning joylari haqiqiy emas.';

  @override
  String get sortRecommended => 'Tavsiya etilgan';

  @override
  String get sortPriceLow => 'Narx: arzondan qimmatga';

  @override
  String get sortPriceHigh => 'Narx: qimmatdan arzonga';

  @override
  String get sortRating => 'Eng yuqori reyting';

  @override
  String get filtersTitle => 'Filtrlar';

  @override
  String get reset => 'Tozalash';

  @override
  String get sortBy => 'Saralash';

  @override
  String priceRange(int min, int max, String plus) {
    return 'Bir kecha narxi: \$$min – \$$max$plus';
  }

  @override
  String get minimumRating => 'Minimal reyting';

  @override
  String get any => 'Farqi yo\'q';

  @override
  String get amenities => 'Qulayliklar';

  @override
  String get showResults => 'Natijalarni ko\'rsatish';

  @override
  String get amenityWifi => 'Wi-Fi';

  @override
  String get amenityBreakfast => 'Nonushta';

  @override
  String get amenityPool => 'Basseyn';

  @override
  String get amenitySpa => 'Spa';

  @override
  String get amenityGym => 'Sport zal';

  @override
  String get amenityParking => 'Avtoturargoh';

  @override
  String get amenityRestaurant => 'Restoran';

  @override
  String get amenityAirConditioning => 'Konditsioner';

  @override
  String get addToFavorites => 'Sevimlilarga qo\'shish';

  @override
  String get removeFromFavorites => 'Sevimlilardan olib tashlash';

  @override
  String addedToFavorites(String name) {
    return '$name sevimlilarga qo\'shildi';
  }

  @override
  String removedFromFavorites(String name) {
    return '$name sevimlilardan olib tashlandi';
  }

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta sharh',
      one: '1 ta sharh',
    );
    return '$_temp0';
  }

  @override
  String get perNight => ' /kecha';

  @override
  String get back => 'Orqaga';

  @override
  String get about => 'Tavsif';

  @override
  String get showLess => 'Kamroq ko\'rsatish';

  @override
  String get readMore => 'Batafsil';

  @override
  String get location => 'Joylashuv';

  @override
  String get reviews => 'Sharhlar';

  @override
  String get openInMaps => 'Xaritada ochish';

  @override
  String get mapUnavailable => 'Xarita ilovasini ochib bo\'lmadi.';

  @override
  String get from => 'Narxi';

  @override
  String get share => 'Ulashish';

  @override
  String get bookNow => 'Bron qilish';

  @override
  String get copied => 'Mehmonxona ma\'lumoti nusxalandi';

  @override
  String get selectRoom => 'Xonani tanlash';

  @override
  String get bookYourStay => 'Bron qilish';

  @override
  String get roomType => 'Xona turi';

  @override
  String get roomStandard => 'Standart';

  @override
  String get roomStandardDesc => 'Ikki kishilik karavot, shahar manzarasi';

  @override
  String get roomDeluxe => 'Deluxe';

  @override
  String get roomDeluxeDesc => 'Katta karavot, balkon, nonushta';

  @override
  String get roomSuite => 'Lyuks';

  @override
  String get roomSuiteDesc => 'Alohida mehmon xonasi, eng yaxshi manzara';

  @override
  String get dates => 'Sanalar';

  @override
  String get checkIn => 'Kelish';

  @override
  String get checkOut => 'Ketish';

  @override
  String get addDate => 'Sanani tanlang';

  @override
  String get selectYourStay => 'Turar joy sanalarini tanlang';

  @override
  String get done => 'Tayyor';

  @override
  String get guests => 'Mehmonlar';

  @override
  String guestsUpTo(int max, String room) {
    return '$room xonada $max kishigacha';
  }

  @override
  String get fewerGuests => 'Mehmonni kamaytirish';

  @override
  String get moreGuests => 'Mehmonni ko\'paytirish';

  @override
  String nightsPrice(int rate, int nights) {
    String _temp0 = intl.Intl.pluralLogic(
      nights,
      locale: localeName,
      other: '$nights kecha',
      one: '1 kecha',
    );
    return '\$$rate × $_temp0';
  }

  @override
  String serviceFee(int percent) {
    return 'Xizmat haqi ($percent%)';
  }

  @override
  String get total => 'Jami';

  @override
  String confirmAndBook(int total) {
    return 'Tasdiqlash va bron qilish  •  \$$total';
  }

  @override
  String get selectDatesToContinue => 'Davom etish uchun sanalarni tanlang';

  @override
  String get guestDetails => 'Mehmon ma\'lumotlari';

  @override
  String get guestName => 'Mehmon ismi';

  @override
  String get guestPhone => 'Telefon raqami';

  @override
  String get enterPhone => 'To\'g\'ri telefon raqamini kiriting';

  @override
  String get paymentMethod => 'To\'lov';

  @override
  String get payAtHotel => 'Mehmonxonada to\'lash';

  @override
  String get payAtHotelDesc => 'Hozir to\'lov yo\'q. Kelganingizda to\'laysiz.';

  @override
  String get payOnline => 'Onlayn to\'lov (demo)';

  @override
  String get payOnlineDesc => 'Sinov to\'lovi. Pul yechilmaydi.';

  @override
  String get processingPayment => 'To\'lov amalga oshirilmoqda…';

  @override
  String get bookingConfirmed => 'Bron tasdiqlandi';

  @override
  String bookingCode(String code) {
    return 'Bron kodi: $code';
  }

  @override
  String get great => 'Ajoyib';

  @override
  String get findInBookings => 'Uni «Bronlar» bo\'limida topasiz';

  @override
  String notAvailable(String room) {
    return 'Bu sanalarga bo\'sh «$room» xona qolmadi. Boshqa sana yoki xona turini tanlang.';
  }

  @override
  String maxStay(int count) {
    return 'Bir marta ko\'pi bilan $count kecha bron qilish mumkin.';
  }

  @override
  String get alreadyBooked =>
      'Siz bu mehmonxonada shu sanalarga allaqachon bron qilgansiz.';

  @override
  String get bookingFailed =>
      'Bronni yakunlab bo\'lmadi. Qayta urinib ko\'ring.';

  @override
  String get myBookings => 'Mening bronlarim';

  @override
  String get noTripsTitle => 'Hozircha bron yo\'q';

  @override
  String get noTripsMessage =>
      'Mehmonxona bron qilsangiz, u shu yerda ko\'rinadi.';

  @override
  String get cancelBookingQ => 'Bronni bekor qilasizmi?';

  @override
  String cancelBody(String hotel) {
    return '$hotel mehmonxonasidagi bron bekor qilinadi.';
  }

  @override
  String get keep => 'Qoldirish';

  @override
  String get cancelBooking => 'Bronni bekor qilish';

  @override
  String bookingCancelled(String hotel) {
    return '$hotel mehmonxonasidagi bron bekor qilindi';
  }

  @override
  String get upcoming => 'Kutilmoqda';

  @override
  String get confirmed => 'Tasdiqlangan';

  @override
  String nightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kecha',
      one: '1 kecha',
    );
    return '$_temp0';
  }

  @override
  String roomWithName(String room) {
    return '$room xona';
  }

  @override
  String guestsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mehmon',
      one: '1 mehmon',
    );
    return '$_temp0';
  }

  @override
  String totalAmount(int total) {
    return 'Jami \$$total';
  }

  @override
  String codeLabel(String code) {
    return 'Kod $code';
  }

  @override
  String get noFavoritesTitle => 'Sevimlilar hali yo\'q';

  @override
  String get noFavoritesMessage =>
      'Saqlash uchun mehmonxonadagi yurakchani bosing.';

  @override
  String get darkMode => 'Tungi rejim';

  @override
  String get language => 'Til';

  @override
  String get aboutApp => 'Ilova haqida';

  @override
  String get aboutBody =>
      'Flutter, Cubit, get_it, Firebase va Clean Architecture bilan yaratilgan portfolio loyiha. Mehmonxonalar namunaviy, rasmlar Unsplash\'dan olingan.';

  @override
  String get logOut => 'Chiqish';

  @override
  String get logOutQ => 'Hisobdan chiqasizmi?';

  @override
  String get logOutBody => 'Istalgan vaqt qayta kirishingiz mumkin.';

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get guest => 'Mehmon';
}
