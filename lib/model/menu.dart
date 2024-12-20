import 'package:flutter/material.dart';

class MenuModel {
  void Function() ontab;
  Widget icon;
  Widget name;
  bool? disabled;

  MenuModel({
    required this.ontab,
    required this.icon,
    required this.name,
    this.disabled,
  });
}
