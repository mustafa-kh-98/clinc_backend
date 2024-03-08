// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:clinic/core/common/response.dart';
import 'package:clinic/data/data_servier.dart';
import 'package:clinic/models/medical_examination/more_information.dart';
import 'package:clinic/models/user/doctor_model.dart';
import 'package:clinic/models/user/employee_model.dart';
import 'package:clinic/models/user/patient_model.dart';
import 'package:clinic/models/user/user_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

abstract class _BaseUserProvider {
  Future<Map<String, dynamic>> addUser(
      {required Map<String, dynamic> userBody});

  Future<Map<String, dynamic>> fetchAllUsers({
    required int? page,
    required int? limit,
  });

  Future<Map<String, dynamic>> getUserById({required String id});

  Future<Map<String, dynamic>> getUserByType({required List<String> type});

  Future<Map<String, dynamic>> updateUserById({
    required Map<String, dynamic> userBody,
    required String id,
  });

  Future<Map<String, dynamic>> deleteUsers({required List<String> ids});

  Future<Map<String, dynamic>> searchForPat({
    required String search,
    List<String>? searchIn,
  });
}

class UserProviderImpl extends _BaseUserProvider {
  @override
  Future<Map<String, dynamic>> addUser({
    required Map<String, dynamic> userBody,
  }) async {
    var isValid = true;
    final errors = <String>[];
    var userType = [];
    var user = const UserModel();
    EmployeeModel? emp = const EmployeeModel();
    DoctorModel? doc = const DoctorModel();
    PatientModel? pat = const PatientModel();
    if (userBody['type'] == null) {
      errors.add('user type must not be empty');
      isValid = false;
    }
    if (userBody['name'] == null) {
      errors.add('name must not be empty');
      isValid = false;
    }

    if (userBody['gender'] == null) {
      errors.add('gender must not be empty');
      isValid = false;
    }

    if (userBody['birth_day'] == null) {
      errors.add('birthDay must not be empty');
      isValid = false;
    }

    if (userBody['phone'] == null) {
      errors.add('phone must not be empty');
      isValid = false;
    }

    if (!isValid) {
      return Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'error on add user',
        errorMessage: errors,
      );
    }

    userType = userBody['type'] as List;

    if (userType.contains('employee')) {
      emp = emp.copyWith(
        salary: userBody['salary'] as String,
        workStartDate: DateTime.parse(userBody['work_start_date'] as String),
        jopTitle: userBody['medical_specialization'] as String,
      );
    }

    if (userType.contains('doctor')) {
      doc = doc.copyWith(
        salary: userBody['salary'] as String,
        workStartDate: DateTime.parse(userBody['work_start_date'] as String),
        medicalSpecialization: userBody['medical_specialization'] as String,
      );
    }
    if (userType.contains('patient')) {
      final info = AdditionalInformationModel(
        info: [
          InformationModel(
            id: ObjectId().oid,
            type: 'weight',
            title: 'weight',
            value: userBody['weight'] as String,
          ),
          InformationModel(
            id: ObjectId().oid,
            type: 'length',
            title: 'length',
            value: userBody['length'] as String,
          ),
          InformationModel(
            id: ObjectId().oid,
            type: 'job',
            title: 'job',
            value: userBody['job'] as String,
          ),
          if (userBody['smoker'] != null)
            InformationModel(
              id: ObjectId().oid,
              title: 'smoker',
              type: 'smoker',
              value: userBody['smoker'],
            ),
          if (userBody['alcoholic'] != null)
            InformationModel(
              id: ObjectId().oid,
              title: 'alcoholic',
              type: 'alcoholic',
              value: userBody['alcoholic'],
            ),
        ],
      );

      final userRes = <String, dynamic>{
        'additional_information': info.toJson(),
      };

      final result =
          await DatabaseService().medicalExaminationCollection.insertOne(
                Common.removeNullFromMap(userRes),
              );

      pat = pat.copyWith(
        registrationDate: DateTime.parse(
          userBody['registration_date'] as String,
        ),
        additionalInformation: result.document!['_id']! as ObjectId,
      );
    }

