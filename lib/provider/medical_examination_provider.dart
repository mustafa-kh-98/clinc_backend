import 'dart:io';

import 'package:clinic/core/common/response.dart';
import 'package:clinic/data/data_servier.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../core/common/query_helper.dart';

abstract class _BaseMedicalExamination {
  Future<Map<String, dynamic>> getAllPatMedicalInfo({required String patId});

  Future<Map<String, dynamic>> addOrUpdateDWForPat({
    required String exId,
    required Map<String, dynamic> body,
  });

  Future<Map<String, dynamic>> addOrUpdateInfoForPat({
    required String exId,
    required String? infoId,
    required Map<String, dynamic> body,
  });

  Future<Map<String, dynamic>> deleteInfoForPat({
    required String exId,
    required String infoId,
  });
}

// ignore: public_member_api_docs
class MedicalExaminationProvider implements _BaseMedicalExamination {
  @override
  Future<Map<String, dynamic>> getAllPatMedicalInfo({
    required String? patId,
  }) async {
    try {
      if (patId != null) {
        var user = <String, dynamic>{};
        final patOid = ObjectId.parse(patId);
        await DatabaseService()
            .medicalExaminationCollection
            .modernAggregate(
              [
                QueryHelper.match(
                  field: 'patient._id',
                  query: {r'$eq': patOid},
                ),
                QueryHelper.lookup(
                  form: DatabaseService()
                      .commonDiseasesAndWarningsCollection
                      .collectionName,
                  field: 'additional_information.disease',
                  fField: '_id',
                ),
                QueryHelper.lookup(
                  form: DatabaseService()
                      .commonDiseasesAndWarningsCollection
                      .collectionName,
                  field: 'additional_information.warning',
                  fField: '_id',
                ),
              ],
            )
            .first
            .then(
              (value) {
                user = value;
              },
            );
        if (user.isEmpty) {
          return Common.sendErrorResponse(
            statusCode: HttpStatus.badRequest.toString(),
            message: 'No user with that id',
            errorMessage: [
              'Bad state: No element',
            ],
          );
        }
        return Common.sendSuccessResponse(
          statusCode: HttpStatus.ok.toString(),
          message: 'done get',
          data: user,
        );
      } else {
        final res = await DatabaseService()
            .medicalExaminationCollection
            .find()
            .toList();
        return Common.sendSuccessResponse(
          statusCode: HttpStatus.ok.toString(),
          message: 'done get ${res.length}',
          data: res,
        );
      }
    } catch (e) {
      return Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'e',
        errorMessage: [e.toString()],
      );
    }
  }

  Future<bool> _isHaseField(String dataKye, String fieldName, String id) async {
    final data = await DatabaseService().medicalExaminationCollection.findOne(
          where.id(ObjectId.parse(id)).fields(
            [fieldName],
          ),
        );

    final includeDes = data?[dataKye] as Map<String, dynamic>?;
    return includeDes == null ? false : includeDes.isEmpty;
  }

  Future<Map<String, dynamic>> addOrUpdateFiledAsListOfString(
    String dataKye,
    String filedName,
    String exId,
    Map<String, dynamic> body,
    DbCollection col,
  ) async {
    final dataToUpdateOrAdd = body[filedName.split('.').last] as List;
    final dataToUpdateOrAddAsObjectId = dataToUpdateOrAdd
        .map(
          (id) => ObjectId.parse(
            id.toString(),
          ),
        )
        .toList();
    if (await _isHaseField(dataKye, filedName, exId)) {
      final res = await col.findAndModify(
        query: where.id(
          ObjectId.parse(exId),
        ),
        update: {
          r'$set': {
            filedName: dataToUpdateOrAddAsObjectId,
          },
        },
        upsert: true,
        returnNew: true,
      );
      return Common.sendSuccessResponse(
        statusCode: HttpStatus.ok.toString(),
        message:
            'don update ${filedName.split('.').last} $dataToUpdateOrAddAsObjectId',
        data: res,
      );
    }
    final res = await col.findAndModify(
      query: where.eq(
        '_id',
        ObjectId.parse(exId),
      ),
      update: modify.addEachToSet(
        filedName,
        dataToUpdateOrAddAsObjectId,
      ),
      returnNew: true,
      upsert: true,
    );

    if (res == null) {
      return Common.sendErrorResponse(
        statusCode: HttpStatus.expectationFailed.toString(),
        message: 'No field fond for that ids',
        errorMessage: [
          'Empty update',
        ],
      );
    }
    return Common.sendSuccessResponse(
      statusCode: HttpStatus.ok.toString(),
      message:
          'don add ${filedName.split('.').last} $dataToUpdateOrAddAsObjectId',
      data: res,
    );
  }

  @override
  Future<Map<String, dynamic>> addOrUpdateDWForPat({
    required String exId,
    required Map<String, dynamic> body,
  }) async {
    try {
      if (body['disease'] != null) {
        return addOrUpdateFiledAsListOfString(
          'additional_information',
          'additional_information.disease',
          exId,
          body,
          DatabaseService().medicalExaminationCollection,
        );
      }
      if (body['warning'] != null) {
        return addOrUpdateFiledAsListOfString(
          'additional_information',
          'additional_information.warning',
          exId,
          body,
          DatabaseService().medicalExaminationCollection,
        );
      }
      if (body['medicine'] != null) {
        return addOrUpdateFiledAsListOfString(
          'medical_information',
          'medical_information.medicine',
          exId,
          body,
          DatabaseService().medicalExaminationCollection,
        );
      }
      if (body['test'] != null) {
        return addOrUpdateFiledAsListOfString(
          'medical_information',
          'medical_information.test',
          exId,
          body,
          DatabaseService().medicalExaminationCollection,
        );
      }
      if (body['ray'] != null) {
        return addOrUpdateFiledAsListOfString(
          'medical_information',
          'medical_information.ray',
          exId,
          body,
          DatabaseService().medicalExaminationCollection,
        );
      }
      return Common.sendErrorResponse(
        statusCode: HttpStatus.internalServerError.toString(),
        message: 'Failed to update user',
        errorMessage: [
          'Body must have list of [disease or warning]',
        ],
      );
    } catch (e) {
      return Common.sendErrorResponse(
        statusCode: HttpStatus.internalServerError.toString(),
        message: 'Failed to update user',
        errorMessage: [
          e.toString(),
        ],
      );
    }
  }

  @override
  Future<Map<String, dynamic>> addOrUpdateInfoForPat({
    required String exId,
    required String? infoId,
    required Map<String, dynamic> body,
  }) async {
    try {
      if (body['value'] == null || body['title'] == null) {
        return Common.sendErrorResponse(
          statusCode: HttpStatus.badRequest.toString(),
          message: 'Bad State',
          errorMessage: [
            '$body mus t have one of theme title or value or both',
          ],
        );
      }
      Map<String, dynamic>? updatedPat;
      if (infoId == null) {
        updatedPat =
            await DatabaseService().medicalExaminationCollection.findAndModify(
                  query: where.eq(
                    '_id',
                    ObjectId.parse(exId),
                  ),
                  update: modify.addToSet(
                    'additional_information.info',
                    {
                      ...body,
                      'id': ObjectId().oid,
                    },
                  ),
                  returnNew: true,
                );
        return Common.sendSuccessResponse(
          statusCode: HttpStatus.ok.toString(),
          message: 'Updated Pat',
          data: updatedPat,
        );
      }
      var updateBuilder = ModifierBuilder();
      for (final entry in body.entries) {
        final fieldName = r'additional_information.info.$.' + entry.key;
        final value = entry.value;

        if (value is Map<String, dynamic>) {
          Common.updateOnlyFiledName(updateBuilder, value, fieldName);
        } else {
          updateBuilder = updateBuilder..set(fieldName, value);
        }
      }
      updatedPat =
          await DatabaseService().medicalExaminationCollection.findAndModify(
                query: where.eq(
                  '_id',
                  ObjectId.parse(exId),
                )..eq(
                    'additional_information.info.id',
                    infoId,
                  ),
                update: updateBuilder,
                returnNew: true,
              );

      if (updatedPat == null) {
        return Common.sendErrorResponse(
          statusCode: HttpStatus.expectationFailed.toString(),
          message: 'No field fond for that ids',
          errorMessage: [
            'Empty update',
          ],
        );
      }
      return Common.sendSuccessResponse(
        statusCode: HttpStatus.ok.toString(),
        message: 'Updated Pat',
        data: updatedPat,
      );
    } catch (e) {
      return Common.sendErrorResponse(
        statusCode: HttpStatus.internalServerError.toString(),
        message: 'Failed to update user',
        errorMessage: [
          e.toString(),
        ],
      );
    }
  }

  @override
  Future<Map<String, dynamic>> deleteInfoForPat({
    required String exId,
    required String infoId,
  }) async {
    final updatedPat =
        await DatabaseService().medicalExaminationCollection.findAndModify(
              query: where.eq(
                '_id',
                ObjectId.parse(exId),
              ),
              update: modify.pull(
                'additional_information.info',
                {
                  'id': infoId,
                },
              ),
              returnNew: true,
            );
    return Common.sendSuccessResponse(
      statusCode: HttpStatus.ok.toString(),
      message: 'Updated Pat',
      data: updatedPat,
    );
  }
}
