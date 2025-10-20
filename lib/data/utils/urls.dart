class Urls{

  static const String _baseUrl = 'http://35.73.30.144:2005/api/v1';
  static const String regitrationUrl = '$_baseUrl/Registration';
  static const String loginnUrl = '$_baseUrl/Login';
  static const String createTaskUrl = '$_baseUrl/createTask';
  static const String taskStatusCountUrl = '$_baseUrl/taskStatusCount';
  static const String updateProfileUrl = '$_baseUrl/ProfileUpdate';

  static String listTaskByStatusUrl(String status) =>
      '$_baseUrl/listTaskByStatus/$status';

  static String updateTaskStatusUrl(String id, String newStatus) =>
      '$_baseUrl/updateTaskStatus/$id/$newStatus';

  static String deleteUrl(String id) =>
      '$_baseUrl/deleteTask/$id';


}