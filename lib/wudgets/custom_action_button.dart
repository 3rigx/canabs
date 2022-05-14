import 'package:flutter/material.dart';

class CustomActionButton extends StatefulWidget {
  String? title;
  Function? onPressed;

  CustomActionButton({
    Key? key,
    this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  State<CustomActionButton> createState() => _CustomActionButtonState();
}

class _CustomActionButtonState extends State<CustomActionButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 2,
      height: 25,
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      minWidth: 100,
      child: Text(
        widget.title!,
        style:
            Theme.of(context).textTheme.button!.copyWith(color: Colors.white),
      ),
      onPressed: () {
        widget.onPressed!();
      },
    );
  }
}
