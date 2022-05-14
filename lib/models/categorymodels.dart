import 'package:flutter/material.dart';

class Category {
  String? name;
  String? imgName;
  Icon? icon;
  Color? color;
  List<Category>? subCategories;

  Category(
      {this.name, this.icon, this.color, this.imgName, this.subCategories});
}
