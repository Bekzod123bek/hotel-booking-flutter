# Hotel Booking

A personal demo project: a hotel booking app for Android and iOS built with
Flutter.

> **Note:** this is a portfolio/demo project, not a production app. Hotels,
> prices and reviews are sample data, hotel names are fictional, there is no
> backend and sign-in is simulated (nothing leaves the device, passwords are
> not stored). Photos are illustrative and do not show the listed hotels.

## Features

- **Onboarding** (3 slides, shown on first launch only)
- **Sign in / sign up** with form validation (mock)
- **Explore**: featured hotels carousel, city chips, live search, sort
- **Filters** in a bottom sheet: price range, minimum rating, amenities, sort
- **Hotel page**: Hero animation, photo gallery with indicator, amenities,
  expandable description, location card (map placeholder), guest reviews
- **Booking flow**: room type (Standard / Deluxe / Suite), date range, guests,
  price breakdown with service fee, confirmation dialog
- **Favorites** and **bookings** saved on the device, cancel with confirmation
- **Profile**: stats, dark / light mode switch (remembered), log out
- Shimmer loading, empty states, snackbars, pull to refresh

## Stack

- Flutter / Dart, Material 3
- `flutter_bloc` (Cubit) for state management
- `get_it` for dependency injection
- `shared_preferences` for local storage
- `cached_network_image` + `shimmer` for photos and loading states
- Clean Architecture split: `domain`, `data`, `presentation`

## Structure

```
lib/
  main.dart                 app, theme, auth routing
  home_shell.dart           bottom navigation
  injection.dart            get_it setup
  core/                     theme, shared widgets
  features/
    auth/                   onboarding, login, AuthCubit (mock)
    hotels/
      domain/               entities, filter, repository contract
      data/                 sample hotels, repository with local storage
      presentation/         cubits, pages, widgets
    profile/                profile page
```

## Run

```bash
flutter pub get
flutter run
flutter test
```

The app needs an internet connection to load photos.

## Possible next steps

- Real backend with a REST API (`dio`)
- Real map (Google Maps / Yandex MapKit)
- Real authentication

## Credits

Photos: [Unsplash](https://unsplash.com) (Unsplash License).
