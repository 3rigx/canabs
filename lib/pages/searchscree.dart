import 'package:canabs/helpers/appcolors.dart';
import 'package:canabs/models/loginusermodel.dart';
import 'package:canabs/services/database.dart';
import 'package:canabs/services/loginservice.dart';
import 'package:canabs/wudgets/mainappbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'conversationscreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchTextEditingController = TextEditingController();
  DocumentSnapshot<Map<String, dynamic>>? query;
  List? friendList;
  String? sch;
  bool check = false;

  /// 1.create a chatroom, send userexit to the chatroom, other userdetails
  createChatroomAndStartConversation(String userName, String consName) {
    List<String> users = [consName, userName];
    if (userName != consName) {
      String chatRoomId = getChatRoomId(consName, userName);

      Map<String, dynamic> chatRoom = {
        "users": users,
        "chatroomId": chatRoomId,
      };

      databaseMethods.addChatRoom(chatRoom, chatRoomId);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                    chatRoomId: chatRoomId,
                  )));
    }
  }

  Widget searchTile(
    String userName,
    String userEmail,
    String uid,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                userEmail,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConversation(userName, uid);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.MAIN_COLOR,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                "Message",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
    LoginService? loginService =
        Provider.of<LoginService>(context, listen: false);
    LoginUserModel? userModel = loginService.loggedInUserModel;
    getList(userModel!.userId);
  }

  @override
  Widget build(BuildContext context) {
    LoginService? loginService =
        Provider.of<LoginService>(context, listen: false);
    LoginUserModel? userModel = loginService.loggedInUserModel;
    return Scaffold(
      appBar: MainAppBar(),
      body: !check
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Your Friends 😊',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: (friendList!.isEmpty)
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
                      : SingleChildScrollView(
                          child: StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection("users")
                                  .where('Id', whereIn: friendList!)
                                  .snapshots(),
                              builder: (BuildContext context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.waiting &&
                                    snapshot.hasData != true) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        return searchTile(
                                            snapshot.data!.docs[index]
                                                .get("UserName"),
                                            snapshot.data!.docs[index]
                                                .get("Email"),
                                            userModel!.displayName!);
                                      });
                                }
                              }),
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
        friendList = query!.get('freinds');
        check = true;
      });
    }
  }
}
