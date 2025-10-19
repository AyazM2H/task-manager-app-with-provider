import 'package:flutter/material.dart';
import 'package:taskmanager/ui/widgets/center_progress_indicator.dart';
import '../../data/models/task_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_msg.dart';
import '../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {

  @override
  void initState() {
    super.initState();
    _getCompleteTaskStatus('Completed');
  }

  bool _getCompleteTaskInProgress = false;
  List<TaskModel> _completeTaskList = [];


  Future<void> _getCompleteTaskStatus(String status) async{
    _getCompleteTaskInProgress = true;
    setState(() {});
    ApiResponse response = await ApiCaller.getRequest(url: Urls.listTaskByStatusUrl(status));

    if(response.isSuccess){
      List<TaskModel> list = [];
      for(Map<String, dynamic> jsonData in response.responseData['data']){
        list.add(TaskModel.fromJson(jsonData));
      }
      _completeTaskList = list;
    }else{
      showSnackBar(context, response.errorMessage!);
    }
    _getCompleteTaskInProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Visibility(
          visible: _getCompleteTaskInProgress == false,
          replacement: CenterProgressIndicator(),
          child: ListView.separated(
            itemCount: _completeTaskList.length,
            itemBuilder: (context, index){
              return TaskCard(taskModel: _completeTaskList[index], refreshParent: (){
                _getCompleteTaskStatus('Completed');
              });
            },
            separatorBuilder: (context, index){
              return SizedBox(height: 8,);
            },
          ),
        ),
      ),
    );
  }
}


