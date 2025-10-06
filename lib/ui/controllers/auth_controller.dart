import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmanager/data/models/user_model.dart';

class AuthController{

  static const String _accessTokenKey = 'token';
  static const String _userModelKey = 'user';

  static String? accessToken;
  static UserModel? userModel;

  static Future<void> saveUserData(String token, UserModel model) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    await sharedPreferences.setString(_userModelKey, jsonEncode(model.toJson()));
    accessToken = token;
    userModel = model;
  }

  Future<void> getUserData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    if(token != null){
      String? userData = sharedPreferences.getString(_userModelKey);
      userModel = UserModel.fromJson(jsonDecode(userData!));
      accessToken = token;
    }
  }
}