// ignore_for_file: camel_case_types, public_member_api_docs

import 'dart:io';

import 'package:clinic/core/common/response.dart';
import 'package:clinic/data/data_servier.dart';
import 'package:clinic/models/laboratory_services/laboratory_services_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../core/common/enums.dart';

abstract class _BaseLaboratoryServicesProvider {
  Future<Map<String, dynamic>> addAnService({
    required LaboratoryServicesModel laboratoryServicesModel,
  });

  Future<Map<String, dynamic>> getAllServices();

  Future<Map<String, dynamic>> deleteServices({required List<String> ids});

  Future<Map<String, dynamic>> getServiceById({required String id});

  Future<Map<String, dynamic>> getServiceByType({required String type});

  Future<Map<String, dynamic>> updateService({
    required Map<String, dynamic> service,
    required String id,
  });
}

class LaboratoryServicesProviderImpl
    implements _BaseLaboratoryServicesProvider {
  final DatabaseService databaseService = DatabaseService();

  @override
  Future<Map<String, dynamic>> addAnService({
    required LaboratoryServicesModel laboratoryServicesModel,
  }) async {
    var isValid = true;
    final errors = <String>[];

    if (laboratoryServicesModel.serviceType == null) {
      errors.add('service type is required');
      isValid = false;
    }
    if (laboratoryServicesModel.serviceType != null &&
        laboratoryServicesModel.serviceType ==
            LaboratoryServiceTypes.medicine &&
        laboratoryServicesModel.companyName == null) {
      errors.add('company name is required for medicine type');
      isValid = false;
    }
    if (laboratoryServicesModel.serviceName == null) {
      errors.add('name is required');
      isValid = false;
    }
    if (laboratoryServicesModel.price == null) {
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
      final count = await databaseService.laboratoryServicesCollection.count(
        where.match(
          'service_type',
          {
            LaboratoryServiceTypes.medicine: 'medicine',
            LaboratoryServiceTypes.ray: 'ray',
            LaboratoryServiceTypes.test: 'test',
          }[laboratoryServicesModel.serviceType!]!,
        ),
      );
      laboratoryServicesModel = laboratoryServicesModel.copyWith(
        icon: laboratoryServicesModel.icon,
        notes: laboratoryServicesModel.notes,
        price: laboratoryServicesModel.price,
        serviceName: laboratoryServicesModel.serviceName,
        results: laboratoryServicesModel.results,
        serviceType: laboratoryServicesModel.serviceType,
        companyName: laboratoryServicesModel.companyName,
        idNumber: count + 1,
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
      );
      await databaseService.laboratoryServicesCollection
          .insertOne(laboratoryServicesModel.toJson());
      return Common.sendSuccessResponse(
        statusCode: HttpStatus.ok.toString(),
        message: 'done add service',
        data: laboratoryServicesModel.toJson(),
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
          await databaseService.laboratoryServicesCollection.find().toList();
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
  Future<Map<String, dynamic>> deleteServices(
      {required List<String> ids}) async {
    List<ObjectId> ids0;
    try {
      ids0 = ids.map(ObjectId.parse).toList();
      final result =
          await databaseService.laboratoryServicesCollection.deleteMany(
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
      service = await databaseService.laboratoryServicesCollection
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
      updateService = await databaseService.laboratoryServicesCollection
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
      updateDocument[r'$set']?['updated_at'] = DateTime.now().toIso8601String();

      await databaseService.laboratoryServicesCollection.updateOne(
        where.id(oId),
        updateDocument,
      );
      final result = await databaseService.laboratoryServicesCollection
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

  @override
  Future<Map<String, dynamic>> getServiceByType({required String type}) async {
    try {
      $enumDecodeNullable(
        {
          LaboratoryServiceTypes.medicine: 'medicine',
          LaboratoryServiceTypes.ray: 'ray',
          LaboratoryServiceTypes.test: 'test',
        },
        type,
      );

      final result = await databaseService.laboratoryServicesCollection
          .find(
            where.match(
              'service_type',
              type,
            ),
          )
          .toList();
      return Common.sendSuccessResponse(
        statusCode: HttpStatus.ok.toString(),
        message: 'find ${result.length} service for $type type',
        data: result,
      );
    } catch (e) {
      return Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'bad state',
        errorMessage: [
          e.toString(),
        ],
      );
    }
  }
}
