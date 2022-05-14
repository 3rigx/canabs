import 'package:flutter/material.dart';

import '../helpers/appcolors.dart';

class SplashPage extends StatelessWidget {
  int? duration = 0;
  Widget? goToPage;

  SplashPage({Key? key, this.duration, this.goToPage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: duration!), () async {
      // await for the Firebase initialization to occur
      // FirebaseApp app = await Firebase.initializeApp();

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => goToPage!));
    });
    return Material(
      child: Container(
        color: AppColors.MAIN_COLOR,
        alignment: Alignment.center,
        child: Stack(children: [
          Align(
            child: Center(
              child: ClipOval(
                child: Container(
                  width: 180,
                  height: 180,
                  color: AppColors.MAIN_COLOR,
                  alignment: Alignment.center,
                  child: Image.asset('assets/icons/icon.png'),
                ),
              ),
            ),
            alignment: Alignment.center,
          ),
        ]),
      ),
    );
  }
}
