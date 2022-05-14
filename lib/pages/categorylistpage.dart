import 'package:canabs/helpers/utils.dart';
import 'package:canabs/models/categorymodels.dart';
import 'package:canabs/services/categoryselectionservice.dart';
import 'package:canabs/wudgets/categorycard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CategoryListPage extends StatelessWidget {
  List<Category> categories = Utils.getMockedCategories();

  CategoryListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CategorySelectionService catSelection =
        Provider.of<CategorySelectionService>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: Text(
            'Select a categorie:',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (BuildContext ctx, int index) {
                return CategoryCard(
                  category: categories[index],
                  onCardClick: () {
                    catSelection.selectedCategory = categories[index];
                    Utils.mainAppNav.currentState!
                        .pushNamed('/selectedcategorypage');
                  },
                );
              }),
        ),
      ],
    );
  }
}
