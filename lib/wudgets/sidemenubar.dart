import 'package:canabs/helpers/appcolors.dart';
import 'package:canabs/helpers/utils.dart';
import 'package:canabs/services/loginservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenuBar extends StatelessWidget {
  const SideMenuBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginService loginService =
        Provider.of<LoginService>(context, listen: false);

    bool userLoggedIn = loginService.loggedInUserModel != null;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(50),
        color: AppColors.MAIN_COLOR,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                TextButton(
                  onPressed: () async {
                    if (userLoggedIn) {
                      await loginService.signOut();

                      Utils.mainAppNav.currentState!
                          .pushReplacementNamed('/welcomepage');
                    } else {
                      bool success = await loginService.signInWithGoogle();
                      if (success) {
                        Utils.mainAppNav.currentState!.pushNamed('/mainpage');
                      }
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        userLoggedIn ? Icons.logout : Icons.login,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        userLoggedIn ? 'SignOut' : 'Sign In',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: !userLoggedIn,
                  child: TextButton(
                    onPressed: () async {
                      Utils.mainAppNav.currentState!.pushNamed('/welcomepage');
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.home, color: Colors.white, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Welcome',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: ClipOval(
                child: Container(
                  width: 80,
                  height: 80,
                  color: AppColors.MAIN_COLOR,
                  alignment: Alignment.center,
                  child: Image.asset('assets/icons/icon.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
