import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:taskmanager/app.dart';
import 'package:taskmanager/ui/controllers/auth_controller.dart';
import 'package:taskmanager/ui/screens/login_screen.dart';

class ApiCaller{

  static final Logger _logger = Logger();

  static Future<ApiResponse> getRequest({required String url}) async{

    try {
      Uri uri = Uri.parse(url);
      _loggerRequest(url);

      Response response = await get(
        uri,
        headers: {
          'token': AuthController.accessToken ?? ''
        }
      );
      _loggerResponse(url, response);

      final int statusCode = response.statusCode;

      if(statusCode == 200){

        final decodedData = jsonDecode(response.body);
        return ApiResponse(
            isSuccess: true,
            statusCode: statusCode,
            responseData: decodedData);
      }else if(statusCode == 401){
        await _moveToLogin();
        return ApiResponse(
            isSuccess: false,
            statusCode: statusCode,
            responseData: null,
            errorMessage: 'Un-Authorize'

        );
      }
      else{
        final decodedData = jsonDecode(response.body);
        return ApiResponse(
            isSuccess: false,
            statusCode: statusCode,
            responseData: decodedData,
          errorMessage: decodedData['data']

        );

      }
    } on Exception catch (e) {
      return ApiResponse(
        isSuccess: false,
        statusCode: -1,
        responseData: null,
        errorMessage: e.toString()
      );
    }
  }

  static Future<ApiResponse> postRequest({required String url, Map<String, dynamic>? body}) async{
    
    try {
      Uri uri = Uri.parse(url);

      _loggerRequest(url, body:  body);
      Response response = await post(uri,
      headers: {
        'content-type': 'application/json',
        'token': AuthController.accessToken ?? ''
      },
        body: jsonEncode(body)

      );

      _loggerResponse(url, response);
      int statusCode = response.statusCode;
      
      if(statusCode == 200 || statusCode == 201){
        final decodedData = jsonDecode(response.body);
        return ApiResponse(
            isSuccess: true,
            statusCode: statusCode,
            responseData: decodedData,
        );
      }else if(statusCode == 401){
        await _moveToLogin();
        return ApiResponse(
            isSuccess: false,
            statusCode: statusCode,
            responseData: null,
            errorMessage: 'Un-Authorize'
        );
      }
      else{
        final decodedData = jsonDecode(response.body);
        return ApiResponse(
            isSuccess: false,
            statusCode: statusCode,
            responseData: decodedData,
            errorMessage: decodedData['data']
        );
      }
    } on Exception catch (e) {
      return ApiResponse(
          isSuccess: false,
          statusCode: -1,
          responseData: null
      );
    }
    
  }

  static void _loggerRequest(String url, {Map<String, dynamic>? body}){
    _logger.i('URL: $url\n'
        'Request Body => $body\n'
    );
  }

  static void _loggerResponse(String url, Response response){
    _logger.i('URL: $url\n'
        'Status code: ${response.statusCode}\n'
        'Body => ${response.body}'
    );

  }

  static Future<void> _moveToLogin() async{
    await AuthController.clearUserData();
    Navigator.pushNamedAndRemoveUntil(
        TaskManager.navigator.currentContext!, LoginScreen.name, (predicate) => false);
  }

}

class ApiResponse{
  final bool isSuccess;
  final int statusCode;
  final dynamic responseData;
  final String ? errorMessage;

  ApiResponse({
    required this.isSuccess,
    required this.statusCode,
    required this.responseData,
    this.errorMessage = 'Something went wrong'
  });
}