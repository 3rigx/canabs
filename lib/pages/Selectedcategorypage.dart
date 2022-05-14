import 'package:canabs/helpers/utils.dart';
import 'package:canabs/models/categorymodels.dart';
import 'package:canabs/models/subcategory.dart';
import 'package:canabs/services/cartservice.dart';
import 'package:canabs/services/categoryselectionservice.dart';
import 'package:canabs/wudgets/mainappbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectedCategoryPage extends StatelessWidget {
  Category? selectedCategory;

  SelectedCategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CategorySelectionService catSelection =
        Provider.of<CategorySelectionService>(context, listen: false);
    selectedCategory = catSelection.selectedCategory;
    CartService cartService = Provider.of<CartService>(context, listen: false);

    return Scaffold(
      appBar: MainAppBar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              selectedCategory!.icon!,
              const SizedBox(
                width: 10,
              ),
              Text(
                selectedCategory!.name!,
                style: TextStyle(
                  color: selectedCategory!.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(selectedCategory!.subCategories!.length,
                  (index) {
                return GestureDetector(
                  onTap: () {
                    var subCat = selectedCategory!.subCategories![index];
                    catSelection.selectedSubCategory =
                        cartService.getCategoryFromCart(subCat as SubCategory)!;

                    Utils.mainAppNav.currentState!.pushNamed('/detailspage');
                  },
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/images/' +
                              selectedCategory!.subCategories![index].imgName! +
                              '.png',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        selectedCategory!.subCategories![index].name!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedCategory!.color,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
