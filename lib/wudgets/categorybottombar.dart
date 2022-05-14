import 'package:canabs/helpers/appcolors.dart';
import 'package:canabs/helpers/utils.dart';
import 'package:canabs/services/loginservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryBottomBar extends StatelessWidget {
  LoginService? loginService;
  bool? visi = false;

  CategoryBottomBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginService>(
      builder: (context, loginService, child) {
        visi = loginService.isUserLoggedIn();
        return Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.2),
              offset: Offset.zero,
            ),
          ]),
          height: 100,
          padding: const EdgeInsets.only(
            bottom: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ClipOval(
                child: Material(
                  color: Colors.white,
                  child: IconButton(
                    splashColor: AppColors.HIGHLIGHT,
                    highlightColor: AppColors.Secondary_color,
                    focusColor: AppColors.Secondary_color,
                    icon: const Icon(
                      Icons.list,
                      color: AppColors.MAIN_COLOR,
                    ),
                    onPressed: () {
                      Utils.mainListNav.currentState!
                          .pushReplacementNamed('/mainpage/categorylistpage');
                    },
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Material(
                  color: Colors.white,
                  child: IconButton(
                    splashColor: AppColors.HIGHLIGHT,
                    focusColor: AppColors.Secondary_color,
                    highlightColor: AppColors.Secondary_color,
                    icon: const Icon(
                      Icons.map,
                      color: AppColors.MAIN_COLOR,
                    ),
                    onPressed: () {
                      Utils.mainListNav.currentState!
                          .pushReplacementNamed('/mainpage/mappage');
                    },
                  ),
                ),
              ),
              ClipOval(
                child: Material(
                  color: Colors.white,
                  child: Visibility(
                    visible: visi!,
                    child: IconButton(
                      splashColor: AppColors.HIGHLIGHT,
                      focusColor: AppColors.Secondary_color,
                      highlightColor: AppColors.Secondary_color,
                      icon: const Icon(
                        Icons.chat_bubble,
                        color: AppColors.MAIN_COLOR,
                      ),
                      onPressed: () {
                        Utils.mainListNav.currentState!
                            .pushReplacementNamed('/mainpage/msg');
                      },
                    ),
                  ),
                ),
              ),
              ClipOval(
                child: Material(
                  color: Colors.white,
                  child: Visibility(
                    visible: visi!,
                    child: IconButton(
                      splashColor: AppColors.HIGHLIGHT,
                      focusColor: AppColors.Secondary_color,
                      highlightColor: AppColors.Secondary_color,
                      icon: const Icon(
                        Icons.people_alt_rounded,
                        color: AppColors.MAIN_COLOR,
                      ),
                      onPressed: () {
                        Utils.mainListNav.currentState!
                            .pushReplacementNamed('/mainpage/friends');
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
