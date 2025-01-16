// {
//   "ResponseMetadata": {
//     "Action": "ListVideoClassifications",
//     "Region": "ap-singapore-1",
//     "RequestId": "202501160326042D5EA4F6AB8BD1138ED6",
//     "Service": "vod",
//     "Version": "2023-01-01"
//   },
//   "Result": {
//     "ClassificationTrees": [
//       {
//         "Classification": "lottery",
//         "ClassificationId": 8864,
//         "CreatedAt": "2025-01-14T04:12:27Z",
//         "Level": 1,
//         "SpaceName": "ck-lotto-space",
//         "SubClassificationTrees": [
//           {
//             "Classification": "horoscopeToday",
//             "ClassificationId": 8870,
//             "CreatedAt": "2025-01-14T04:13:28Z",
//             "Level": 2,
//             "ParentClassificationId": 8864,
//             "SpaceName": "ck-lotto-space"
//           },
//           {
//             "Classification": "luckyNumber",
//             "ClassificationId": 8881,
//             "CreatedAt": "2025-01-14T04:15:38Z",
//             "Level": 2,
//             "ParentClassificationId": 8864,
//             "SpaceName": "ck-lotto-space"
//           }
//         ]
//       }
//     ]
//   }
// }

class SubClassificationTree {
  String classification;
  int classificationId;
  String createdAt;
  int level;
  int parentClassificationId;
  String spaceName;

  SubClassificationTree({
    required this.classification,
    required this.classificationId,
    required this.createdAt,
    required this.level,
    required this.parentClassificationId,
    required this.spaceName,
  });

  static SubClassificationTree fromJson(Map json) => SubClassificationTree(
        classification: json['Classification'],
        classificationId: json['ClassificationId'],
        createdAt: json['CreatedAt'],
        level: json['Level'],
        parentClassificationId: json['ParentClassificationId'],
        spaceName: json['SpaceName'],
      );
}

class ClassificationTrees {
  String classification;
  int classificationId;
  String createdAt;
  int level;
  String spaceName;
  List<SubClassificationTree> subClassificationTrees;

  ClassificationTrees({
    required this.classification,
    required this.classificationId,
    required this.createdAt,
    required this.level,
    required this.spaceName,
    required this.subClassificationTrees,
  });

  static ClassificationTrees fromJson(Map json) => ClassificationTrees(
        classification: json['Classification'],
        classificationId: json['ClassificationId'],
        createdAt: json['CreatedAt'],
        level: json['Level'],
        spaceName: json['SpaceName'],
        subClassificationTrees: (json['SubClassificationTrees'] as List<Map>)
            .map((json) => SubClassificationTree.fromJson(json))
            .toList(),
      );
}

class ResponseMetadata {
//     "Action": "ListVideoClassifications",
//     "Region": "ap-singapore-1",
//     "RequestId": "202501160326042D5EA4F6AB8BD1138ED6",
//     "Service": "vod",
//     "Version": "2023-01-01"
  String action;
  String region;
  String requestId;
  String service;
  String version;
  ResponseMetadata({
    required this.action,
    required this.region,
    required this.requestId,
    required this.service,
    required this.version,
  });
}

class ResponseListCategories {
  // ResponseMetadata
  ResponseMetadata responseMetadata;
  List<ClassificationTrees> classificationTrees;

  ResponseListCategories({
    required this.responseMetadata,
    required this.classificationTrees,
  });
}
