import 'package:clinic/provider/booking_provider.dart';
import 'package:dart_frog/dart_frog.dart';

BookingProviderImpl? _bookingProviderImpl;

Handler middleware(Handler handler) {
  return handler.use(
    provider<BookingProviderImpl>(
      (context) => _bookingProviderImpl ??= BookingProviderImpl(),
    ),
  );
}
