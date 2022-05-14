import 'package:canabs/models/subcategory.dart';
import 'package:canabs/services/categoryselectionservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapBttomPill extends StatelessWidget {
  SubCategory? subCategory;

  MapBttomPill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CategorySelectionService catSelection =
        Provider.of<CategorySelectionService>(context, listen: false);

    subCategory = catSelection.selectedSubCategory;
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/${subCategory!.imgName}.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: subCategory!.icon!,
                    )
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subCategory!.name!,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Destination',
                        style: TextStyle(
                          color: subCategory!.color,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.location_pin,
                  color: subCategory!.color,
                  size: 50,
                ),
              ],
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(),
            ],
          )
        ],
      ),
    );
  }
}
