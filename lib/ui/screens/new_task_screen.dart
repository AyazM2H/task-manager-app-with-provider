import 'package:flutter/material.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/data/models/task_status_count_model.dart';
import 'package:taskmanager/data/services/api_caller.dart';
import 'package:taskmanager/data/utils/urls.dart';
import 'package:taskmanager/ui/widgets/center_progress_indicator.dart';
import 'package:taskmanager/ui/widgets/snack_bar_msg.dart';
import '../widgets/task_card.dart';
import '../widgets/task_count_by_status_card.dart';
import 'add_new_task_screen.dart';


class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  bool _getTaskStatusCountProgress = false;
  bool _getNewTaskInProgress = false;
  List<TaskStatusCountModel> _taskStatusCountList = [];
  List<TaskModel> _newTaskList = [];

  @override
  void initState() {
    super.initState();
    _getAllTaskStatusCount();
    _getNewTaskStatus('New');
  }

  Future<void> _getAllTaskStatusCount() async{
    _getTaskStatusCountProgress = true;
    setState(() {});
    ApiResponse response = await ApiCaller.getRequest(url: Urls.taskStatusCountUrl);

    if(response.isSuccess){
     List<TaskStatusCountModel> list = [];
     for(Map<String, dynamic> jsonData in response.responseData['data']){
       list.add(TaskStatusCountModel.formJson(jsonData));
     }
     _taskStatusCountList = list;
    }else{
      showSnackBar(context, response.errorMessage!);
    }
    _getTaskStatusCountProgress = false;
    setState(() {});
  }

  Future<void> _getNewTaskStatus(String status) async{
    _getNewTaskInProgress = true;
    setState(() {});
    ApiResponse response = await ApiCaller.getRequest(url: Urls.listTaskByStatusUrl(status));

    if(response.isSuccess){
      List<TaskModel> list = [];
      for(Map<String, dynamic> jsonData in response.responseData['data']){
        list.add(TaskModel.fromJson(jsonData));
      }
      _newTaskList = list;
    }else{
      showSnackBar(context, response.errorMessage!);
    }
    _getNewTaskInProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16,),
            SizedBox(
              height: 90,
              child: Visibility(
                visible: _getTaskStatusCountProgress == false,
                replacement: CenterProgressIndicator(),
                child: ListView.separated(
                  itemCount: _taskStatusCountList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return TaskCountByStatusCard(
                      status: _taskStatusCountList[index].status,
                      count: _taskStatusCountList[index].count,
                    );
                  },
                  separatorBuilder: (context, index){
                    return SizedBox(width: 4,);
                  },
                ),
              ),
            ),

            Expanded(
                child: Visibility(
                  visible: _getNewTaskInProgress == false,
                  replacement: CenterProgressIndicator(),
                  child: _newTaskList.isEmpty?
                  const Center(
                    child: Text('No new tasks found', style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey
                    ),),
                  )
                      : ListView.separated(
                    itemCount: _newTaskList.length,
                    itemBuilder: (context, index){
                      return TaskCard(taskModel: _newTaskList[index], refreshParent: () {
                        _getNewTaskStatus('New');
                      },
                      );
                    },
                    separatorBuilder: (context, index){
                      return SizedBox(height: 8,);
                    },
                  ),
                )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _onTapAddNewTaskButton, child: Icon(Icons.add),),
    );
  }

  void _onTapAddNewTaskButton(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNewTaskScreen()));
  }
}


