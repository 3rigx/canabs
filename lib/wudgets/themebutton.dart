import 'package:canabs/helpers/appcolors.dart';
import 'package:flutter/material.dart';

class ThemeButton extends StatefulWidget {
  String? label;
  Function? onClick;
  Color? color;
  Color? highlight;
  Widget? icon;
  Color? borderColor;
  Color? labelColor;
  double? borderwidth;

  ThemeButton(
      {Key? key,
      this.label,
      this.labelColor = Colors.white,
      this.color = AppColors.MAIN_COLOR,
      this.highlight = AppColors.HIGHLIGHT,
      this.icon,
      this.borderColor = Colors.transparent,
      this.borderwidth = 4,
      this.onClick})
      : super(key: key);

  @override
  State<ThemeButton> createState() => _ThemeButtonState();
}

class _ThemeButtonState extends State<ThemeButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Material(
          color: widget.color,
          child: InkWell(
            splashColor: widget.highlight,
            highlightColor: widget.highlight,
            onTap: () {
              widget.onClick!();
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: widget.borderColor!,
                  width: widget.borderwidth!,
                ),
              ),
              child: widget.icon == null
                  ? Text(
                      widget.label!,
                      style: TextStyle(
                          fontSize: 16,
                          color: widget.labelColor,
                          fontWeight: FontWeight.bold),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.icon!,
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.label!,
                          style: TextStyle(
                              fontSize: 16,
                              color: widget.labelColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
