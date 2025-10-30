import 'package:flutter/foundation.dart';

import '../../data/models/user_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import 'auth_controller.dart';

class StateManager extends ChangeNotifier{

  bool _loginInProgress = false;
  String? _errorMessage;

  bool get loginInProgress => _loginInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> login(email, password) async{
    bool isSuccess = false;

    _loginInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };

    final ApiResponse response = await ApiCaller.postRequest(
        url: Urls.loginnUrl,
        body: requestBody
    );
    if(response.isSuccess && response.responseData['status'] == 'success'){
      String accessToken = response.responseData['token'];
      UserModel model = UserModel.fromJson(response.responseData['data']);
      await AuthController.saveUserData(accessToken, model);

      _errorMessage = null;
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }

    _loginInProgress = true;
    notifyListeners();
    return isSuccess;
  }
}