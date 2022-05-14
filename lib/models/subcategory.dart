import 'package:canabs/models/categorymodels.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'categorylevel.dart';

class SubCategory extends Category {
  List<CategoryDepartment> departments;
  LatLng? destination;

  SubCategory({
    this.departments = const [],
    String? name,
    Icon? icon,
    String? imgName,
    Color? color,
    this.destination,
  }) : super(
          color: color,
          name: name,
          icon: icon,
          imgName: imgName,
        );
}
