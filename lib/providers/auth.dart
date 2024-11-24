import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../services/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiredDate;
  String? _userId;
  Timer? authTimer;

  static const keyApi = 'AIzaSyCV6WgpVpN7gCvw74kyt8Hq_2tlhi_3Ejw';

  bool get isAuth {
    return _token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get toket {
    if (_expiredDate != null &&
        _expiredDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> authSignCode(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$keyApi');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final data = jsonDecode(response.body);
      if (data['error'] != null) {
        throw HttpException(data['error']['message']);
      }
      _token = data['idToken'];
      _expiredDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            data['expiresIn'],
          ),
        ),
      );
      _userId = data['localId'];
      autoLogout();
      final dataShare = await SharedPreferences.getInstance();
      final userData = jsonEncode(
        {
          'token': _token,
          'userId': _userId,  
          'expiredDate': _expiredDate!.toIso8601String(),
        },
      );

      dataShare.setString('userData', userData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return authSignCode(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return authSignCode(email, password, 'signInWithPassword');
  }

  Future<bool> autoLogIn() async {
    final dataShare = await SharedPreferences.getInstance();
    if (!dataShare.containsKey('userData')) {
      return false;
    }
    final data =
        jsonDecode(dataShare.getString('userData')!) as Map<String, dynamic>;
    final expirydDate = DateTime.parse(data['expiredDate']);
    if (expirydDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = data['token'];
    _userId = data['userId'];
    _expiredDate = expirydDate;
    notifyListeners();
    autoLogout();
    return false;
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expiredDate = null;
    if (authTimer != null) {
      authTimer!.cancel();
      authTimer = null;
    }
    final dataShare = await SharedPreferences.getInstance();
    dataShare.clear();
    notifyListeners();
  }

  void autoLogout() {
    if (authTimer != null) {
      authTimer!.cancel();
    }
    final timerExpiredDate = _expiredDate!.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: timerExpiredDate), logOut);
  }
}
