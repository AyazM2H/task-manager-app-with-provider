import 'package:flutter/material.dart';
import 'package:taskmanager/ui/widgets/center_progress_indicator.dart';
import '../../data/models/task_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_msg.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _getProgressTaskInProgress = false;
  List<TaskModel> _progressTaskList = [];

  @override
  void initState() {
    super.initState();
    _getProgressTaskStatus('Progress');
  }


  Future<void> _getProgressTaskStatus(String status) async{
    _getProgressTaskInProgress = true;
    setState(() {});
    ApiResponse response = await ApiCaller.getRequest(url: Urls.listTaskByStatusUrl(status));

    if(response.isSuccess){
      List<TaskModel> list = [];
      for(Map<String, dynamic> jsonData in response.responseData['data']){
        list.add(TaskModel.fromJson(jsonData));
      }
      _progressTaskList = list;
    }else{
      showSnackBar(context, response.errorMessage!);
    }
    _getProgressTaskInProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Visibility(
          visible: _getProgressTaskInProgress == false,
          replacement: CenterProgressIndicator(),
          child: _progressTaskList.isEmpty?
          const Center(
            child: Text('No progress tasks found', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey
            ),),
          )
              :ListView.separated(
                itemCount: _progressTaskList.length,
              itemBuilder: (context, index){
                  return TaskCard(taskModel: _progressTaskList[index],
                      refreshParent: (){
                    _getProgressTaskStatus('Progress');
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


