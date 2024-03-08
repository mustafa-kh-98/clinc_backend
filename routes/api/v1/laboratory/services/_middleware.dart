import 'package:clinic/provider/laboratory_services_provider.dart';
import 'package:dart_frog/dart_frog.dart';

LaboratoryServicesProviderImpl? _laboratoryServicesProviderImpl;

Handler middleware(Handler handler) {
  return handler.use(
    provider<LaboratoryServicesProviderImpl>(
      (context) =>
          _laboratoryServicesProviderImpl ??= LaboratoryServicesProviderImpl(),
    ),
  );
}
