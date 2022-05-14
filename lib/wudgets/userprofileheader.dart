import 'package:canabs/models/loginusermodel.dart';
import 'package:canabs/services/loginservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileHeader extends StatelessWidget {
  bool? showProfilePic;

  UserProfileHeader({Key? key, this.showProfilePic}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginService>(
      builder: (context, loginService, child) {
        LoginUserModel? userModel = loginService.loggedInUserModel;

        String? imgPath = userModel != null ? userModel.photoURL : '';

        return showProfilePic! && imgPath!.isNotEmpty
            ? Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(10),
                child: ClipOval(child: Image.network(imgPath)),
              )
            : const SizedBox(
                height: 40,
                width: 40,
              );
      },
    );
  }
}