    user = user.copyWith(
      birthDay: DateTime.parse(userBody['birth_day'] as String),
      gender: userBody['gender'] as String,
      name: userBody['name'] as String,
      phone: userBody['phone'] as String,
      userName: userBody['user_name'] as String?,
      email: userBody['email'] as String?,
      image: userBody['image'] as String?,
      address: userBody['address'] as String,
      employeeModel: emp.workStartDate == null ? null : emp,
      doctorModel: doc.workStartDate == null ? null : doc,
      patient: pat.registrationDate == null ? null : pat,
      userType: userType.map((e) => e.toString()).toList(),
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
    final toDb = user.toJson();

    final result = await DatabaseService().userCollection.insertOne(
          Common.removeNullFromMap(toDb),
        );

    if (userType.contains('patient')) {
      final patData = {...result.document ?? {}}
        ..remove('patient')
        ..remove(
          'user_type',
        );

      await DatabaseService().medicalExaminationCollection.findAndModify(
            query: where.id(
              ObjectId.parse(user.patient!.additionalInformation!),
            ),
            update: {
              r'$set': {
                'patient': patData,
              },
            },
            upsert: true,
          );
    }

    return Common.sendSuccessResponse(
      statusCode: HttpStatus.ok.toString(),
      message: 'Add $userType',
      data: {
        '_id': result.document!['_id'],
        'name': result.document!['name'],
        'user_type': userType,
      },
    );
  }

  @override
  Future<Map<String, dynamic>> fetchAllUsers({
    required int? page,
    required int? limit,
  }) async {
    final List<Map<String, dynamic>> users;
    if (page != null && limit != null) {
      final skipItems = (page - 1) * limit;
      users = await DatabaseService()
          .userCollection
          .find(
            where.sortBy('updated_at', descending: true).skip(skipItems).limit(
                  limit,
                ),
          )
          .toList();
    } else {
      users = await DatabaseService().userCollection.find().toList();
    }
    return Common.sendSuccessResponse(
      statusCode: HttpStatus.ok.toString(),
      message: 'All users',
      data: users,
    );
  }

  @override
  Future<Map<String, dynamic>> getUserById({required String id}) async {
    final userId = ObjectId.parse(id);

    Map<String, dynamic>? user;
    user = await DatabaseService().userCollection.modernAggregate(
      [
        {
          r'$match': {
            '_id': {r'$eq': userId},
          },
        },
        {
          r'$facet': {
            'patientMatch': [
              {
                r'$match': {
                  'user_type': 'patient',
                },
              },
              {
                r'$lookup': {
                  'from': DatabaseService()
                      .medicalExaminationCollection
                      .collectionName,
                  'let': {
                    'infoId': {
                      r'$toObjectId': r'$patient.additional_information',
                    },
                    'info': r'$info',
                  },
                  'pipeline': [
                    {
                      r'$match': {
                        r'$expr': {
                          r'$eq': [r'$_id', r'$$infoId'],
                        },
                      },
                    },
                    {
                      r'$group': {
                        '_id': r'$additional_information.info',
                      },
                    },
                    {
                      r'$replaceRoot': {
                        'newRoot': {
                          r'$mergeObjects': [r'$$info', r'$$ROOT'],
                        },
                      },
                    },
                  ],
                  'as': 'patient.additional_information',
                },
              },
              {
                r'$unwind': r'$patient.additional_information',
              },
            ],
            'otherMatch': [
              {
                r'$match': {
                  'user_type': {r'$ne': 'patient'},
                },
              },
            ],
          },
        },
        {
          r'$project': {
            'result': {
              r'$cond': {
                'if': {
                  r'$gt': [
                    {r'$size': r'$patientMatch'},
                    0,
                  ],
                },
                'then': r'$patientMatch',
                'else': r'$otherMatch',
              },
            },
          },
        },
        {
          r'$unwind': r'$result',
        },
        {
          r'$replaceRoot': {
            'newRoot': r'$result',
          },
        },
      ],
    ).first;
    return Common.sendSuccessResponse(
      statusCode: HttpStatus.ok.toString(),
      message: 'find user',
      data: user,
    );
  }

