import 'package:canabs/helpers/utils.dart';
import 'package:canabs/pages/categorylistpage.dart';
import 'package:canabs/pages/friend.dart';
import 'package:canabs/pages/mappagehome.dart';
import 'package:canabs/pages/messagepage.dart';
import 'package:canabs/wudgets/categorybottombar.dart';
import 'package:canabs/wudgets/mainappbar.dart';
import 'package:canabs/wudgets/sidemenubar.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SideMenuBar(),
      ),
      appBar: MainAppBar(),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Navigator(
                key: Utils.mainListNav,
                initialRoute: '/',
                onGenerateRoute: (RouteSettings settings) {
                  Widget page;

                  switch (settings.name) {
                    case '/':
                      page = CategoryListPage();
                      break;
                    case '/mainpage/mappage':
                      page = MapPageHome();
                      break;
                    case '/mainpage/msg':
                      page = MessagePage();
                      break;
                    case '/mainpage/friends':
                      page = Friend();
                      break;

                    default:
                      page = CategoryListPage();
                      break;
                  }
                  return PageRouteBuilder(
                    pageBuilder: (_, __, ___) => page,
                    transitionDuration: const Duration(seconds: 0),
                  );
                },
              ),
            ),
            CategoryBottomBar(),
          ],
        ),
      ),
    );
  }
}
