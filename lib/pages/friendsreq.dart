import 'package:canabs/helpers/appcolors.dart';
import 'package:canabs/models/loginusermodel.dart';
import 'package:canabs/services/loginservice.dart';
import 'package:canabs/wudgets/custom_action_button.dart';
import 'package:canabs/wudgets/mainappbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendsReq extends StatefulWidget {
  const FriendsReq({Key? key}) : super(key: key);

  @override
  _FriendsReqState createState() => _FriendsReqState();
}

class _FriendsReqState extends State<FriendsReq> {
  DocumentSnapshot<Map<String, dynamic>>? query;
  DocumentSnapshot<Map<String, dynamic>>? query1;
  List? requestList;
  List? requestSentList;

  bool check = false;

  @override
  void initState() {
    LoginService? loginService =
        Provider.of<LoginService>(context, listen: false);
    LoginUserModel? userModel = loginService.loggedInUserModel;
    _getIsentReqList(userModel!.userId);
    _getList(userModel.userId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginService loginService =
        Provider.of<LoginService>(context, listen: false);
    LoginUserModel? userModel = loginService.loggedInUserModel;

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: MainAppBar(),
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
                    child: requestList!.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset('assets/images/chat_icon.png'),
                                const Text(
                                  'You don\'t have any friend Request.  ☺️😊',
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
                                .where('Id', whereIn: requestList!)
                                .snapshots(),
                            builder: (BuildContext context, snap) {
                              if (snap.connectionState ==
                                      ConnectionState.waiting &&
                                  snap.hasData != true) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                          'assets/images/chat_icon.png'),
                                      const Text(
                                        'You don\'t have any friend Request.  ☺️😊',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                var data = snap.data!.docs;

                                return ListView.builder(
                                  itemCount: requestList!.length,
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
                                        vertical: 10.0,
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
                                                      children: [
                                                        CustomActionButton(
                                                          title:
                                                              'Accept Request',
                                                          onPressed: () {
                                                            var list = [
                                                              data[index]['Id']
                                                            ];
                                                            var flist = [
                                                              userModel!.userId
                                                            ];
                                                            _onAddFriendPressed(
                                                                list,
                                                                userModel
                                                                    .userId);
                                                            _onAddFriendPressed(
                                                                flist,
                                                                data[index]
                                                                    ['Id']);

                                                            _onAddFriendCompleted(
                                                                list,
                                                                userModel
                                                                    .userId);
                                                            _onAddFriendReqCompleted(
                                                                list,
                                                                userModel
                                                                    .userId);
                                                            _onAddFriReqCompleted(
                                                                flist,
                                                                data[index]
                                                                    ['Id']);

                                                            _getList(userModel
                                                                .userId);
                                                            data =
                                                                snap.data!.docs;
                                                          },
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

  Future<void> _onAddFriendPressed(List friendId, userid) async {
    CollectionReference sendreq =
        FirebaseFirestore.instance.collection('users');
    return sendreq
        .doc(userid)
        .update({'freinds': FieldValue.arrayUnion(friendId)});
  }

  Future<void> _onAddFriendCompleted(List friendId, userid) async {
    CollectionReference sendreq =
        FirebaseFirestore.instance.collection('users');
    return sendreq
        .doc(userid)
        .update({'requests': FieldValue.arrayRemove(friendId)});
  }

  Future<void> _onAddFriendReqCompleted(List friendId, userid) async {
    CollectionReference sendreq =
        FirebaseFirestore.instance.collection('users');
    return sendreq
        .doc(userid)
        .update({'requests_Recived': FieldValue.arrayRemove(friendId)});
  }

  Future<void> _onAddFriReqCompleted(List friendId, userid) async {
    CollectionReference sendreq =
        FirebaseFirestore.instance.collection('users');
    return sendreq
        .doc(userid)
        .update({'requests_sent': FieldValue.arrayRemove(friendId)});
  }

  _getList(userid) async {
    query =
        await FirebaseFirestore.instance.collection('users').doc(userid).get();

    setState(() {
      requestList = query!.get('requests_Recived');

      check = true;
    });
  }

  _getIsentReqList(userid) async {
    query1 =
        await FirebaseFirestore.instance.collection('users').doc(userid).get();

    setState(() {
      requestSentList = query1!.get('requests_sent');
    });
  }
}
