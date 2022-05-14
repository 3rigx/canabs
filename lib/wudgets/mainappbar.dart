import 'package:canabs/helpers/appcolors.dart';
import 'package:canabs/helpers/utils.dart';
import 'package:canabs/wudgets/userprofileheader.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  Color themeColor;
  bool showProfilePic;

  MainAppBar(
      {Key? key,
      this.themeColor = AppColors.MAIN_COLOR,
      this.showProfilePic = true})
      : super(key: key);

  @override
  _MainAppBarState createState() => _MainAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          Utils.mainAppNav.currentState!
              .popUntil((route) => route.settings.name == '/categorylistpage');
        },
        child: Center(
          child: ClipOval(
            child: Container(
              width: 40,
              height: 40,
              color: AppColors.MAIN_COLOR,
              alignment: Alignment.center,
              child: Image.asset('assets/icons/icon.png'),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      iconTheme: IconThemeData(
        color: widget.themeColor,
      ),
      actions: [
        UserProfileHeader(
          showProfilePic: widget.showProfilePic,
        )
      ],
    );
  }
}
