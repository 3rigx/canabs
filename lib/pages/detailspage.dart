import 'package:canabs/helpers/appcolors.dart';
import 'package:canabs/helpers/utils.dart';
import 'package:canabs/models/subcategory.dart';
import 'package:canabs/services/categoryselectionservice.dart';
import 'package:canabs/services/loginservice.dart';
import 'package:canabs/wudgets/categorydepartmentlist.dart';
import 'package:canabs/wudgets/mainappbar.dart';
import 'package:canabs/wudgets/themebutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {
  SubCategory? subCategory;

  DetailsPage({Key? key}) : super(key: key);

  @override
  DetailsPageState createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    CategorySelectionService catSelection =
        Provider.of<CategorySelectionService>(context, listen: false);
    widget.subCategory = catSelection.selectedSubCategory;

    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.only(bottomLeft: Radius.circular(50)),
            child: Stack(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/' +
                          widget.subCategory!.imgName! +
                          '.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent
                          ]),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.subCategory!.icon!,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.subCategory!.name!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: widget.subCategory!.color,
                                borderRadius: BorderRadius.circular(
                                  20,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                MainAppBar(
                  themeColor: Colors.white,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Consumer<LoginService>(
                    builder: (context, loginService, child) {
                      Widget userActionsWidget;

                      if (loginService.isUserLoggedIn()) {
                        userActionsWidget = Column(
                          children: [
                            Visibility(
                              visible:
                                  widget.subCategory!.departments.isNotEmpty,
                              child: CategoryDepartmentList(
                                  subCategory: widget.subCategory),
                            ),
                            ThemeButton(
                              label: 'Goto Location',
                              icon: const Icon(
                                Icons.location_pin,
                                color: Colors.white,
                              ),
                              onClick: () {
                                Utils.mainAppNav.currentState!
                                    .pushNamed('/mappageDetails');
                              },
                              color: AppColors.MAIN_COLOR,
                              highlight: AppColors.Secondary_color,
                            ),
                            const SizedBox(height: 20),
                            ThemeButton(
                              label: 'ViewEvent',
                              icon:
                                  const Icon(Icons.event, color: Colors.white),
                              onClick: () {
                                Utils.mainAppNav.currentState!
                                    .pushNamed('/eventPage');
                              },
                            ),
                          ],
                        );
                      } else {
                        userActionsWidget = Container(
                          padding: const EdgeInsets.all(50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                              ThemeButton(
                                label: 'Goto Location',
                                icon: const Icon(
                                  Icons.location_pin,
                                  color: Colors.white,
                                ),
                                onClick: () {
                                  Utils.mainAppNav.currentState!
                                      .pushNamed('/mappageDetails');
                                },
                                color: AppColors.MAIN_COLOR,
                                highlight: AppColors.Secondary_color,
                              ),
                              const SizedBox(height: 20),
                              ThemeButton(
                                label: 'ViewEvent',
                                icon: const Icon(Icons.event,
                                    color: Colors.white),
                                onClick: () {
                                  Utils.mainAppNav.currentState!
                                      .pushNamed('/eventPageAnon');
                                },
                              ),
                            ],
                          ),
                        );
                      }

                      return userActionsWidget;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
