import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expirydate;
  String _userId;
  Timer _authtimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expirydate != null &&
        _expirydate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> singin(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCI5gUppHz9Waup4lzoprN3nVrjoHVKPTU';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responsedata = json.decode(response.body);
      if (responsedata['error'] != null) {
        throw HttpException(responsedata['error']['message']);
      }
      _token = responsedata['idToken'];
      _userId = responsedata['localId'];
      _expirydate = DateTime.now().add(
        Duration(
          seconds: int.parse(responsedata['expiresIn']),
        ),
      );
      _autologout();
      notifyListeners();
      final sharedpref = await SharedPreferences.getInstance();
      final userdata = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expirydate': _expirydate.toIso8601String(),
        },
      );
      sharedpref.setString('userdta', userdata);
    } catch (error) {
      throw error;
    }

    // print(json.decode(response.body));
  }

  Future<void> signup(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCI5gUppHz9Waup4lzoprN3nVrjoHVKPTU';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      // print(json.decode(response.body));
      final responsedata = json.decode(response.body);
      if (responsedata['error'] != null) {
        throw HttpException(responsedata['error']['message']);
      }
      _token = responsedata['idToken'];
      _userId = responsedata['localId'];
      _expirydate = DateTime.now().add(
        Duration(
          seconds: int.parse(responsedata['expiresIn']),
        ),
      );
      _autologout();
      notifyListeners();
      final sharedpref = await SharedPreferences.getInstance();
      final userdata = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expirydate': _expirydate.toIso8601String(),
        },
      );
      sharedpref.setString('userdta', userdata);
    } catch (error) {
      throw error;
    }
  }

  Future<bool>autologin()async{
    final sharedpref = await SharedPreferences.getInstance();
    if(!sharedpref.containsKey('userdta')){
      return false;
    }
    final preferencedata= json.decode(sharedpref.getString('userdta')) as Map<String,Object>;
    final expirydate = DateTime.parse(preferencedata['expirydate']);
    if(expirydate.isBefore(DateTime.now())){
      return false;
    }
  _token = preferencedata['token'];
  _userId= preferencedata['userId'];
  _expirydate= expirydate;
  notifyListeners();
  _autologout();
  return true;
  }

  Future<void> logout() async{
    _token = null;
    _userId = null;
    _expirydate = null;
    if (_authtimer != null) {
      _authtimer.cancel();
      _authtimer = null;
    }
    notifyListeners();
    final sharedpref =await SharedPreferences.getInstance();
    sharedpref.clear();
  }

  void _autologout() {
    if (_authtimer != null) {
      _authtimer.cancel();
    }
    final time = _expirydate.difference(DateTime.now()).inSeconds;
    _authtimer = Timer(Duration(seconds: time), logout);
  }
}
