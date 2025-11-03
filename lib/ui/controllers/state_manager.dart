import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/task_model.dart';
import '../../data/models/task_status_count_model.dart';
import '../../data/models/user_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import 'auth_controller.dart';

class StateManager extends ChangeNotifier{

  bool _taskStatusInProgress = false;
  bool _stateInProgress = false;
  bool _addNewTaskInProgress = false;
  bool _changeStatusInProgress = false;
  bool _deleteStatusInProgress = false;
  bool _updateProfileInProgress = false;
  String? _errorMessage;
  List<TaskModel> _taskList = [];
  List<TaskStatusCountModel> _taskStatusCountList = [];
  UserModel? _user;

  bool get taskStatusInProgress => _taskStatusInProgress;
  bool get stateInProgress => _stateInProgress;
  bool get addNewTaskInProgress => _addNewTaskInProgress;
  bool get changeStatusInProgress => _changeStatusInProgress;
  bool get deleteStatusInProgress => _deleteStatusInProgress;
  bool get updateProfileInProgress => _updateProfileInProgress;
  String? get errorMessage => _errorMessage;
  List<TaskModel> get taskList => _taskList;
  List<TaskStatusCountModel> get taskStatusCountList => _taskStatusCountList;
  UserModel? get user => _user;

  //appbar name updater
  void setUser(UserModel user){
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

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

      await AuthController.clearUserData();
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


  //tasks status
  Future<bool> getTaskStatus(String status) async{
    bool isSuccess = false;
    _stateInProgress = true;
    notifyListeners();
    ApiResponse response = await ApiCaller.getRequest(url: Urls.listTaskByStatusUrl(status));

    if(response.isSuccess){
      List<TaskModel> list = [];
      for(Map<String, dynamic> jsonData in response.responseData['data']){
        list.add(TaskModel.fromJson(jsonData));
      }
      _taskList = list;
      _errorMessage = null;
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }
    _stateInProgress = false;
    notifyListeners();
    return isSuccess;
  }

  //task count
  Future<bool> getAllTaskStatusCount() async{
    bool isSuccess = false;

    _taskStatusInProgress = true;
    notifyListeners();

    ApiResponse response = await ApiCaller.getRequest(url: Urls.taskStatusCountUrl);

    if(response.isSuccess){
      List<TaskStatusCountModel> list = [];
      for(Map<String, dynamic> jsonData in response.responseData['data']){
        list.add(TaskStatusCountModel.formJson(jsonData));
      }
      _taskStatusCountList = list;
      _errorMessage = null;
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }

    _taskStatusInProgress = false;
    notifyListeners();
    return isSuccess;
  }

  //add new task
  Future<bool> addNewTask(String title, String description) async{
    bool isSuccess = false;

    _addNewTaskInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "title": title,
      "description": description,
      "status":"New"
    };

    ApiResponse response = await ApiCaller.postRequest(
        url: Urls.createTaskUrl,
        body: requestBody
    );

    if(response.isSuccess){
      _errorMessage = null;
      isSuccess = true;
    }else {
      _errorMessage = response.errorMessage;
    }

    _addNewTaskInProgress = false;
    notifyListeners();
    return isSuccess;
  }

  //change status
  Future<bool> changeStatus(String id, String status) async{
    bool isSuccess = false;

    _changeStatusInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(
        url: Urls.updateTaskStatusUrl(id, status));


    if(response.isSuccess){
      _errorMessage = null;
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }

    _changeStatusInProgress = false;
    notifyListeners();
    return isSuccess;
  }

  //delete task
  Future<bool> deleteStatus(String id) async {
    bool isSuccess = false;

    _deleteStatusInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(
        url: Urls.deleteUrl(id));

    if(response.isSuccess){
      _errorMessage = null;
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }

    _deleteStatusInProgress = false;
    notifyListeners();
    return isSuccess;
  }

  //update profile
  Future<bool> updateProfile(String email, String firstName, String lastName, String mobile, String ? password, XFile ? photo) async{
    bool isSuccess = false;

    _updateProfileInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    if(password != null){
      requestBody['password'] = password;
    }

    String? encodedPhoto;

    if(photo != null){
      List<int> bytes = await photo.readAsBytes();
      encodedPhoto = jsonEncode(bytes);
      requestBody['photo'] = encodedPhoto;
    }

    ApiResponse response = await ApiCaller.postRequest(
        url: Urls.updateProfileUrl, body: requestBody);

    if(response.isSuccess){
      UserModel model = UserModel(
        id: AuthController.userModel!.id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        mobile: mobile,
        photo: encodedPhoto ?? AuthController.userModel!.photo,
      );

      await AuthController.updateUserData(model);
      setUser(model);
      _errorMessage = null;
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }

    _updateProfileInProgress = false;
    notifyListeners();
    return isSuccess;
  }
}