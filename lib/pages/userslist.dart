import 'package:canabs/helpers/appcolors.dart';
import 'package:canabs/wudgets/mainappbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  TextEditingController searchTextEditingController = TextEditingController();
  bool isLoading = false;
  bool haveUserSearched = false;
  QuerySnapshot? searchSnapshot;
  final FirebaseFirestore? _instance = FirebaseFirestore.instance;

  initiateSearch() async {
    if (searchTextEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await serachUsers(searchTextEditingController.text).then((snapshot) {
        searchSnapshot = snapshot;

        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MainAppBar(
            themeColor: Colors.white,
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    showCursor: true,
                    controller: searchTextEditingController,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                        hintText: "Search Username ...",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        border: InputBorder.none),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    initiateSearch();
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
                      child: const Icon(Icons.search_rounded)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  serachUsers(String displayName) {
    return _instance!
        .collection("users")
        .where('UserName', arrayContains: displayName)
        .get();
  }
}
