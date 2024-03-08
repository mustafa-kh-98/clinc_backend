// ignore_for_file: public_member_api_docs, constant_identifier_names

enum LaboratoryServiceTypes { ray, test, medicine }

Map<LaboratoryServiceTypes, String> laboratoryServiceTypesEnumMap = {
  LaboratoryServiceTypes.medicine: 'medicine',
  LaboratoryServiceTypes.ray: 'ray',
  LaboratoryServiceTypes.test: 'test',
};

enum BookingStatus { done, inProgress, inDoctor, notCome }

Map<BookingStatus, String> bookingStatusEnumMap = {
  BookingStatus.done: 'done',
  BookingStatus.inDoctor: 'inDoctor',
  BookingStatus.notCome: 'notCome',
  BookingStatus.inProgress: 'inProgress',
};

enum ServicePriceStatus { done, part, notPaid }

Map<ServicePriceStatus, String> servicePriceEnumMap = {
  ServicePriceStatus.done: 'done',
  ServicePriceStatus.part: 'part',
  ServicePriceStatus.notPaid: 'notPaid',
};

enum BloodType {
  O_MUNS,
  A_MUNS,
  B_MUNS,
  AB_MUNS,
  O_PLUS,
  A_PLUS,
  B_PLUS,
  AB_PLUS;

}

extension BloodMap on BloodType {
  Map<BloodType, String> get getMap => {
        BloodType.O_PLUS: 'O+',
        BloodType.A_PLUS: 'A+',
        BloodType.B_PLUS: 'B+',
        BloodType.AB_PLUS: 'AB+',
        BloodType.O_MUNS: 'O-',
        BloodType.A_MUNS: 'A-',
        BloodType.B_MUNS: 'B-',
        BloodType.AB_MUNS: 'AB-',
      };
}
