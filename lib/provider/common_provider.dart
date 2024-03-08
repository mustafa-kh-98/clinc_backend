import 'dart:io';

import 'package:clinic/core/common/response.dart';
import 'package:clinic/data/data_servier.dart';
import 'package:clinic/models/medical_examination/health_Information.dart';
import 'package:mongo_dart/mongo_dart.dart';

abstract class _BaseCommonProvider {
  Future<Map<String, dynamic>> addNewDiseaseOrWarning({
    required Map<String, dynamic> bodyData,
    required String type,
  });

  Future<Map<String, dynamic>> getCommon({
    required String type,
  });
}

class CommonProvider implements _BaseCommonProvider {
  @override
  Future<Map<String, dynamic>> addNewDiseaseOrWarning({
    required Map<String, dynamic> bodyData,
    required String type,
  }) async {
    var isValid = true;
    var commonAndWarningsDiseasesModel = const CommonAndWarningsDiseasesModel();
    final errors = <String>[];
    if (bodyData['title'] == null) {
      errors.add('title type must not be empty');
      isValid = false;
    }
    if (bodyData['description'] == null) {
      errors.add('description type must not be empty');
      isValid = false;
    }
    if (!isValid) {
      return Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'error on add user',
        errorMessage: errors,
      );
    }
    commonAndWarningsDiseasesModel = commonAndWarningsDiseasesModel.copyWith(
      type: type,
      title: bodyData['title'] as String,
      description: bodyData['description'] as String,
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
    final result =
        await DatabaseService().commonDiseasesAndWarningsCollection.insertOne(
              Common.removeNullFromMap(commonAndWarningsDiseasesModel.toJson()),
            );
    return Common.sendSuccessResponse(
      statusCode: HttpStatus.ok.toString(),
      message: 'Add ${commonAndWarningsDiseasesModel.type}',
      data: result.document,
    );
  }

  @override
  Future<Map<String, dynamic>> getCommon({required String type}) async {
    final result = await DatabaseService()
        .commonDiseasesAndWarningsCollection
        .find(
          where.eq('type', type),
        )
        .toList();
    return Common.sendSuccessResponse(
      statusCode: HttpStatus.ok.toString(),
      message: 'Find ${result.length}  $type',
      data: result,
    );
  }
}
