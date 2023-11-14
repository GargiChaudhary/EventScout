import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPswd;
  final String hintText;
  final TextInputType textInputType;
  final int maxLines;

  const TextFieldInput(
      {super.key,
      required this.textEditingController,
      this.isPswd = false,
      this.maxLines = 1,
      required this.hintText,
      required this.textInputType});

  @override
  Widget build(BuildContext context) {
    // final inputBorder = OutlineInputBorder(
    //   borderSide: Divider.createBorderSide(context,
    //       color: Theme.of(context).primaryColor),
    // );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).hintColor.withAlpha(80)),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).focusColor.withAlpha(100),
              blurRadius: 10.0,
              spreadRadius: 0.0,
            ),
          ],
          color: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
        child: TextField(
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: Theme.of(context).hintColor,
              fontSize: 13),
          maxLines: maxLines,
          controller: textEditingController,
          decoration: InputDecoration(
            // fillColor: Theme.of(context).primaryColor,
            hintText: hintText,
            hintStyle: TextStyle(
                fontFamily: 'Montserrat',
                color: Theme.of(context).hintColor,
                fontSize: 13),
            // border: inputBorder,
            // focusedBorder: inputBorder,
            // enabledBorder: inputBorder,
            // filled: true,
            contentPadding: const EdgeInsets.all(8),
          ),
          keyboardType: textInputType,
          obscureText: isPswd,
        ),
      ),
    );
  }
}
