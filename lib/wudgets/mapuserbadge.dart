import 'package:canabs/helpers/appcolors.dart';
import 'package:canabs/models/loginusermodel.dart';
import 'package:canabs/services/loginservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapUserBadge extends StatelessWidget {
  bool? isSelected;

  MapUserBadge({Key? key, this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginService? loginService =
        Provider.of<LoginService>(context, listen: false);
    LoginUserModel? userModel = loginService.loggedInUserModel;
    String? userImg = userModel != null ? userModel.photoURL : '';
    String? userName = userModel != null ? userModel.displayName : '';
    bool? showMapUserBadge = userImg!.isNotEmpty && userName!.isNotEmpty;

    return Visibility(
      visible: showMapUserBadge,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
            color: isSelected! ? AppColors.MAIN_COLOR : Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset.zero),
            ]),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                image: DecorationImage(
                  image: NetworkImage(userImg),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                  color: isSelected! ? Colors.white : AppColors.MAIN_COLOR,
                  width: 1,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected! ? Colors.white : Colors.grey,
                    ),
                  ),
                  Text(
                    'My Location',
                    style: TextStyle(
                        color:
                            isSelected! ? Colors.white : AppColors.MAIN_COLOR),
                  )
                ],
              ),
            ),
            const Icon(
              Icons.location_pin,
              color: AppColors.MAIN_COLOR,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}
