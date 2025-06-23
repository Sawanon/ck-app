class GetMyReward {
  String wheelId;
  String? userId;
  String? rewardId;
  bool? isReceive;
  String? type;
  String $createdAt;

  GetMyReward({
    required this.wheelId,
    this.userId,
    this.rewardId,
    this.isReceive,
    this.type,
    required this.$createdAt,
  });

  static GetMyReward fromJson(Map json) => GetMyReward(
        wheelId: json['wheelId'],
        userId: json['userId'],
        rewardId: json['rewardId'],
        isReceive: json['is_receive'],
        type: json['type'],
        $createdAt: json['\$createdAt'],
      );

  Map toJson() => {
        "wheelId": wheelId,
        "userId": userId,
        "rewardId": rewardId,
        "is_receive": isReceive,
        "type": type,
        "\$createdAt": $createdAt,
      };
}
