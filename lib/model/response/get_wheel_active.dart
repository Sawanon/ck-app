class GetWheelActive {
  String type;
  DateTime startDate;
  DateTime endDate;
  String detail;
  String? imageUrl;
  String name;
  List<String> groupUser;
  String $id;
  List<WheelReward> wheelRewards;

  GetWheelActive({
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.detail,
    this.imageUrl,
    required this.name,
    required this.groupUser,
    required this.$id,
    required this.wheelRewards,
  });

  static GetWheelActive fromJson(Map json) => GetWheelActive(
        type: json['type'],
        startDate: DateTime.parse(json['start_date']),
        endDate: DateTime.parse(json['end_date']),
        detail: json['detail'],
        imageUrl: json['imageUrl'],
        name: json['name'],
        groupUser: (json['group_user'] as List)
            .map((group) => group.toString())
            .toList(),
        $id: json['\$id'],
        wheelRewards: (json['wheelRewards'] as List)
            .map((wheelReward) => WheelReward.fromJson(wheelReward))
            .toList(),
      );

  Map toJson() => {
        "type": type,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "detail": detail,
        "imageUrl": imageUrl,
        "name": name,
        "groupUser": groupUser,
        "\$id": $id,
        "wheelRewards":
            wheelRewards.map((wheelReward) => wheelReward.toJson()).toList(),
      };
}

class WheelReward {
  String type;
  String? imageUrl;
  double? amount;
  int? quantity;
  int order;
  String? label;
  bool isBigReward;
  SpinRewardsResults? spinRewardsResults;

  WheelReward({
    required this.type,
    this.imageUrl,
    this.amount,
    this.quantity,
    required this.order,
    this.label,
    required this.isBigReward,
    this.spinRewardsResults,
  });

  static WheelReward fromJson(Map json) => WheelReward(
        type: json['type'],
        imageUrl: json['imageUrl'],
        amount:
            json['amount'] is num ? (json['amount'] as num).toDouble() : null,
        quantity: json['quantity'],
        order: json['order'],
        label: json['label'],
        isBigReward: json['is_big_reward'],
        spinRewardsResults: json['spinRewardsResults'] != null
            ? SpinRewardsResults.fromJson(json['spinRewardsResults'])
            : null,
      );

  Map toJson() => {
        "type": type,
        "imageUrl": imageUrl,
        "amount": amount,
        "quantity": quantity,
        "order": order,
        "label": label,
        "isBigReward": isBigReward,
        "spinRewardsResults": spinRewardsResults?.toJson(),
      };
}

class SpinRewardsResults {
  int? count;
  String? wheelId;

  SpinRewardsResults({
    this.count,
    this.wheelId,
  });

  static SpinRewardsResults fromJson(Map json) => SpinRewardsResults(
        count: json['count'],
        wheelId: json['wheelId'],
      );

  Map toJson() => {
        "count": count,
        "wheelId": wheelId,
      };
}

final data = {
  "type": "register",
  "start_date": "2025-06-03T13:30:42.613+00:00",
  "end_date": "2025-06-13T13:00:42.613+00:00",
  "is_reuse": false,
  "detail": "test Promotion",
  "imageUrl":
      "https://baas.moevedigital.com/v1/storage/buckets/promotions_image/files/683ff18f000c35b1b620/view?project=667afb24000fbd66b4df",
  "name": "Lucky Wheel",
  "group_user": ["66b0369b001651b9cbff"],
  "big_reward_people": 10,
  "\$id": "683f181d0014d8adb934",
  "\$createdAt": "2025-06-03T15:43:26.102+00:00",
  "\$updatedAt": "2025-06-05T07:30:29.044+00:00",
  "\$permissions": [],
  "wheelRewards": [
    {
      "type": "point",
      "imageUrl":
          "https://baas.moevedigital.com/v1/storage/buckets/promotions_image/files/683fef1d00112c95f085/view?project=667afb24000fbd66b4df",
      "amount": 500000,
      "quantity": 10,
      "order": 4,
      "label": "point",
      "is_big_reward": true,
      "\$id": "683fef1f000287245360",
      "\$createdAt": "2025-06-04T07:00:48.634+00:00",
      "\$updatedAt": "2025-06-05T07:30:29.049+00:00",
      "\$permissions": [],
      "spinRewardsResults": null,
      "\$databaseId": "lottory",
      "\$collectionId": "wheel_rewards"
    },
    {
      "type": "point",
      "imageUrl": null,
      "amount": 2000,
      "quantity": 0,
      "order": 2,
      "label": "2000",
      "is_big_reward": false,
      "\$id": "683fef1f0002954c1c8b",
      "\$createdAt": "2025-06-04T07:00:48.653+00:00",
      "\$updatedAt": "2025-06-05T07:30:29.057+00:00",
      "\$permissions": [],
      "spinRewardsResults": null,
      "\$databaseId": "lottory",
      "\$collectionId": "wheel_rewards"
    },
    {
      "type": "point",
      "imageUrl": null,
      "amount": 1000,
      "quantity": 0,
      "order": 1,
      "label": "1000",
      "is_big_reward": false,
      "\$id": "683fef1f00026915dc9f",
      "\$createdAt": "2025-06-04T07:00:48.656+00:00",
      "\$updatedAt": "2025-06-05T07:30:29.065+00:00",
      "\$permissions": [],
      "spinRewardsResults": null,
      "\$databaseId": "lottory",
      "\$collectionId": "wheel_rewards"
    },
    {
      "type": "point",
      "imageUrl": null,
      "amount": 5000,
      "quantity": 15,
      "order": 3,
      "label": "5000",
      "is_big_reward": false,
      "\$id": "683ff22a00215c0558b3",
      "\$createdAt": "2025-06-04T07:13:48.156+00:00",
      "\$updatedAt": "2025-06-05T07:30:29.075+00:00",
      "\$permissions": [],
      "spinRewardsResults": null,
      "\$databaseId": "lottory",
      "\$collectionId": "wheel_rewards"
    }
  ],
  "\$databaseId": "lottory",
  "\$collectionId": "wheel_promotions"
};
