import 'package:canabs/helpers/appcolors.dart';
import 'package:canabs/helpers/utils.dart';
import 'package:canabs/models/loginusermodel.dart';
import 'package:canabs/pages/conversationscreen.dart';
import 'package:canabs/services/database.dart';
import 'package:canabs/services/loginservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? chatRoomsStream;

  Widget chatRoomList(String username) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: chatRoomsStream,
        builder: (context, snapshot) {
          // final data = snapshot.requireData;
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.size,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ChatRoomsTile(
                      userName: snapshot.data!.docs[index]["chatroomId"]
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(username, ""),
                      chatRoomId: snapshot.data!.docs[index]["chatroomId"],
                    );
                  },
                )
              : Container();
        });
  }

  @override
  void initState() {
    LoginService? loginService =
        Provider.of<LoginService>(context, listen: false);
    LoginUserModel? userModel = loginService.loggedInUserModel;
    getUserInfogetChats(userModel!.displayName);

    super.initState();
  }

  getUserInfogetChats(String? uidd) async {
    DatabaseMethods().getUserChats(uidd).then((snapshots) {
      setState(() {
        chatRoomsStream = snapshots;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    LoginService loginService =
        Provider.of<LoginService>(context, listen: false);

    LoginUserModel userModel = loginService.loggedInUserModel!;
    return Scaffold(
      body: chatRoomsStream == null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/chat_icon.png'),
                  const Text(
                    'No Chatroom. Try to add some. ☺️😊',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              child: chatRoomList(userModel.displayName!),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.messenger),
        backgroundColor: AppColors.MAIN_COLOR,
        onPressed: () {
          Utils.mainAppNav.currentState!.pushNamed('/search');
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String? userName;
  final String? chatRoomId;
  const ChatRoomsTile({Key? key, this.userName, @required this.chatRoomId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                    chatRoomId: chatRoomId,
                  ),
              maintainState: true),
        );
      },
      child: Container(
        color: AppColors.MAIN_COLOR,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: AppColors.Fonts_color,
                borderRadius: BorderRadius.circular(60),
              ),
              child: Center(
                child: Text(userName!.substring(0, 1),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: AppColors.MAIN_COLOR,
                        fontSize: 20,
                        fontWeight: FontWeight.w300)),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(userName!,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
