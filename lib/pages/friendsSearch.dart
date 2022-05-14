import 'package:canabs/helpers/appcolors.dart';
import 'package:canabs/models/loginusermodel.dart';
import 'package:canabs/services/loginservice.dart';
import 'package:canabs/wudgets/custom_action_button.dart';
import 'package:canabs/wudgets/mainappbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendsSearch extends StatefulWidget {
  const FriendsSearch({Key? key}) : super(key: key);

  @override
  _FriendsSearchState createState() => _FriendsSearchState();
}

class _FriendsSearchState extends State<FriendsSearch> {
  final String? userId;
  List<DocumentSnapshot>? usersData;

  _FriendsSearchState({
    this.userId,
    this.usersData,
  });

  TextEditingController searchTextEditingController = TextEditingController();
  String? usertxt;
  List? requestId, friendList;
  bool? sendReq;
  bool checkr = false;

  DocumentSnapshot<Map<String, dynamic>>? query;

  @override
  void initState() {
    LoginService? loginService =
        Provider.of<LoginService>(context, listen: false);
    LoginUserModel? userModel = loginService.loggedInUserModel;

    _getList(userModel!.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginService? loginService =
        Provider.of<LoginService>(context, listen: false);
    LoginUserModel? userModel = loginService.loggedInUserModel;

    return Scaffold(
      appBar: MainAppBar(),
      body: !checkr
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  color: AppColors.MAIN_COLOR,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          showCursor: true,
                          controller: searchTextEditingController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                              hintText: "Search for friends...",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            usertxt = searchTextEditingController.text;
                          });
                        },
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [
                                  AppColors.Gradient_Color1,
                                  AppColors.Gradient_Color2,
                                ]),
                                borderRadius: BorderRadius.circular(40)),
                            padding: const EdgeInsets.all(12),
                            child: const Icon(
                              Icons.search_rounded,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: requestId!.isEmpty && friendList!.isEmpty
                      ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: (usertxt != '' && usertxt != null)
                              ? FirebaseFirestore.instance
                                  .collection("users")
                                  .where('Id', isNotEqualTo: userModel!.userId)
                                  .where('UserName',
                                      isGreaterThanOrEqualTo: usertxt!)
                                  .where('UserName',
                                      isLessThanOrEqualTo: '$usertxt+uf7ff')
                                  .orderBy('UserName')
                                  .snapshots()
                              : FirebaseFirestore.instance
                                  .collection('users')
                                  .where('Id', isNotEqualTo: userModel!.userId)
                                  .snapshots(),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                snapshot.hasData != true) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              var data = snapshot.data!.docs;
                              _getList(userModel.userId);

                              return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
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
                                                AppColors.Secondary_color,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListTile(
                                                  leading: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: data[index][
                                                                      'PhotoUrl'] ==
                                                                  null ||
                                                              data[index][
                                                                      'PhotoUrl']
                                                                  .isEmpty
                                                          ? Image.asset(
                                                              'assets/images/icon_user.png')
                                                          : Image.network(
                                                              data[index]
                                                                  ['PhotoUrl'],
                                                              height: 50.0,
                                                              width: 50.0,
                                                              fit: BoxFit.fill,
                                                            )),
                                                  title: Text(
                                                    data[index]['Email'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      CustomActionButton(
                                                        title: 'Send Request',
                                                        onPressed: () {
                                                          var list = [
                                                            data[index]['Id']
                                                          ];
                                                          var list12 = [
                                                            userModel.userId
                                                          ];
                                                          _onAddFriendPressed(
                                                              list,
                                                              userModel.userId);
                                                          _onAddFriendPressed(
                                                              list12,
                                                              data[index]
                                                                  ['Id']);
                                                          _onAddFriendreq(
                                                              list12,
                                                              data[index]
                                                                  ['Id']);
                                                          _isentRequestPressed(
                                                              list,
                                                              userModel.userId);
                                                          setState(() {
                                                            data = snapshot
                                                                .data!.docs;
                                                            _getList(userModel
                                                                .userId);
                                                          });
                                                        },
                                                      )
                                                    ])
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            }
                          })
                      : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: (usertxt != '' && usertxt != null)
                              ? FirebaseFirestore.instance
                                  .collection("users")
                                  .where('Id', isNotEqualTo: userModel!.userId)
                                  .where('Email',
                                      isGreaterThanOrEqualTo: usertxt!)
                                  .where('Email',
                                      isLessThanOrEqualTo: '$usertxt+uf7ff')
                                  .orderBy('Email')
                                  .snapshots()
                              : FirebaseFirestore.instance
                                  .collection('users')
                                  .where('Id', isNotEqualTo: userModel!.userId)
                                  .snapshots(),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                snapshot.hasData != true) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              var data = snapshot.data!.docs;
                              _getList(userModel.userId);

                              return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
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
                                                AppColors.Secondary_color,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListTile(
                                                  leading: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      child: data[index][
                                                                      'PhotoUrl'] ==
                                                                  null ||
                                                              data[index][
                                                                      'PhotoUrl']
                                                                  .isEmpty
                                                          ? Image.asset(
                                                              'assets/images/icon_user.png')
                                                          : Image.network(
                                                              data[index]
                                                                  ['PhotoUrl'],
                                                              height: 40.0,
                                                              width: 40.0,
                                                              fit: BoxFit.fill,
                                                            )),
                                                  title: Text(
                                                    data[index]['Email'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      check(data[index]
                                                                      ['Id']) ==
                                                                  'Friends' ||
                                                              check(data[index]
                                                                      ['Id']) ==
                                                                  'Request Sent'
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          8.0),
                                                              child: Text(
                                                                check(data[index]
                                                                            [
                                                                            'Id']) ==
                                                                        "Request Sent"
                                                                    ? "Request Sent"
                                                                    : "Friends",
                                                              ),
                                                            )
                                                          : CustomActionButton(
                                                              title:
                                                                  'Send Request',
                                                              onPressed: () {
                                                                var list = [
                                                                  data[index]
                                                                      ['Id']
                                                                ];
                                                                var list1 = [
                                                                  userModel
                                                                      .userId
                                                                ];
                                                                _onAddFriendPressed(
                                                                    list,
                                                                    userModel
                                                                        .userId);
                                                                _onAddFriendreq(
                                                                    list1,
                                                                    data[index]
                                                                        ['Id']);
                                                                _onAddFriendPressed(
                                                                    list1,
                                                                    data[index]
                                                                        ['Id']);
                                                                _isentRequestPressed(
                                                                    list,
                                                                    userModel
                                                                        .userId);
                                                                setState(() {
                                                                  _getList(
                                                                      userModel
                                                                          .userId);
                                                                  data =
                                                                      snapshot
                                                                          .data!
                                                                          .docs;
                                                                });
                                                              },
                                                            )
                                                    ])
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            }
                          }),
                ),
              ],
            ),
    );
  }

  Future<void> _onAddFriendPressed(List friendId, userid) async {
    CollectionReference sendreq =
        FirebaseFirestore.instance.collection('users');
    return sendreq
        .doc(userid)
        .update({'requests': FieldValue.arrayUnion(friendId)});
  }

  Future<void> _onAddFriendreq(List friendId, userid) async {
    CollectionReference sendreq =
        FirebaseFirestore.instance.collection('users');
    return sendreq
        .doc(userid)
        .update({'requests_Recived': FieldValue.arrayUnion(friendId)});
  }

  Future<void> _isentRequestPressed(List friendId, userid) async {
    CollectionReference sendreq =
        FirebaseFirestore.instance.collection('users');
    return sendreq
        .doc(userid)
        .update({'requests_sent': FieldValue.arrayUnion(friendId)});
  }

  _getList(userid) async {
    query =
        await FirebaseFirestore.instance.collection('users').doc(userid).get();
    if (mounted) {
      setState(() {
        requestId = query!.get('requests');
        friendList = query!.get('freinds');
        checkr = true;
      });
    }
  }

  String check(peopleId) {
    var foundReq;
    var foundFrnd;

    if (requestId!.isNotEmpty) {
      foundReq = requestId!.where((element) => element == peopleId);
      if (foundReq.isNotEmpty) {
        return 'Request Sent';
      } else if (friendList!.isNotEmpty) {
        foundFrnd = friendList!.where((element) => element == peopleId);
        if (foundFrnd.isNotEmpty) {
          return 'Friends';
        }
      }
    } else if (friendList!.isNotEmpty) {
      foundFrnd = friendList!.where((element) => element == peopleId);
      if (foundFrnd.isNotEmpty) {
        return 'Friends';
      }
    }

    return 'Send Request';
  }
}
