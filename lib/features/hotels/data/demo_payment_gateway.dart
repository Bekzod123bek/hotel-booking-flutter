import '../domain/hotel_repository.dart';

/// Pretends to charge a card. Nothing is charged and no card data is read.
/// Replace with a Payme / Click / Stripe implementation for a real product.
class DemoPaymentGateway implements PaymentGateway {
  const DemoPaymentGateway({this.delay = const Duration(milliseconds: 1500)});

  final Duration delay;

  @override
  Future<void> charge({required int amount, required String description}) =>
      Future<void>.delayed(delay);
}
