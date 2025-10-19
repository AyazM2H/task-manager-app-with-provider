import 'package:flutter/material.dart';
import 'package:taskmanager/ui/widgets/center_progress_indicator.dart';
import '../../data/models/task_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_msg.dart';
import '../widgets/task_card.dart';



class CancelTaskScreen extends StatefulWidget {
  const CancelTaskScreen({super.key});

  @override
  State<CancelTaskScreen> createState() => _CancelTaskScreenState();
}

class _CancelTaskScreenState extends State<CancelTaskScreen> {

  @override
  void initState() {
    super.initState();
    _getCancelTaskStatus('Cancelled');
  }

  bool _getCancelTaskInProgress = false;
  List<TaskModel> _cancelTaskList = [];


  Future<void> _getCancelTaskStatus(String status) async{
    _getCancelTaskInProgress = true;
    setState(() {});
    ApiResponse response = await ApiCaller.getRequest(url: Urls.listTaskByStatusUrl(status));

    if(response.isSuccess){
      List<TaskModel> list = [];
      for(Map<String, dynamic> jsonData in response.responseData['data']){
        list.add(TaskModel.fromJson(jsonData));
      }
      _cancelTaskList = list;
    }else{
      showSnackBar(context, response.errorMessage!);
    }
    _getCancelTaskInProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Visibility(
          visible: _getCancelTaskInProgress == false,
          replacement: CenterProgressIndicator(),
          child: ListView.separated(
            itemCount: _cancelTaskList.length,
            itemBuilder: (context, index){
              return TaskCard(taskModel: _cancelTaskList[index],
                  refreshParent: (){_getCancelTaskStatus('Cancelled');});
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


