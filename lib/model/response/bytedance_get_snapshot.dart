class BytedanceGetSnapshotResponse {
  ResponseMetadata responseMetadata;
  Result result;

  BytedanceGetSnapshotResponse(
      {required this.responseMetadata, required this.result});

  factory BytedanceGetSnapshotResponse.fromJson(Map<String, dynamic> json) {
    return BytedanceGetSnapshotResponse(
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

  ResponseMetadata(
      {required this.action,
      required this.region,
      required this.requestId,
      required this.service,
      required this.version});

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
  List<AnimatedPosterSnapshot> animatedPosterSnapshots;
  String spaceName;
  String vid;

  Result(
      {required this.animatedPosterSnapshots,
      required this.spaceName,
      required this.vid});

  factory Result.fromJson(Map<String, dynamic> json) {
    var list = json['AnimatedPosterSnapshots'] as List;
    List<AnimatedPosterSnapshot> animatedPosterSnapshotsList =
        list.map((i) => AnimatedPosterSnapshot.fromJson(i)).toList();

    return Result(
      animatedPosterSnapshots: animatedPosterSnapshotsList,
      spaceName: json['SpaceName'],
      vid: json['Vid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AnimatedPosterSnapshots':
          animatedPosterSnapshots.map((v) => v.toJson()).toList(),
      'SpaceName': spaceName,
      'Vid': vid,
    };
  }
}

class AnimatedPosterSnapshot {
  String format;
  int height;
  String storeUri;
  String url;
  int width;

  AnimatedPosterSnapshot(
      {required this.format,
      required this.height,
      required this.storeUri,
      required this.url,
      required this.width});

  factory AnimatedPosterSnapshot.fromJson(Map<String, dynamic> json) {
    return AnimatedPosterSnapshot(
      format: json['Format'],
      height: json['Height'],
      storeUri: json['StoreUri'],
      url: json['Url'],
      width: json['Width'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Format': format,
      'Height': height,
      'StoreUri': storeUri,
      'Url': url,
      'Width': width,
    };
  }
}
