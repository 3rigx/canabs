import 'package:canabs/wudgets/custom_action_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserItem extends StatefulWidget {
  // UserItem({Key? key}) : super(key: key);

  final DocumentSnapshot? userDocument;
  final bool? isFriend;
  final bool? isRequest;
  final Function? onAddFriendPressed;
  final Function? onDeleteRequestPressed;
  final Function? onAcceptRequestPressed;

  const UserItem({
    Key? key,
    @required this.userDocument,
    this.isFriend = true,
    this.isRequest = false,
    this.onAddFriendPressed,
    this.onDeleteRequestPressed,
    this.onAcceptRequestPressed,
  }) : super(key: key);

  @override
  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  bool _isRequestSent = false;
  bool _isRequestAccepted = false;
  bool _isRequestDeleted = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.grey[100],
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.isFriend! || _isRequestAccepted ? null : null,
            splashColor: Theme.of(context).splashColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: widget.userDocument!.get('PhotoUrl') == null ||
                              widget.userDocument!.get('PhotoUrl').isEmpty
                          ? Image.asset('assets/images/icon_user.png')
                          : Image.network(
                              widget.userDocument!.get('PhotoUrl'),
                              height: 50.0,
                              width: 50.0,
                              fit: BoxFit.fill,
                            )),
                  title: Text(
                    widget.userDocument!.get('Email'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: !widget.isFriend!
                      ? _isRequestAccepted ||
                              _isRequestDeleted ||
                              _isRequestSent
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                _isRequestAccepted
                                    ? 'You are now friends.'
                                    : _isRequestSent
                                        ? 'Request Sent'
                                        : 'Request Deleted',
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomActionButton(
                                  title: widget.isRequest!
                                      ? 'Accept Request'
                                      : 'Add Friend',
                                  onPressed: widget.isRequest!
                                      ? _onAcceptRequestPressed
                                      : _onAddFriendPressed,
                                ),
                                const SizedBox(width: 10),
                                widget.isRequest!
                                    ? CustomActionButton(
                                        title: 'Delete',
                                        onPressed: _onDeleteRequestPressed,
                                      )
                                    : Container()
                              ],
                            )
                      : Container(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Function _onAcceptRequestPressed() {
    setState(() {
      _isRequestAccepted = true;
    });
    return widget.onAcceptRequestPressed!();
  }

  Function _onAddFriendPressed() {
    setState(() {
      _isRequestSent = true;
    });
    return widget.onAddFriendPressed!();
  }

  void _onDeleteRequestPressed() {
    setState(() {
      _isRequestDeleted = true;
    });
    widget.onDeleteRequestPressed!();
  }
}
