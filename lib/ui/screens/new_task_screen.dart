import 'package:flutter/material.dart';
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
  List<TaskStatusCountModel> _taskStatusCountList = [];

  @override
  void initState() {
    super.initState();
    _getAllTaskStatusCount();
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
                child: ListView.separated(
                  itemCount: 10,
                  itemBuilder: (context, index){
                    return TaskCard(title: 'New title', description: 'New description', status: 'New', color: Colors.blue,);
                  },
                  separatorBuilder: (context, index){
                    return SizedBox(height: 8,);
                  },
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


