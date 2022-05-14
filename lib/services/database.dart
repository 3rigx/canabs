import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore? _instance = FirebaseFirestore.instance;

  Future<void> addUserInfo(userData) async {
    _instance!.collection("users").add(userData).catchError((e) {});
  }

  getUserInfo(String email) async {
    return _instance!
        .collection("users")
        .where("Email", isEqualTo: email)
        .get()
        .catchError((e) {});
  }

//didnt create
  createChatRoom(String charRoomId, chatRoomMap) {
    _instance!
        .collection("ChatRoom")
        .doc(charRoomId)
        .set(chatRoomMap)
        .catchError((e) {});
  }

  searchByName(String searchField) {
    return _instance!
        .collection("users")
        .where('UserName', arrayContains: searchField)
        .snapshots();
  }

  Future<bool> addChatRoom(chatRoom, chatRoomId) async {
    _instance!
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {});
    return true;
  }

  getChats(String chatRoomId) async {
    return _instance!
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time")
        .snapshots();
  }

  Future<void> addMessage(String chatRoomId, chatMessageData) async {
    _instance!
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .doc()
        .set(chatMessageData, SetOptions(merge: true))
        .catchError((e) {});
  }

  getUserChats(String? itIsMyName) async {
    return _instance!
        .collection("ChatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }
}
