import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger/logger.dart';

class ApiCaller{

  static final Logger _logger = Logger();

  static Future<ApiResponse> getRequest({required String url}) async{

    try {
      Uri uri = Uri.parse(url);
      _loggerRequest(url);

      Response response = await get(uri);
      _loggerResponse(url, response);

      final int statusCode = response.statusCode;

      if(statusCode == 200){

        final decodedData = jsonDecode(response.body);
        return ApiResponse(
            isSuccess: true,
            statusCode: statusCode,
            responseBody: decodedData);
      }else{

        final decodedData = jsonDecode(response.body);
        return ApiResponse(
            isSuccess: false,
            statusCode: statusCode,
            responseBody: decodedData,

        );

      }
    } on Exception catch (e) {
      return ApiResponse(
        isSuccess: false,
        statusCode: -1,
        responseBody: null,
        errorMessage: e.toString()
      );
    }
  }

  static Future<ApiResponse> _postRequest({required String url, Map<String, dynamic>? body}) async{
    
    try {
      Uri uri = Uri.parse(url);

      _loggerRequest(url, body:  body);
      Response response = await post(uri);

      _loggerResponse(url, response);
      int statusCode = response.statusCode;
      
      if(statusCode == 200 || statusCode == 201){
        final decodedJson = jsonDecode(response.body);
        return ApiResponse(
            isSuccess: true,
            statusCode: statusCode,
            responseBody: decodedJson
        );
      }else{
        final decodedJson = jsonDecode(response.body);
        return ApiResponse(
            isSuccess: false,
            statusCode: statusCode,
            responseBody: decodedJson
        );
      }
    } on Exception catch (e) {
      return ApiResponse(
          isSuccess: false,
          statusCode: -1,
          responseBody: null
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

}

class ApiResponse{
  final bool isSuccess;
  final int statusCode;
  final dynamic responseBody;
  final String ? errorMessage;

  ApiResponse({
    required this.isSuccess,
    required this.statusCode,
    required this.responseBody,
    this.errorMessage = 'Something went wrong'
  });
}