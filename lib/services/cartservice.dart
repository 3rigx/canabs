import 'dart:collection';

import 'package:canabs/models/cartitem.dart';
import 'package:canabs/models/subcategory.dart';
import 'package:canabs/services/loginservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];
  FirebaseFirestore? _instance;

  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);

  bool isSubCategoryAddedToCart(SubCategory? cat) {
    return _items.isNotEmpty
        ? _items.any((CartItem item) => item.category!.name == cat!.name)
        : false;
  }

  SubCategory? getCategoryFromCart(SubCategory cat) {
    SubCategory? subCat = cat;
    if (_items.isNotEmpty &&
        _items.any((CartItem item) => item.category!.name == cat.name)) {
      CartItem cartItem =
          _items.firstWhere((CartItem item) => item.category!.name == cat.name);

      subCat = cartItem.category as SubCategory?;
    }

    return subCat;
  }

  void loadCartItemsFromFirebase(BuildContext context) {
    // clear the items up front
    if (_items.isNotEmpty) {
      _items.clear();
    }

    LoginService loginService =
        Provider.of<LoginService>(context, listen: false);
    // CategoryService catService = Provider.of<CategoryService>(context, listen: false);

    if (loginService.isUserLoggedIn()) {
      _instance = FirebaseFirestore.instance;
      _instance!
          .collection('shoppers')
          .doc(loginService.loggedInUserModel!.userId)
          .get()
          .then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          notifyListeners();
        }
      });
    }
  }
}
