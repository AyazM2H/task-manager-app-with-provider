import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/ui/controllers/state_manager.dart';
import 'package:taskmanager/ui/widgets/center_progress_indicator.dart';
import '../widgets/task_card.dart';
import '../widgets/task_count_by_status_card.dart';
import 'add_new_task_screen.dart';


class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {


  @override
  void initState() {
    super.initState();
    context.read<StateManager>().getAllTaskStatusCount();
    context.read<StateManager>().getTaskStatus('New');
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
              child: Consumer<StateManager>(
                builder: (context, taskStatusProvider, _) {
                  return Visibility(
                    visible: taskStatusProvider.taskStatusInProgress == false,
                    replacement: CenterProgressIndicator(),
                    child: ListView.separated(
                      itemCount: taskStatusProvider.taskStatusCountList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return TaskCountByStatusCard(
                          status: taskStatusProvider.taskStatusCountList[index].status,
                          count: taskStatusProvider.taskStatusCountList[index].count,
                        );
                      },
                      separatorBuilder: (context, index){
                        return SizedBox(width: 4,);
                      },
                    ),
                  );
                }
              ),
            ),

            Expanded(
                child: Consumer<StateManager>(
                  builder: (context, newTaskProvider, _) {
                    return Visibility(
                      visible: newTaskProvider.stateInProgress == false,
                      replacement: CenterProgressIndicator(),
                      child: newTaskProvider.taskList.isEmpty?
                      const Center(
                        child: Text('No new tasks found', style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey
                        ),),
                      )
                          : ListView.separated(
                        itemCount: newTaskProvider.taskList.length,
                        itemBuilder: (context, index){
                          return TaskCard(
                            taskModel: newTaskProvider.taskList[index],
                            refreshParent: () {
                            context.read<StateManager>().getTaskStatus('New');
                          },
                          );
                        },
                        separatorBuilder: (context, index){
                          return SizedBox(height: 8,);
                        },
                      ),
                    );
                  }
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


