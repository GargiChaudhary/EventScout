import 'package:flutter/material.dart';

class ChangeThemeButtonWidget extends StatefulWidget {
  final ValueChanged<bool> onThemeToggle;
  const ChangeThemeButtonWidget({super.key, required this.onThemeToggle});

  @override
  State<ChangeThemeButtonWidget> createState() =>
      _ChangeThemeButtonWidgetState();
}

class _ChangeThemeButtonWidgetState extends State<ChangeThemeButtonWidget> {
  bool iconBool = false;
  IconData iconLight = Icons.wb_sunny;
  IconData iconDark = Icons.nights_stay;

  bool get getIconBool => iconBool;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          iconBool = !iconBool;
          widget.onThemeToggle(iconBool);
        });
      },
      icon: Icon(iconBool ? iconDark : iconLight),
    );
  }
}