  @override
  Future<Map<String, dynamic>> deleteUsers({required List<String> ids}) async {
    final ids0 = ids.map(ObjectId.parse).toList();

    try {
      final result = await DatabaseService().userCollection.deleteMany(
        {
          '_id': {
            r'$in': ids0,
          },
        },
      );
      return Common.sendSuccessResponse(
        statusCode: HttpStatus.ok.toString(),
        message: 'All users',
        data: {
          'status': 'delete ${result.nRemoved}',
        },
      );
    } catch (e) {
      return Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'error on add user',
        errorMessage: [e.toString()],
      );
    }
  }

  @override
  Future<Map<String, dynamic>> updateUserById({
    required Map<String, dynamic> userBody,
    required String id,
  }) async {
    final userId = ObjectId.parse(id);
    try {
      final updateDocument = {
        r'$set': userBody,
      };

      updateDocument[r'$set']?['updated_at'] = DateTime.now().toIso8601String();

      await DatabaseService().userCollection.updateOne(
            where.id(userId),
            updateDocument,
          );
      final updatedUser =
          await DatabaseService().userCollection.findOne(where.id(userId)) ??
              {};
      return Common.sendSuccessResponse(
        statusCode: HttpStatus.ok.toString(),
        message: 'Updated User',
        data: updatedUser,
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
  Future<Map<String, dynamic>> getUserByType({
    required List<String> type,
  }) async {
    if (type.contains('doctor') ||
        type.contains('employee') ||
        type.contains('patient')) {
      try {
        if (type.contains('patient')) {
          final result =
              await DatabaseService().userCollection.modernAggregate([
            {
              r'$match': {
                'user_type': {
                  r'$in': type,
                },
              },
            },
            {
              r'$lookup': {
                'from': DatabaseService()
                    .medicalExaminationCollection
                    .collectionName,
                'let': {
                  'infoId': {
                    r'$toObjectId': r'$patient.additional_information',
                  },
                  'info': r'$info',
                },
                'pipeline': [
                  {
                    r'$match': {
                      r'$expr': {
                        r'$eq': [r'$_id', r'$$infoId'],
                      },
                    },
                  },
                  {
                    r'$group': {
                      '_id': r'$additional_information.info',
                    },
                  },
                  {
                    r'$replaceRoot': {
                      'newRoot': {
                        r'$mergeObjects': [r'$$info', r'$$ROOT'],
                      },
                    },
                  },
                ],
                'as': 'patient.additional_information',
              },
            },
            {
              r'$unwind': r'$patient.additional_information',
            },
          ]).toList();
          return Common.sendSuccessResponse(
            statusCode: HttpStatus.ok.toString(),
            message: 'Find ${result.length} for that type $type',
            data: result,
          );
        }

        final result = await DatabaseService().userCollection.find(
          {
            'user_type': {
              r'$in': type,
            },
          },
        ).toList();
        return Common.sendSuccessResponse(
          statusCode: HttpStatus.ok.toString(),
          message: 'Find ${result.length} for that type $type',
          data: result,
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
    } else {
      return Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'Failed to update user',
        errorMessage: [
          'that type $type is not here use {doctor ,employee or patient}',
        ],
      );
    }
  }

  @override
  Future<Map<String, dynamic>> searchForPat({
    required String search,
    List<String>? searchIn,
  }) async {
    // {
    //         if (searchIn != null && searchIn.isNotEmpty)
    //           'user_type': {
    //             r'$in': searchIn,
    //           },
    //         'name': {
    //           r'$regex': search,
    //           r'$options': 'i',
    //         },
    //       },
    final results = await DatabaseService().userCollection.modernAggregate(
      [
        {
          if (searchIn != null && searchIn.isNotEmpty)
            r'$match': {
              'user_type': {
                r'$in': searchIn,
              },
            },
        },
        {
          r'$match': {
            'name': {
              r'$regex': search,
              r'$options': 'i',
            },
          },
        },
        {
          r'$group': {
            '_id': r'$_id',
            'name': {
              r'$first': r'$name',
            },
            'phone': {
              r'$first': r'$phone',
            },
          },
        },
      ],
    ).toList();
    return Common.sendSuccessResponse(
      statusCode: HttpStatus.ok.toString(),
      message: 'Find ${results.length} on search in  $searchIn',
      data: results,
    );
  }
}
