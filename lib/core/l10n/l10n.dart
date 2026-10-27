import 'package:flutter/widgets.dart';

import '../../features/auth/domain/auth_repository.dart';
import '../../features/hotels/domain/entities.dart';
import '../../features/hotels/domain/hotel_repository.dart';
import '../../l10n/generated/app_localizations.dart';

export '../../l10n/generated/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension LocationIssueL10n on LocationIssue {
  String message(AppLocalizations l10n) => switch (this) {
        LocationIssue.denied => l10n.locationDenied,
        LocationIssue.deniedForever => l10n.locationDeniedForever,
        LocationIssue.serviceDisabled => l10n.locationServiceOff,
        LocationIssue.unavailable => l10n.locationUnavailable,
      };
}

/// "1.2 km away", or metres when the hotel is very close.
String distanceLabel(AppLocalizations l10n, double km) => km < 1
    ? l10n.distanceM((km * 1000 / 10).round() * 10)
    : l10n.distanceKm(km < 10 ? km.toStringAsFixed(1) : km.round().toString());

extension AuthErrorL10n on AuthError {
  String message(AppLocalizations l10n) => switch (this) {
    AuthError.invalidCredentials => l10n.errInvalidCredentials,
    AuthError.emailInUse => l10n.errEmailInUse,
    AuthError.weakPassword => l10n.errWeakPassword,
    AuthError.network => l10n.errNetwork,
    AuthError.tooManyRequests => l10n.errTooMany,
    AuthError.unknown => l10n.errGeneric,
  };
}

extension HotelSortL10n on HotelSort {
  String label(AppLocalizations l10n) => switch (this) {
    HotelSort.recommended => l10n.sortRecommended,
    HotelSort.nearest => l10n.sortNearest,
    HotelSort.priceLow => l10n.sortPriceLow,
    HotelSort.priceHigh => l10n.sortPriceHigh,
    HotelSort.rating => l10n.sortRating,
  };
}

extension RoomTypeL10n on RoomType {
  String title(AppLocalizations l10n) => switch (id) {
    'standard' => l10n.roomStandard,
    'deluxe' => l10n.roomDeluxe,
    'suite' => l10n.roomSuite,
    _ => name,
  };

  String details(AppLocalizations l10n) => switch (id) {
    'standard' => l10n.roomStandardDesc,
    'deluxe' => l10n.roomDeluxeDesc,
    'suite' => l10n.roomSuiteDesc,
    _ => description,
  };
}

/// Localized name of an amenity. Amenities are stored under their English
/// key; unknown keys are shown as they are.
String amenityLabel(AppLocalizations l10n, String amenity) => switch (amenity) {
  'Wi-Fi' => l10n.amenityWifi,
  'Breakfast' => l10n.amenityBreakfast,
  'Pool' => l10n.amenityPool,
  'Spa' => l10n.amenitySpa,
  'Gym' => l10n.amenityGym,
  'Parking' => l10n.amenityParking,
  'Restaurant' => l10n.amenityRestaurant,
  'Air conditioning' => l10n.amenityAirConditioning,
  _ => amenity,
};
