import 'package:clinic/core/common/response.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

class DatabaseService {
  factory DatabaseService() => _instance;

  DatabaseService._() {
    startDb();
  }

  static final DatabaseService _instance = DatabaseService._();

  final _db = Db('mongodb://localhost:27017/clinic');

  Future<void> startDb() async {
    if (_db.isConnected == false) {
      await _db.open();
      Log('message', '==>open');
    }
  }

  Future<void> closeDb() async {
    if (_db.isConnected == true) {
      await _db.close();
    }
  }

  DbCollection get userCollection => _db.collection('users');

  DbCollection get laboratoryServicesCollection => _db.collection(
        'laboratory_services',
      );

  DbCollection get medicalServicesCollection => _db.collection(
        'medical_services',
      );

  DbCollection get bookingCollection => _db.collection(
        'bookings',
      );

  DbCollection get medicalExaminationCollection => _db.collection(
    'medical_examination',
  );

  DbCollection get commonDiseasesAndWarningsCollection => _db.collection(
    'common_chronic_conditions_and_warnings',
  );

  Future<Response> startConnection(
    RequestContext context,
    Future<Response> callBack,
  ) async {
    try {
      await startDb();
      return await callBack;
    } catch (e) {
      return Response.json(
        statusCode: 500,
        body: Common.sendErrorResponse(
          statusCode: '500',
          message: 'SERVER ERROR',
          errorMessage: [
            e.toString(),
          ],
        ),
      );
    }
  }
}
