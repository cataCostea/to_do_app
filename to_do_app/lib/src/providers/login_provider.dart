import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/database_helper.dart';
import '../ui/dashboard/dashboard.dart';
import '../ui/login/login.dart';

class LoginProvider extends ChangeNotifier {
  String _userName;
  Widget _defaultHome = Container(
    color: Color(0xFFb8cef2),
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
  final dbHelper = DatabaseHelper.instance;

  LoginProvider() {
    getDefaultHome();
  }

  String get userName => _userName;
  Widget get defaultHome => _defaultHome;

  getDefaultHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName') ?? null;
    if (_userName == null) {
      _defaultHome = Login();
      notifyListeners();
    } else {
      _defaultHome = Dashboard();
      notifyListeners();
    }
  }

  setUserName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', value);
    _userName = value;
    notifyListeners();
  }
}
