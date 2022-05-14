import 'package:canabs/helpers/appcolors.dart';
import 'package:canabs/models/loginusermodel.dart';
import 'package:canabs/services/database.dart';
import 'package:canabs/services/loginservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatefulWidget {
  final String? chatRoomId;

  const ConversationScreen({
    Key? key,
    this.chatRoomId,
  }) : super(key: key);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageController = TextEditingController();
  final FirebaseFirestore? _instance = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>>? chatMessageStream;

  Widget chatMessageList(String username) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.only(bottom: 70, top: 16),
                itemCount: snapshot.data!.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data!.docs[index]["message"],
                    sendByMe: username == snapshot.data!.docs[index]["seendBy"],
                  );
                })
            : Container();
      },
    );
  }

  addMessage(String username) {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "seendBy": username,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseMethods().addMessage(widget.chatRoomId!, chatMessageMap);

      setState(() {
        messageController.text = "";
      });
    }
  }

  @override
  void initState() {
    chatMessageStream = _instance!
        .collection("ChatRoom")
        .doc(widget.chatRoomId!)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginService loginService =
        Provider.of<LoginService>(context, listen: false);

    LoginUserModel userModel = loginService.loggedInUserModel!;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              child: chatMessageList(userModel.displayName!),
            ),
          ),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              color: AppColors.MAIN_COLOR,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Message...",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      addMessage(userModel.displayName!);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          gradient: const LinearGradient(colors: [
                            AppColors.Gradient_Color1,
                            AppColors.Gradient_Color2
                          ]),
                          borderRadius: BorderRadius.circular(40)),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.send_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String? message;
  final bool? sendByMe;
  const MessageTile({Key? key, @required this.message, this.sendByMe})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe! ? 0 : 24,
          right: sendByMe! ? 24 : 0),
      alignment: sendByMe! ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe!
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe!
                ? const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe!
                  ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                  : [const Color(0xFF097824), const Color(0xff2A75BC)],
            )),
        child: Text(message!,
            textAlign: TextAlign.start,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
