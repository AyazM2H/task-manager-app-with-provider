import 'package:flutter/foundation.dart';
import '../../data/models/task_model.dart';
import '../../data/models/user_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import 'auth_controller.dart';

class StateManager extends ChangeNotifier{

  bool _stateInProgress = false;
  String? _errorMessage;
  List<TaskModel> _newTaskList = [];

  bool get stateInProgress => _stateInProgress;
  String? get errorMessage => _errorMessage;
  List<TaskModel> get newTaskList => _newTaskList;

  //sign up
  Future<bool> signUp(String email,String firstName,String lastName,String mobile,String password) async{
    bool isSuccess = false;
    _stateInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
    };

    final ApiResponse response = await ApiCaller.postRequest(
        url: Urls.regitrationUrl,
        body: requestBody
    );

    if(response.isSuccess){
      _errorMessage = null;
      isSuccess = true;
    } else{
      _errorMessage = response.errorMessage;
    }

    _stateInProgress = false;
    notifyListeners();
    return isSuccess;
  }

  //login
  Future<bool> login(email, password) async{
    bool isSuccess = false;

    _stateInProgress = true;
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

    _stateInProgress = false;
    notifyListeners();
    return isSuccess;
  }

  //verify email
  Future<bool> validEmailChecker(String email) async{
    bool isSuccess  = false;

    _stateInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(url: Urls.recoverVerifyEmailUrl(email));

    if(response.isSuccess){
      _errorMessage = null;
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }

    _stateInProgress = false;
    notifyListeners();
    return isSuccess;
  }

  //verify OTP
  Future<bool> validOTPChecker(String email, int otp) async{
    bool isSuccess = false;

    _stateInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(url: Urls.recoverVerifyOTPUrl(email, otp));

    if(response.isSuccess){
      _errorMessage = null;
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }

    _stateInProgress = false;
    notifyListeners();
    return isSuccess;
  }

  //reset password
  Future<bool> resetPassword(String email, int otp, String password) async{
    bool isSuccess = false;

    _stateInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody ={
      "email": email,
      "OTP": otp.toString(),
      "password": password
    };

    final ApiResponse response = await ApiCaller.postRequest(url: Urls.recoverPasswordUrl, body: requestBody);

    if(response.isSuccess){
      _errorMessage = null;
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }

    _stateInProgress = false;
    notifyListeners();
    return isSuccess;
  }


  //new tasks
  Future<bool> getNewTaskStatus(String status) async{
    bool isSuccess = false;
    _stateInProgress = true;
    notifyListeners();
    ApiResponse response = await ApiCaller.getRequest(url: Urls.listTaskByStatusUrl(status));

    if(response.isSuccess){
      List<TaskModel> list = [];
      for(Map<String, dynamic> jsonData in response.responseData['data']){
        list.add(TaskModel.fromJson(jsonData));
      }
      _newTaskList = list;
      _errorMessage = null;
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }
    _stateInProgress = false;
    notifyListeners();
    return isSuccess;
  }
}