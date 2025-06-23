class ListMyGroup {
  String $id;
  String name;
  String? value;

  ListMyGroup({
    required this.$id,
    required this.name,
    this.value,
  });

  static ListMyGroup fromJson(Map json) => ListMyGroup(
        $id: json['\$id'],
        name: json['name'],
        value: json['value'],
      );

  Map toJson() => {
        "\$id": $id,
        "name": name,
        "value": value,
      };
}
