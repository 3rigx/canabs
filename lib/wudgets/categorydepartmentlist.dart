import 'package:canabs/models/subcategory.dart';
import 'package:flutter/material.dart';

class CategoryDepartmentList extends StatefulWidget {
  SubCategory? subCategory;
  CategoryDepartmentList({Key? key, this.subCategory}) : super(key: key);

  @override
  _CategoryDepartmentListState createState() => _CategoryDepartmentListState();
}

class _CategoryDepartmentListState extends State<CategoryDepartmentList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.subCategory!.departments.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    for (var department in widget.subCategory!.departments) {
                      department.isSelected =
                          widget.subCategory!.departments[index] == department;
                    }
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      width: 120,
                      height: 150,
                      decoration: BoxDecoration(
                          border:
                              widget.subCategory!.departments[index].isSelected!
                                  ? Border.all(
                                      color: widget.subCategory!.color!,
                                      width: 7)
                                  : null,
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            image: AssetImage('assets/images/' +
                                widget
                                    .subCategory!.departments[index].imgName! +
                                '.png'),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset.zero,
                              blurRadius: 10,
                            ),
                          ]),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 25),
                      child: Text(
                        widget.subCategory!.departments[index].name!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: widget.subCategory!.color,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
