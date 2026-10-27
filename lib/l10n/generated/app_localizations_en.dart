// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hotel Booking';

  @override
  String get languageName => 'English';

  @override
  String get navExplore => 'Explore';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navBookings => 'Bookings';

  @override
  String get navProfile => 'Profile';

  @override
  String get onb1Title => 'Discover places to stay';

  @override
  String get onb1Text =>
      'Hand-picked hotels in Tashkent, Samarkand, Bukhara, Khiva and beyond.';

  @override
  String get onb2Title => 'Compare and choose';

  @override
  String get onb2Text =>
      'Filter by price, rating and amenities and see real guest reviews.';

  @override
  String get onb3Title => 'Book in a few taps';

  @override
  String get onb3Text =>
      'Pick your dates and room, and keep every booking in one place.';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get started';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get createAccount => 'Create account';

  @override
  String get signInSubtitle => 'Sign in to continue planning your trip.';

  @override
  String get signUpSubtitle => 'Sign up to save favorites and bookings.';

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Sign up';

  @override
  String get fullName => 'Full name';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get enterName => 'Enter your name';

  @override
  String get enterValidEmail => 'Enter a valid email';

  @override
  String passwordMin(int count) {
    return 'At least $count characters';
  }

  @override
  String get demoNote => 'Demo mode: no data leaves your device.';

  @override
  String get cloudNote =>
      'Your account and bookings are stored securely in the cloud.';

  @override
  String get errInvalidCredentials => 'Wrong email or password.';

  @override
  String get errEmailInUse => 'An account with this email already exists.';

  @override
  String get errWeakPassword => 'This password is too weak.';

  @override
  String get errNetwork => 'No internet connection. Please try again.';

  @override
  String get errTooMany => 'Too many attempts. Try again later.';

  @override
  String get errGeneric => 'Something went wrong. Please try again.';

  @override
  String helloUser(String name) {
    return 'Hello, $name 👋';
  }

  @override
  String get traveller => 'traveller';

  @override
  String get whereNext => 'Where to next?';

  @override
  String get searchHint => 'Search hotel or city';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get filters => 'Filters';

  @override
  String get all => 'All';

  @override
  String get featuredStays => 'Featured stays';

  @override
  String get popularHotels => 'Popular hotels';

  @override
  String staysFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stays found',
      one: '1 stay found',
    );
    return '$_temp0';
  }

  @override
  String get noHotelsTitle => 'No hotels found';

  @override
  String get noHotelsMessage => 'Try another city or loosen the filters.';

  @override
  String get clearAllFilters => 'Clear all filters';

  @override
  String get sort => 'Sort';

  @override
  String get loadFailed => 'Could not load hotels.';

  @override
  String get retry => 'Try again';

  @override
  String get sortNearest => 'Nearest first';

  @override
  String get nearMe => 'Near me';

  @override
  String get findingLocation => 'Finding your location…';

  @override
  String distanceKm(String km) {
    return '$km km away';
  }

  @override
  String distanceM(int m) {
    return '$m m away';
  }

  @override
  String get locationDenied =>
      'Location access was not allowed, so hotels cannot be sorted by distance.';

  @override
  String get locationDeniedForever =>
      'Location is blocked for this app. You can allow it in the settings.';

  @override
  String get locationServiceOff => 'Location is switched off on this device.';

  @override
  String get locationUnavailable =>
      'Could not read your location. Please try again.';

  @override
  String get openSettings => 'Settings';

  @override
  String get mapView => 'Map';

  @override
  String get listView => 'List';

  @override
  String get hotelsOnMap => 'Hotels on the map';

  @override
  String get youAreHere => 'You are here';

  @override
  String get sampleDataNote =>
      'Sample data: hotels and their positions are not real.';

  @override
  String get sortRecommended => 'Recommended';

  @override
  String get sortPriceLow => 'Price: low to high';

  @override
  String get sortPriceHigh => 'Price: high to low';

  @override
  String get sortRating => 'Top rated';

  @override
  String get filtersTitle => 'Filters';

  @override
  String get reset => 'Reset';

  @override
  String get sortBy => 'Sort by';

  @override
  String priceRange(int min, int max, String plus) {
    return 'Price per night: \$$min – \$$max$plus';
  }

  @override
  String get minimumRating => 'Minimum rating';

  @override
  String get any => 'Any';

  @override
  String get amenities => 'Amenities';

  @override
  String get showResults => 'Show results';

  @override
  String get amenityWifi => 'Wi-Fi';

  @override
  String get amenityBreakfast => 'Breakfast';

  @override
  String get amenityPool => 'Pool';

  @override
  String get amenitySpa => 'Spa';

  @override
  String get amenityGym => 'Gym';

  @override
  String get amenityParking => 'Parking';

  @override
  String get amenityRestaurant => 'Restaurant';

  @override
  String get amenityAirConditioning => 'Air conditioning';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String addedToFavorites(String name) {
    return '$name added to favorites';
  }

  @override
  String removedFromFavorites(String name) {
    return '$name removed from favorites';
  }

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
    );
    return '$_temp0';
  }

  @override
  String get perNight => ' /night';

  @override
  String get back => 'Back';

  @override
  String get about => 'About';

  @override
  String get showLess => 'Show less';

  @override
  String get readMore => 'Read more';

  @override
  String get location => 'Location';

  @override
  String get reviews => 'Reviews';

  @override
  String get openInMaps => 'Open in maps app';

  @override
  String get mapUnavailable => 'Could not open the maps app.';

  @override
  String get from => 'From';

  @override
  String get selectRoom => 'Select room';

  @override
  String get bookYourStay => 'Book your stay';

  @override
  String get roomType => 'Room type';

  @override
  String get roomStandard => 'Standard';

  @override
  String get roomStandardDesc => 'Queen bed, city view';

  @override
  String get roomDeluxe => 'Deluxe';

  @override
  String get roomDeluxeDesc => 'King bed, balcony, breakfast';

  @override
  String get roomSuite => 'Suite';

  @override
  String get roomSuiteDesc => 'Separate living room, best view';

  @override
  String get dates => 'Dates';

  @override
  String get checkIn => 'Check-in';

  @override
  String get checkOut => 'Check-out';

  @override
  String get addDate => 'Add date';

  @override
  String get selectYourStay => 'Select your stay';

  @override
  String get done => 'Done';

  @override
  String get guests => 'Guests';

  @override
  String guestsUpTo(int max, String room) {
    return 'Up to $max in a $room';
  }

  @override
  String get fewerGuests => 'Fewer guests';

  @override
  String get moreGuests => 'More guests';

  @override
  String nightsPrice(int rate, int nights) {
    String _temp0 = intl.Intl.pluralLogic(
      nights,
      locale: localeName,
      other: '$nights nights',
      one: '1 night',
    );
    return '\$$rate × $_temp0';
  }

  @override
  String serviceFee(int percent) {
    return 'Service fee ($percent%)';
  }

  @override
  String get total => 'Total';

  @override
  String confirmAndBook(int total) {
    return 'Confirm and book  •  \$$total';
  }

  @override
  String get selectDatesToContinue => 'Select dates to continue';

  @override
  String get guestDetails => 'Guest details';

  @override
  String get guestName => 'Guest name';

  @override
  String get guestPhone => 'Phone number';

  @override
  String get enterPhone => 'Enter a valid phone number';

  @override
  String get paymentMethod => 'Payment';

  @override
  String get payAtHotel => 'Pay at the hotel';

  @override
  String get payAtHotelDesc => 'No payment now. Pay when you check in.';

  @override
  String get payOnline => 'Pay online (demo)';

  @override
  String get payOnlineDesc => 'Simulated payment. Nothing is charged.';

  @override
  String get processingPayment => 'Processing payment…';

  @override
  String get bookingConfirmed => 'Booking confirmed';

  @override
  String bookingCode(String code) {
    return 'Booking code: $code';
  }

  @override
  String get great => 'Great';

  @override
  String get findInBookings => 'You can find it in the Bookings tab';

  @override
  String notAvailable(String room) {
    return 'No $room rooms left for these dates. Try other dates or another room type.';
  }

  @override
  String maxStay(int count) {
    return 'You can book up to $count nights at a time.';
  }

  @override
  String get alreadyBooked =>
      'You already have a booking at this hotel for these dates.';

  @override
  String get bookingFailed =>
      'Could not complete the booking. Please try again.';

  @override
  String get myBookings => 'My bookings';

  @override
  String get noTripsTitle => 'No trips booked';

  @override
  String get noTripsMessage => 'When you book a hotel it will show up here.';

  @override
  String get cancelBookingQ => 'Cancel booking?';

  @override
  String cancelBody(String hotel) {
    return 'Your stay at $hotel will be cancelled.';
  }

  @override
  String get keep => 'Keep';

  @override
  String get cancelBooking => 'Cancel booking';

  @override
  String bookingCancelled(String hotel) {
    return 'Booking at $hotel cancelled';
  }

  @override
  String get upcoming => 'Upcoming';

  @override
  String get confirmed => 'Confirmed';

  @override
  String nightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nights',
      one: '1 night',
    );
    return '$_temp0';
  }

  @override
  String roomWithName(String room) {
    return '$room room';
  }

  @override
  String guestsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count guests',
      one: '1 guest',
    );
    return '$_temp0';
  }

  @override
  String totalAmount(int total) {
    return 'Total \$$total';
  }

  @override
  String codeLabel(String code) {
    return 'Code $code';
  }

  @override
  String get noFavoritesTitle => 'No favorites yet';

  @override
  String get noFavoritesMessage =>
      'Tap the heart on any hotel to save it here.';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get language => 'Language';

  @override
  String get aboutApp => 'About this app';

  @override
  String get aboutBody =>
      'Portfolio project built with Flutter, Cubit, get_it, Firebase and Clean Architecture. Hotels are sample data and photos are from Unsplash.';

  @override
  String get logOut => 'Log out';

  @override
  String get logOutQ => 'Log out?';

  @override
  String get logOutBody => 'You can sign in again at any time.';

  @override
  String get cancel => 'Cancel';

  @override
  String get guest => 'Guest';
}
