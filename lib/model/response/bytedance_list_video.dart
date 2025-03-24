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

class BasicInfo {
  final String createTime;
  final String posterUri;
  final String publishStatus;
  final String spaceName;
  final String title;
  final String tosStorageClass;
  final String vid;

  BasicInfo({
    required this.createTime,
    required this.posterUri,
    required this.publishStatus,
    required this.spaceName,
    required this.title,
    required this.tosStorageClass,
    required this.vid,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      createTime: json['CreateTime'],
      posterUri: json['PosterUri'],
      publishStatus: json['PublishStatus'],
      spaceName: json['SpaceName'],
      title: json['Title'],
      tosStorageClass: json['TosStorageClass'],
      vid: json['Vid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CreateTime': createTime,
      'PosterUri': posterUri,
      'PublishStatus': publishStatus,
      'SpaceName': spaceName,
      'Title': title,
      'TosStorageClass': tosStorageClass,
      'Vid': vid,
    };
  }
}

class AudioStreamMeta {
  final int? bitrate;
  final double? duration;
  final int? sampleRate;

  AudioStreamMeta({
    this.bitrate,
    this.duration,
    this.sampleRate,
  });

  factory AudioStreamMeta.fromJson(Map<String, dynamic> json) {
    return AudioStreamMeta(
      bitrate: json['Bitrate'],
      duration: json['Duration'],
      sampleRate: json['SampleRate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Bitrate': bitrate,
      'Duration': duration,
      'SampleRate': sampleRate,
    };
  }
}

class VideoStreamMeta {
  final int bitrate;
  final String codec;
  final String definition;
  final double duration;
  final int fps;
  final int height;
  final int width;

  VideoStreamMeta({
    required this.bitrate,
    required this.codec,
    required this.definition,
    required this.duration,
    required this.fps,
    required this.height,
    required this.width,
  });

  factory VideoStreamMeta.fromJson(Map<String, dynamic> json) {
    return VideoStreamMeta(
      bitrate: json['Bitrate'],
      codec: json['Codec'],
      definition: json['Definition'],
      duration: json['Duration'],
      fps: json['Fps'],
      height: json['Height'],
      width: json['Width'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Bitrate': bitrate,
      'Codec': codec,
      'Definition': definition,
      'Duration': duration,
      'Fps': fps,
      'Height': height,
      'Width': width,
    };
  }
}

class SourceInfo {
  final AudioStreamMeta audioStreamMeta;
  final int bitrate;
  final String codec;
  final String createTime;
  final String definition;
  final double duration;
  final String dynamicRange;
  final String fileId;
  final String fileType;
  final String format;
  final int fps;
  final int height;
  final String md5;
  final int size;
  final String storeUri;
  final String tosStorageClass;
  final VideoStreamMeta videoStreamMeta;
  final int width;

  SourceInfo({
    required this.audioStreamMeta,
    required this.bitrate,
    required this.codec,
    required this.createTime,
    required this.definition,
    required this.duration,
    required this.dynamicRange,
    required this.fileId,
    required this.fileType,
    required this.format,
    required this.fps,
    required this.height,
    required this.md5,
    required this.size,
    required this.storeUri,
    required this.tosStorageClass,
    required this.videoStreamMeta,
    required this.width,
  });

  factory SourceInfo.fromJson(Map<String, dynamic> json) {
    return SourceInfo(
      audioStreamMeta: AudioStreamMeta.fromJson(json['AudioStreamMeta']),
      bitrate: json['Bitrate'],
      codec: json['Codec'],
      createTime: json['CreateTime'],
      definition: json['Definition'],
      duration: json['Duration'],
      dynamicRange: json['DynamicRange'],
      fileId: json['FileId'],
      fileType: json['FileType'],
      format: json['Format'],
      fps: json['Fps'],
      height: json['Height'],
      md5: json['Md5'],
      size: json['Size'],
      storeUri: json['StoreUri'],
      tosStorageClass: json['TosStorageClass'],
      videoStreamMeta: VideoStreamMeta.fromJson(json['VideoStreamMeta']),
      width: json['Width'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AudioStreamMeta': audioStreamMeta.toJson(),
      'Bitrate': bitrate,
      'Codec': codec,
      'CreateTime': createTime,
      'Definition': definition,
      'Duration': duration,
      'DynamicRange': dynamicRange,
      'FileId': fileId,
      'FileType': fileType,
      'Format': format,
      'Fps': fps,
      'Height': height,
      'Md5': md5,
      'Size': size,
      'StoreUri': storeUri,
      'TosStorageClass': tosStorageClass,
      'VideoStreamMeta': videoStreamMeta.toJson(),
      'Width': width,
    };
  }
}

class MediaInfo {
  final BasicInfo basicInfo;
  final SourceInfo sourceInfo;

  MediaInfo({
    required this.basicInfo,
    required this.sourceInfo,
  });

  factory MediaInfo.fromJson(Map<String, dynamic> json) {
    return MediaInfo(
      basicInfo: BasicInfo.fromJson(json['BasicInfo']),
      sourceInfo: SourceInfo.fromJson(json['SourceInfo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BasicInfo': basicInfo.toJson(),
      'SourceInfo': sourceInfo.toJson(),
    };
  }
}

class Result {
  final List<MediaInfo> mediaInfoList;
  final int pageSize;
  final String spaceName;
  final int totalCount;

  Result({
    required this.mediaInfoList,
    required this.pageSize,
    required this.spaceName,
    required this.totalCount,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    var list = json['MediaInfoList'] as List;
    List<MediaInfo> mediaInfoList =
        list.map((i) => MediaInfo.fromJson(i)).toList();

    return Result(
      mediaInfoList: mediaInfoList,
      pageSize: json['PageSize'],
      spaceName: json['SpaceName'],
      totalCount: json['TotalCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MediaInfoList': mediaInfoList.map((e) => e.toJson()).toList(),
      'PageSize': pageSize,
      'SpaceName': spaceName,
      'TotalCount': totalCount,
    };
  }
}

class ByteDanceListVideo {
  final ResponseMetadata responseMetadata;
  final Result result;

  ByteDanceListVideo({
    required this.responseMetadata,
    required this.result,
  });

  factory ByteDanceListVideo.fromJson(Map<String, dynamic> json) {
    return ByteDanceListVideo(
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
