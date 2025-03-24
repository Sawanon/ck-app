class BytedanceResponse {
  ResponseMetadata responseMetadata;
  Result result;

  BytedanceResponse({required this.responseMetadata, required this.result});

  factory BytedanceResponse.fromJson(Map<String, dynamic> json) {
    return BytedanceResponse(
      responseMetadata: ResponseMetadata.fromJson(json['ResponseMetadata']),
      result: Result.fromJson(json['Result']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ResponseMetadata': responseMetadata.toJson(),
      'Result': result.toJson(),
    };
  }
}

class ResponseMetadata {
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

  factory ResponseMetadata.fromJson(Map<String, dynamic> json) {
    return ResponseMetadata(
      action: json['Action'],
      region: json['Region'],
      requestId: json['RequestId'],
      service: json['Service'],
      version: json['Version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Action': action,
      'Region': region,
      'RequestId': requestId,
      'Service': service,
      'Version': version,
    };
  }
}

class Result {
  List<ClassificationTree> classificationTrees;

  Result({required this.classificationTrees});

  factory Result.fromJson(Map<String, dynamic> json) {
    var list = json['ClassificationTrees'] as List;
    List<ClassificationTree> classificationTreesList =
        list.map((i) => ClassificationTree.fromJson(i)).toList();

    return Result(classificationTrees: classificationTreesList);
  }

  Map<String, dynamic> toJson() {
    return {
      'ClassificationTrees':
          classificationTrees.map((v) => v.toJson()).toList(),
    };
  }
}

class ClassificationTree {
  String classification;
  int classificationId;
  String createdAt;
  int level;
  String spaceName;
  List<SubClassificationTree> subClassificationTrees;

  ClassificationTree({
    required this.classification,
    required this.classificationId,
    required this.createdAt,
    required this.level,
    required this.spaceName,
    required this.subClassificationTrees,
  });

  factory ClassificationTree.fromJson(Map<String, dynamic> json) {
    var list = json['SubClassificationTrees'] as List;
    List<SubClassificationTree> subClassificationTreesList =
        list.map((i) => SubClassificationTree.fromJson(i)).toList();

    return ClassificationTree(
      classification: json['Classification'],
      classificationId: json['ClassificationId'],
      createdAt: json['CreatedAt'],
      level: json['Level'],
      spaceName: json['SpaceName'],
      subClassificationTrees: subClassificationTreesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Classification': classification,
      'ClassificationId': classificationId,
      'CreatedAt': createdAt,
      'Level': level,
      'SpaceName': spaceName,
      'SubClassificationTrees':
          subClassificationTrees.map((v) => v.toJson()).toList(),
    };
  }
}

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

  factory SubClassificationTree.fromJson(Map<String, dynamic> json) {
    return SubClassificationTree(
      classification: json['Classification'],
      classificationId: json['ClassificationId'],
      createdAt: json['CreatedAt'],
      level: json['Level'],
      parentClassificationId: json['ParentClassificationId'],
      spaceName: json['SpaceName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Classification': classification,
      'ClassificationId': classificationId,
      'CreatedAt': createdAt,
      'Level': level,
      'ParentClassificationId': parentClassificationId,
      'SpaceName': spaceName,
    };
  }
}
