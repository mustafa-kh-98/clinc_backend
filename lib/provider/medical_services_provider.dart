// ignore_for_file: camel_case_types, public_member_api_docs

import 'dart:io';

import 'package:clinic/core/common/response.dart';
import 'package:clinic/data/data_servier.dart';
import 'package:clinic/models/medical_services/medical_services_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

abstract class _BaseMedicalServicesProvider {
  Future<Map<String, dynamic>> addAnService({
    required MedicalServicesModel medicalServicesModel,
  });

  Future<Map<String, dynamic>> getAllServices();

  Future<Map<String, dynamic>> deleteServices({required List<String> ids});

  Future<Map<String, dynamic>> getServiceById({required String id});

  Future<Map<String, dynamic>> updateService({
    required Map<String, dynamic> service,
    required String id,
  });
}

class MedicalServicesProviderImpl implements _BaseMedicalServicesProvider {
  final DatabaseService databaseService = DatabaseService();

  @override
  Future<Map<String, dynamic>> addAnService({
    required MedicalServicesModel medicalServicesModel,
  }) async {
    var isValid = true;
    final errors = <String>[];
    // if (medicalServicesModel.doctor == null) {
    //   errors.add('doctor is required');
    //   isValid = false;
    // }
    if (medicalServicesModel.serviceName == null) {
      errors.add('name is required');
      isValid = false;
    }
    if (medicalServicesModel.price == null) {
      errors.add('price is required');
      isValid = false;
    }

    if (!isValid) {
      return Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'bad request',
        errorMessage: errors,
      );
    }

    try {
      final count = await databaseService.medicalServicesCollection.count();
      medicalServicesModel = medicalServicesModel.copyWith(
        icon: medicalServicesModel.icon,
        notes: medicalServicesModel.notes,
        price: medicalServicesModel.price,
        serviceName: medicalServicesModel.serviceName,
        // doctor: medicalServicesModel.doctor,
        idNumber: count + 1,
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
      );
      // final doctorOb = await databaseService.userCollection.findOne(
      //   where.id(
      //     ObjectId.parse(medicalServicesModel.doctor!),
      //   ),
      // );

      final addDoctor = medicalServicesModel.toJson();
      // addDoctor['doctor'] = doctorOb;

      await databaseService.medicalServicesCollection
          .insertOne(addDoctor);
      return Common.sendSuccessResponse(
        statusCode: HttpStatus.ok.toString(),
        message: 'done add service',
        data: addDoctor,
      );
    } catch (e) {
      Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'Undefined error',
        errorMessage: [
          e.toString(),
        ],
      );
    }
    return Common.sendErrorResponse(
      statusCode: HttpStatus.badRequest.toString(),
      message: 'Undefined error',
      errorMessage: [
        'error',
      ],
    );
  }

  @override
  Future<Map<String, dynamic>> getAllServices() async {
    late List<Map<String, dynamic>> services;
    try {
      services =
          await databaseService.medicalServicesCollection.find().toList();
      return Common.sendSuccessResponse(
        statusCode: HttpStatus.ok.toString(),
        message: 'done get ${services.length} service',
        data: services,
      );
    } catch (e) {
      return Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'Undefined error',
        errorMessage: [
          e.toString(),
        ],
      );
    }
  }

  @override
  Future<Map<String, dynamic>> deleteServices({
    required List<String> ids,
  }) async {
    List<ObjectId> ids0;
    try {
      ids0 = ids.map(ObjectId.parse).toList();
      final result = await databaseService.medicalServicesCollection.deleteMany(
        {
          '_id': {
            r'$in': ids0,
          },
        },
      );
      return Common.sendSuccessResponse(
        statusCode: HttpStatus.ok.toString(),
        message: 'delete',
        data: {
          'status': 'delete ${result.nRemoved}',
        },
      );
    } catch (e) {
      return Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'Undefined error',
        errorMessage: [
          e.toString(),
        ],
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getServiceById({required String id}) async {
    ObjectId oId;
    try {
      oId = ObjectId.parse(id);

      Map<String, dynamic>? service;
      service = await databaseService.medicalServicesCollection
          .findOne(where.id(oId));
      if (service == null) {
        return Common.sendErrorResponse(
          statusCode: HttpStatus.badRequest.toString(),
          message: 'No service with that $oId}',
          errorMessage: [
            'Bad state: No element',
          ],
        );
      }
      return Common.sendSuccessResponse(
        statusCode: HttpStatus.ok.toString(),
        message: 'find service',
        data: service,
      );
    } catch (e) {
      return Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'Undefined error',
        errorMessage: [
          e.toString(),
        ],
      );
    }
  }

  @override
  Future<Map<String, dynamic>> updateService({
    required Map<String, dynamic> service,
    required String id,
  }) async {
    ObjectId oId;
    try {
      oId = ObjectId.parse(id);
      Map<String, dynamic>? updateService;
      updateService = await databaseService.medicalServicesCollection
          .findOne(where.id(oId));
      // ignore: avoid_dynamic_calls
      if (service['service_type'] != null) {
        return Common.sendErrorResponse(
          statusCode: HttpStatus.badRequest.toString(),
          message: 'bad state',
          errorMessage: [
            'can not update type',
          ],
        );
      }
      service['id_number'] = updateService?['id_number'];

      final updateDocument = {
        r'$set': service,
      };
      // if(service['doctor']!=null){
      //   final doctorOb = await databaseService.userCollection.findOne(
      //     where.id(
      //       ObjectId.parse(service['doctor'] as String),
      //     ),
      //   );
      //   updateDocument[r'$set']?['doctor'] = doctorOb;
      // }

      updateDocument[r'$set']?['updated_at'] = DateTime.now().toIso8601String();

      await databaseService.medicalServicesCollection.updateOne(
        where.id(oId),
        updateDocument,
      );
      final result = await databaseService.medicalServicesCollection
          .findOne(where.id(oId));
      return Common.sendSuccessResponse(
        statusCode: HttpStatus.ok.toString(),
        message: 'Updated service',
        data: result,
      );
    } catch (e) {
      return Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'Undefined error',
        errorMessage: [
          e.toString(),
        ],
      );
    }
  }
}
