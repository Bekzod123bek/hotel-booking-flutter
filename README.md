# Hotel Booking

A personal demo project: a mobile hotel booking app built with Flutter.

Search hotels by name or city, view details, pick dates and guests, confirm a
booking and manage it from the "Bookings" tab.

> **Note:** this is a portfolio/demo project, not a production app. Data comes
> from an in-memory mock repository, there is no backend.

## Stack

- Flutter / Dart
- `flutter_bloc` (Cubit) for state management
- `get_it` for dependency injection
- Clean Architecture split: `domain`, `data`, `presentation`

## Structure

```
lib/
  main.dart
  injection.dart
  features/hotels/
    domain/        entities and repository contract
    data/          mock repository
    presentation/  cubits and pages
```

## Run

```bash
flutter pub get
flutter run
flutter test
```

## Possible next steps

- Replace the mock repository with a REST API (`dio`)
- Persist bookings locally
- Add authentication
