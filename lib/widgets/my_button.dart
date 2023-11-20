import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final text;
  const MyButton({super.key, required this.text});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).hintColor.withAlpha(80)),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).focusColor.withAlpha(100),
            blurRadius: 5.0,
            spreadRadius: 0.0,
          ),
        ],
        color: Theme.of(context).focusColor.withOpacity(0.2),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 30,
      width: 85,
      child: Center(
        child: Text(
          widget.text,
          style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black),
        ),
      ),
    );
  }
}
