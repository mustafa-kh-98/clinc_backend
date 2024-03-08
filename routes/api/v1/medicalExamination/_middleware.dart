import 'package:clinic/provider/medical_examination_provider.dart';
import 'package:dart_frog/dart_frog.dart';

MedicalExaminationProvider? _medicalExaminationProvider;

Handler middleware(Handler handler) {
  return handler.use(
    provider<MedicalExaminationProvider>(
      (context) => _medicalExaminationProvider ??= MedicalExaminationProvider(),
    ),
  );
}
