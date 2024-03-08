import 'package:clinic/provider/medical_services_provider.dart';
import 'package:dart_frog/dart_frog.dart';

MedicalServicesProviderImpl? _medicalServicesProviderImpl;

Handler middleware(Handler handler) {
  return handler.use(
    provider<MedicalServicesProviderImpl>(
      (context) =>
          _medicalServicesProviderImpl ??= MedicalServicesProviderImpl(),
    ),
  );
}
