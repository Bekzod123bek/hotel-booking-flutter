import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uz'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Hotel Booking'**
  String get appTitle;

  /// No description provided for @languageName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// No description provided for @navBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get navBookings;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @onb1Title.
  ///
  /// In en, this message translates to:
  /// **'Discover places to stay'**
  String get onb1Title;

  /// No description provided for @onb1Text.
  ///
  /// In en, this message translates to:
  /// **'Hand-picked hotels in Tashkent, Samarkand, Bukhara, Khiva and beyond.'**
  String get onb1Text;

  /// No description provided for @onb2Title.
  ///
  /// In en, this message translates to:
  /// **'Compare and choose'**
  String get onb2Title;

  /// No description provided for @onb2Text.
  ///
  /// In en, this message translates to:
  /// **'Filter by price, rating and amenities and see real guest reviews.'**
  String get onb2Text;

  /// No description provided for @onb3Title.
  ///
  /// In en, this message translates to:
  /// **'Book in a few taps'**
  String get onb3Title;

  /// No description provided for @onb3Text.
  ///
  /// In en, this message translates to:
  /// **'Pick your dates and room, and keep every booking in one place.'**
  String get onb3Text;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue planning your trip.'**
  String get signInSubtitle;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to save favorites and bookings.'**
  String get signUpSubtitle;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @passwordMin.
  ///
  /// In en, this message translates to:
  /// **'At least {count} characters'**
  String passwordMin(int count);

  /// No description provided for @demoNote.
  ///
  /// In en, this message translates to:
  /// **'Demo mode: no data leaves your device.'**
  String get demoNote;

  /// No description provided for @cloudNote.
  ///
  /// In en, this message translates to:
  /// **'Your account and bookings are stored securely in the cloud.'**
  String get cloudNote;

  /// No description provided for @errInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password.'**
  String get errInvalidCredentials;

  /// No description provided for @errEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get errEmailInUse;

  /// No description provided for @errWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'This password is too weak.'**
  String get errWeakPassword;

  /// No description provided for @errNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please try again.'**
  String get errNetwork;

  /// No description provided for @errTooMany.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later.'**
  String get errTooMany;

  /// No description provided for @errGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errGeneric;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name} 👋'**
  String helloUser(String name);

  /// No description provided for @traveller.
  ///
  /// In en, this message translates to:
  /// **'traveller'**
  String get traveller;

  /// No description provided for @whereNext.
  ///
  /// In en, this message translates to:
  /// **'Where to next?'**
  String get whereNext;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search hotel or city'**
  String get searchHint;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @featuredStays.
  ///
  /// In en, this message translates to:
  /// **'Featured stays'**
  String get featuredStays;

  /// No description provided for @popularHotels.
  ///
  /// In en, this message translates to:
  /// **'Popular hotels'**
  String get popularHotels;

  /// No description provided for @staysFound.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 stay found} other{{count} stays found}}'**
  String staysFound(int count);

  /// No description provided for @noHotelsTitle.
  ///
  /// In en, this message translates to:
  /// **'No hotels found'**
  String get noHotelsTitle;

  /// No description provided for @noHotelsMessage.
  ///
  /// In en, this message translates to:
  /// **'Try another city or loosen the filters.'**
  String get noHotelsMessage;

  /// No description provided for @clearAllFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear all filters'**
  String get clearAllFilters;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load hotels.'**
  String get loadFailed;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @sortNearest.
  ///
  /// In en, this message translates to:
  /// **'Nearest first'**
  String get sortNearest;

  /// No description provided for @nearMe.
  ///
  /// In en, this message translates to:
  /// **'Near me'**
  String get nearMe;

  /// No description provided for @findingLocation.
  ///
  /// In en, this message translates to:
  /// **'Finding your location…'**
  String get findingLocation;

  /// No description provided for @distanceKm.
  ///
  /// In en, this message translates to:
  /// **'{km} km away'**
  String distanceKm(String km);

  /// No description provided for @distanceM.
  ///
  /// In en, this message translates to:
  /// **'{m} m away'**
  String distanceM(int m);

  /// No description provided for @locationDenied.
  ///
  /// In en, this message translates to:
  /// **'Location access was not allowed, so hotels cannot be sorted by distance.'**
  String get locationDenied;

  /// No description provided for @locationDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location is blocked for this app. You can allow it in the settings.'**
  String get locationDeniedForever;

  /// No description provided for @locationServiceOff.
  ///
  /// In en, this message translates to:
  /// **'Location is switched off on this device.'**
  String get locationServiceOff;

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not read your location. Please try again.'**
  String get locationUnavailable;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get openSettings;

  /// No description provided for @mapView.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapView;

  /// No description provided for @listView.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get listView;

  /// No description provided for @hotelsOnMap.
  ///
  /// In en, this message translates to:
  /// **'Hotels on the map'**
  String get hotelsOnMap;

  /// No description provided for @youAreHere.
  ///
  /// In en, this message translates to:
  /// **'You are here'**
  String get youAreHere;

  /// No description provided for @sampleDataNote.
  ///
  /// In en, this message translates to:
  /// **'Sample data: hotels and their positions are not real.'**
  String get sampleDataNote;

  /// No description provided for @sortRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get sortRecommended;

  /// No description provided for @sortPriceLow.
  ///
  /// In en, this message translates to:
  /// **'Price: low to high'**
  String get sortPriceLow;

  /// No description provided for @sortPriceHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: high to low'**
  String get sortPriceHigh;

  /// No description provided for @sortRating.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get sortRating;

  /// No description provided for @filtersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersTitle;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price per night: \${min} – \${max}{plus}'**
  String priceRange(int min, int max, String plus);

  /// No description provided for @minimumRating.
  ///
  /// In en, this message translates to:
  /// **'Minimum rating'**
  String get minimumRating;

  /// No description provided for @any.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get any;

  /// No description provided for @amenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenities;

  /// No description provided for @showResults.
  ///
  /// In en, this message translates to:
  /// **'Show results'**
  String get showResults;

  /// No description provided for @amenityWifi.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi'**
  String get amenityWifi;

  /// No description provided for @amenityBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get amenityBreakfast;

  /// No description provided for @amenityPool.
  ///
  /// In en, this message translates to:
  /// **'Pool'**
  String get amenityPool;

  /// No description provided for @amenitySpa.
  ///
  /// In en, this message translates to:
  /// **'Spa'**
  String get amenitySpa;

  /// No description provided for @amenityGym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get amenityGym;

  /// No description provided for @amenityParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get amenityParking;

  /// No description provided for @amenityRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get amenityRestaurant;

  /// No description provided for @amenityAirConditioning.
  ///
  /// In en, this message translates to:
  /// **'Air conditioning'**
  String get amenityAirConditioning;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'{name} added to favorites'**
  String addedToFavorites(String name);

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'{name} removed from favorites'**
  String removedFromFavorites(String name);

  /// No description provided for @reviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 review} other{{count} reviews}}'**
  String reviewsCount(int count);

  /// No description provided for @perNight.
  ///
  /// In en, this message translates to:
  /// **' /night'**
  String get perNight;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @openInMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in maps app'**
  String get openInMaps;

  /// No description provided for @mapUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not open the maps app.'**
  String get mapUnavailable;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book now'**
  String get bookNow;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Hotel details copied'**
  String get copied;

  /// No description provided for @selectRoom.
  ///
  /// In en, this message translates to:
  /// **'Select room'**
  String get selectRoom;

  /// No description provided for @bookYourStay.
  ///
  /// In en, this message translates to:
  /// **'Book your stay'**
  String get bookYourStay;

  /// No description provided for @roomType.
  ///
  /// In en, this message translates to:
  /// **'Room type'**
  String get roomType;

  /// No description provided for @roomStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get roomStandard;

  /// No description provided for @roomStandardDesc.
  ///
  /// In en, this message translates to:
  /// **'Queen bed, city view'**
  String get roomStandardDesc;

  /// No description provided for @roomDeluxe.
  ///
  /// In en, this message translates to:
  /// **'Deluxe'**
  String get roomDeluxe;

  /// No description provided for @roomDeluxeDesc.
  ///
  /// In en, this message translates to:
  /// **'King bed, balcony, breakfast'**
  String get roomDeluxeDesc;

  /// No description provided for @roomSuite.
  ///
  /// In en, this message translates to:
  /// **'Suite'**
  String get roomSuite;

  /// No description provided for @roomSuiteDesc.
  ///
  /// In en, this message translates to:
  /// **'Separate living room, best view'**
  String get roomSuiteDesc;

  /// No description provided for @dates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get dates;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get checkOut;

  /// No description provided for @addDate.
  ///
  /// In en, this message translates to:
  /// **'Add date'**
  String get addDate;

  /// No description provided for @selectYourStay.
  ///
  /// In en, this message translates to:
  /// **'Select your stay'**
  String get selectYourStay;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @guests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get guests;

  /// No description provided for @guestsUpTo.
  ///
  /// In en, this message translates to:
  /// **'Up to {max} in a {room}'**
  String guestsUpTo(int max, String room);

  /// No description provided for @fewerGuests.
  ///
  /// In en, this message translates to:
  /// **'Fewer guests'**
  String get fewerGuests;

  /// No description provided for @moreGuests.
  ///
  /// In en, this message translates to:
  /// **'More guests'**
  String get moreGuests;

  /// No description provided for @nightsPrice.
  ///
  /// In en, this message translates to:
  /// **'\${rate} × {nights, plural, =1{1 night} other{{nights} nights}}'**
  String nightsPrice(int rate, int nights);

  /// No description provided for @serviceFee.
  ///
  /// In en, this message translates to:
  /// **'Service fee ({percent}%)'**
  String serviceFee(int percent);

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @confirmAndBook.
  ///
  /// In en, this message translates to:
  /// **'Confirm and book  •  \${total}'**
  String confirmAndBook(int total);

  /// No description provided for @selectDatesToContinue.
  ///
  /// In en, this message translates to:
  /// **'Select dates to continue'**
  String get selectDatesToContinue;

  /// No description provided for @guestDetails.
  ///
  /// In en, this message translates to:
  /// **'Guest details'**
  String get guestDetails;

  /// No description provided for @guestName.
  ///
  /// In en, this message translates to:
  /// **'Guest name'**
  String get guestName;

  /// No description provided for @guestPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get guestPhone;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get enterPhone;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentMethod;

  /// No description provided for @payAtHotel.
  ///
  /// In en, this message translates to:
  /// **'Pay at the hotel'**
  String get payAtHotel;

  /// No description provided for @payAtHotelDesc.
  ///
  /// In en, this message translates to:
  /// **'No payment now. Pay when you check in.'**
  String get payAtHotelDesc;

  /// No description provided for @payOnline.
  ///
  /// In en, this message translates to:
  /// **'Pay online (demo)'**
  String get payOnline;

  /// No description provided for @payOnlineDesc.
  ///
  /// In en, this message translates to:
  /// **'Simulated payment. Nothing is charged.'**
  String get payOnlineDesc;

  /// No description provided for @processingPayment.
  ///
  /// In en, this message translates to:
  /// **'Processing payment…'**
  String get processingPayment;

  /// No description provided for @bookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed'**
  String get bookingConfirmed;

  /// No description provided for @bookingCode.
  ///
  /// In en, this message translates to:
  /// **'Booking code: {code}'**
  String bookingCode(String code);

  /// No description provided for @great.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get great;

  /// No description provided for @findInBookings.
  ///
  /// In en, this message translates to:
  /// **'You can find it in the Bookings tab'**
  String get findInBookings;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'No {room} rooms left for these dates. Try other dates or another room type.'**
  String notAvailable(String room);

  /// No description provided for @maxStay.
  ///
  /// In en, this message translates to:
  /// **'You can book up to {count} nights at a time.'**
  String maxStay(int count);

  /// No description provided for @alreadyBooked.
  ///
  /// In en, this message translates to:
  /// **'You already have a booking at this hotel for these dates.'**
  String get alreadyBooked;

  /// No description provided for @bookingFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not complete the booking. Please try again.'**
  String get bookingFailed;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My bookings'**
  String get myBookings;

  /// No description provided for @noTripsTitle.
  ///
  /// In en, this message translates to:
  /// **'No trips booked'**
  String get noTripsTitle;

  /// No description provided for @noTripsMessage.
  ///
  /// In en, this message translates to:
  /// **'When you book a hotel it will show up here.'**
  String get noTripsMessage;

  /// No description provided for @cancelBookingQ.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking?'**
  String get cancelBookingQ;

  /// No description provided for @cancelBody.
  ///
  /// In en, this message translates to:
  /// **'Your stay at {hotel} will be cancelled.'**
  String cancelBody(String hotel);

  /// No description provided for @keep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get keep;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get cancelBooking;

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking at {hotel} cancelled'**
  String bookingCancelled(String hotel);

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @nightsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 night} other{{count} nights}}'**
  String nightsCount(int count);

  /// No description provided for @roomWithName.
  ///
  /// In en, this message translates to:
  /// **'{room} room'**
  String roomWithName(String room);

  /// No description provided for @guestsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 guest} other{{count} guests}}'**
  String guestsCount(int count);

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total \${total}'**
  String totalAmount(int total);

  /// No description provided for @codeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code {code}'**
  String codeLabel(String code);

  /// No description provided for @noFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavoritesTitle;

  /// No description provided for @noFavoritesMessage.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on any hotel to save it here.'**
  String get noFavoritesMessage;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About this app'**
  String get aboutApp;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'Portfolio project built with Flutter, Cubit, get_it, Firebase and Clean Architecture. Hotels are sample data and photos are from Unsplash.'**
  String get aboutBody;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @logOutQ.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logOutQ;

  /// No description provided for @logOutBody.
  ///
  /// In en, this message translates to:
  /// **'You can sign in again at any time.'**
  String get logOutBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
