import 'package:canabs/models/categorymodels.dart';

class CartItem {
  Category? category;
  int units;

  CartItem({this.category, this.units = 0});
}
