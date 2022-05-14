import 'package:canabs/helpers/appcolors.dart';
import 'package:canabs/helpers/utils.dart';
import 'package:canabs/models/loginusermodel.dart';
import 'package:canabs/services/loginservice.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';

class Friend extends StatefulWidget {
  const Friend({Key? key}) : super(key: key);

  @override
  _FriendState createState() => _FriendState();
}

class _FriendState extends State<Friend> {
  DocumentSnapshot<Map<String, dynamic>>? query;
  List? friendList;

  String? currentUserId;
  bool check = false;

  @override
  void initState() {
    LoginService? loginService =
        Provider.of<LoginService>(context, listen: false);
    LoginUserModel? userModel = loginService.loggedInUserModel;

    getList(userModel!.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: !check
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  height: screenSize.height,
                  width: screenSize.width,
                  color: AppColors.MAIN_COLOR,
                ),
                Positioned(
                    top: 30.0,
                    child: IconButton(
                        icon: const Icon(
                          Icons.search,
                        ),
                        color: AppColors.Fonts_color,
                        iconSize: 40.0,
                        onPressed: () {
                          Utils.mainAppNav.currentState!
                              .pushNamed('/friendSrch');
                        })),
                Positioned(
                    top: 30.0,
                    right: 30.0,
                    child: IconButton(
                        icon: const Icon(
                          Icons.notification_important_rounded,
                        ),
                        color: AppColors.Fonts_color,
                        iconSize: 40.0,
                        onPressed: () {
                          Utils.mainAppNav.currentState!
                              .pushNamed('/friendReq');
                        })),
                Positioned(
                  top: screenSize.height * 0.15,
                  child: Container(
                    width: screenSize.width,
                    height: screenSize.height * 0.85,
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(35.0),
                        topRight: Radius.circular(35.0),
                      ),
                    ),
                    child: friendList!.isEmpty && friendList!.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset('assets/images/chat_icon.png'),
                                const Text(
                                  'You don\'t have friends!. Try to add some. ☺️😊',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .where('Id', whereIn: friendList!)
                                .snapshots(),
                            builder: (BuildContext context, snap) {
                              if (snap.connectionState ==
                                      ConnectionState.waiting &&
                                  snap.hasData != true) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                var data = snap.data!.docs;

                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (ctx, index) {
                                      return Card(
                                        color: AppColors.MAIN_COLOR,
                                        elevation: 3.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                          vertical: 5.0,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              splashColor:
                                                  Theme.of(context).splashColor,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ListTile(
                                                    leading: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        child: data[index][
                                                                        'PhotoUrl'] ==
                                                                    null ||
                                                                data[index][
                                                                        'PhotoUrl']
                                                                    .isEmpty
                                                            ? Image.asset(
                                                                'assets/images/icon_user.png')
                                                            : Image.network(
                                                                data[index][
                                                                    'PhotoUrl'],
                                                                height: 40.0,
                                                                width: 40.0,
                                                                fit:
                                                                    BoxFit.fill,
                                                              )),
                                                    title: Text(
                                                      data[index]['UserName'],
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16.0,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: const [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        8.0),
                                                            child: Text(
                                                              "Friends",
                                                            ),
                                                          )
                                                        ]),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                  ),
                ),
              ],
            ),
    );
  }

  Future getList(userid) async {
    query =
        await FirebaseFirestore.instance.collection('users').doc(userid).get();
    if (mounted) {
      setState(() {
        if (query!.data()!.isNotEmpty) {
          friendList = query!.get('freinds');
        }

        check = true;
      });
    }
  }
}
