import 'package:canabs/models/categorymodels.dart';
import 'package:canabs/models/subcategory.dart';
import 'package:flutter/cupertino.dart';

class CategorySelectionService extends ChangeNotifier {
  Category? _selectedCategory;
  SubCategory? _selectedSubCategory;

  Category get selectedCategory => _selectedCategory!;
  set selectedCategory(Category value) {
    _selectedCategory = value;
    notifyListeners();
  }

  SubCategory get selectedSubCategory => _selectedSubCategory!;
  set selectedSubCategory(SubCategory value) {
    _selectedSubCategory = value;
    notifyListeners();
  }
}
