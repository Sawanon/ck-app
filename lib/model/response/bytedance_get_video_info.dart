class ResponseMetadata {
  final String action;
  final String region;
  final String requestId;
  final String service;
  final String version;

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

class PlayInfo {
  final String backupPlayUrl;
  final int bitrate;
  final String codec;
  final String definition;
  final double duration;
  final String fileId;
  final String fileType;
  final String format;
  final int height;
  final String mainPlayUrl;
  final String md5;
  final String quality;
  final int size;
  final int width;

  PlayInfo({
    required this.backupPlayUrl,
    required this.bitrate,
    required this.codec,
    required this.definition,
    required this.duration,
    required this.fileId,
    required this.fileType,
    required this.format,
    required this.height,
    required this.mainPlayUrl,
    required this.md5,
    required this.quality,
    required this.size,
    required this.width,
  });

  factory PlayInfo.fromJson(Map<String, dynamic> json) {
    return PlayInfo(
      backupPlayUrl: json['BackupPlayUrl'],
      bitrate: json['Bitrate'],
      codec: json['Codec'],
      definition: json['Definition'],
      duration: json['Duration'],
      fileId: json['FileId'],
      fileType: json['FileType'],
      format: json['Format'],
      height: json['Height'],
      mainPlayUrl: json['MainPlayUrl'],
      md5: json['Md5'],
      quality: json['Quality'],
      size: json['Size'],
      width: json['Width'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BackupPlayUrl': backupPlayUrl,
      'Bitrate': bitrate,
      'Codec': codec,
      'Definition': definition,
      'Duration': duration,
      'FileId': fileId,
      'FileType': fileType,
      'Format': format,
      'Height': height,
      'MainPlayUrl': mainPlayUrl,
      'Md5': md5,
      'Quality': quality,
      'Size': size,
      'Width': width,
    };
  }
}

class Result {
  final double duration;
  final String fileType;
  final List<PlayInfo> playInfoList;
  final int status;
  final int totalCount;
  final int version;
  final String vid;
  final String? posterUrl;

  Result({
    required this.duration,
    required this.fileType,
    required this.playInfoList,
    required this.status,
    required this.totalCount,
    required this.version,
    required this.vid,
    this.posterUrl,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    var list = json['PlayInfoList'] as List;
    List<PlayInfo> playInfoList =
        list.map((i) => PlayInfo.fromJson(i)).toList();

    return Result(
      duration: json['Duration'],
      fileType: json['FileType'],
      playInfoList: playInfoList,
      status: json['Status'],
      totalCount: json['TotalCount'],
      version: json['Version'],
      vid: json['Vid'],
      posterUrl: json['PosterUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Duration': duration,
      'FileType': fileType,
      'PlayInfoList': playInfoList.map((v) => v.toJson()).toList(),
      'Status': status,
      'TotalCount': totalCount,
      'Version': version,
      'Vid': vid,
      'PosterUrl': posterUrl,
    };
  }
}

class BytedanceGetVideoInfo {
  final ResponseMetadata responseMetadata;
  final Result result;

  BytedanceGetVideoInfo({
    required this.responseMetadata,
    required this.result,
  });

  factory BytedanceGetVideoInfo.fromJson(Map<String, dynamic> json) {
    return BytedanceGetVideoInfo(
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
