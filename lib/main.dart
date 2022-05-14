import 'package:canabs/helpers/utils.dart';
import 'package:canabs/pages/Selectedcategorypage.dart';
import 'package:canabs/pages/conversationscreen.dart';
import 'package:canabs/pages/detailspage.dart';
import 'package:canabs/pages/eventadd.dart';
import 'package:canabs/pages/eventpage.dart';
import 'package:canabs/pages/eventpageAnon.dart';
import 'package:canabs/pages/friend.dart';
import 'package:canabs/pages/friendsSearch.dart';
import 'package:canabs/pages/friendsreq.dart';
import 'package:canabs/pages/mainpage.dart';
import 'package:canabs/pages/mappage.dart';
import 'package:canabs/pages/mappagehome.dart';
import 'package:canabs/pages/messagepage.dart';
import 'package:canabs/pages/onboardingpage.dart';
import 'package:canabs/pages/searchscree.dart';
import 'package:canabs/pages/splashpage.dart';
import 'package:canabs/pages/welcomepage.dart';
import 'package:canabs/services/cartservice.dart';
import 'package:canabs/services/categoryselectionservice.dart';
import 'package:canabs/services/loginservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (_) => LoginService(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategorySelectionService(),
        ),
        ChangeNotifierProvider(create: (_) => CartService())
      ],
      child: MaterialApp(
        navigatorKey: Utils.mainAppNav,
        theme: ThemeData(fontFamily: 'Raleway'),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashPage(
                duration: 3,
                goToPage: WelcomePage(),
              ),
          '/welcomepage': (context) => WelcomePage(),
          '/mainpage': (context) => MainPage(),
          '/selectedcategorypage': (context) => SelectedCategoryPage(),
          '/detailspage': (context) => DetailsPage(),
          '/mappage': (context) => MapPageHome(),
          '/mappageDetails': (context) => MapPage(),
          '/onboardingpage': (context) => OnboardingPage(),
          '/friendspage': (context) => Friend(),
          '/messagepage': (context) => MessagePage(),
          '/search': (context) => SearchScreen(),
          '/eventPage': (context) => EventPage(),
          '/eventAdd': (context) => Eventpage(),
          '/eventPageAnon': (context) => EventPageAnon(),
          '/conver': (context) => const ConversationScreen(),
          '/friendSrch': (context) => const FriendsSearch(),
          '/friendReq': (context) => const FriendsReq(),
        },
      ),
    ),
  );
}
