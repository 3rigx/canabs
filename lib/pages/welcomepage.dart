import 'package:canabs/helpers/appcolors.dart';
import 'package:canabs/helpers/utils.dart';
import 'package:canabs/services/loginservice.dart';
import 'package:canabs/wudgets/themebutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginService loginService =
        Provider.of<LoginService>(context, listen: false);

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/images/aa3.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
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
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    'NAVIGATION MADE EASY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ThemeButton(
                    label: 'Anonymous ',
                    highlight: Colors.green[900]!,
                    color: AppColors.MAIN_COLOR,
                    onClick: () {
                      loginService.signOut();
                      Utils.mainAppNav.currentState!
                          .pushNamed('/onboardingpage');
                    },
                  ),
                  ThemeButton(
                    label: 'Login',
                    labelColor: Colors.white,
                    color: Colors.transparent,
                    highlight: AppColors.Secondary_color.withOpacity(0.10),
                    borderColor: AppColors.MAIN_COLOR,
                    borderwidth: 4,
                    onClick: () async {
                      bool succes = await loginService.signInWithGoogle();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const CircularProgressIndicator(),
                          duration: succes
                              ? const Duration(seconds: 1)
                              : const Duration(minutes: 1),
                        ),
                      );

                      if (succes) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        Utils.mainAppNav.currentState!.pushNamed('/mainpage');
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
