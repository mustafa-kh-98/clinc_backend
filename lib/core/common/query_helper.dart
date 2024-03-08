class QueryHelper {
  static Map<String, Object> lookup({
    required String form,
    required String field,
    required String fField,
  }) =>
      {
        r'$lookup': {
          'from': form,
          'localField': field,
          'foreignField': fField,
          'as': field,
        },
      };

  static Map<String, Object> match({
    required String field,
    required Map<String, Object> query,
  }) =>
      {
        r'$match': {
          field : query,
        },
      };

}
