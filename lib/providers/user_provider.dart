import 'package:events/model/our_user.dart';
import 'package:events/resources/auth_methods.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  OurUser? _ourUser;
  final AuthMethods _authMethods = AuthMethods();
  OurUser get getUser => _ourUser!;

  Future<void> refreshUser() async {
    OurUser ourUser = await _authMethods.getUserDetails();
    _ourUser = ourUser;
    notifyListeners();
  }
}
