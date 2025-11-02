import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/ui/controllers/state_manager.dart';
import 'package:taskmanager/ui/widgets/center_progress_indicator.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  @override
  void initState() {
    super.initState();
    context.read<StateManager>().getTaskStatus('Progress');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<StateManager>(
          builder: (context, progressProvider, _) {
            return Visibility(
              visible: progressProvider.stateInProgress == false,
              replacement: CenterProgressIndicator(),
              child: progressProvider.taskList.isEmpty?
              const Center(
                child: Text('No progress tasks found', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey
                ),),
              )
                  :ListView.separated(
                    itemCount: progressProvider.taskList.length,
                  itemBuilder: (context, index){
                      return TaskCard(taskModel: progressProvider.taskList[index],
                          refreshParent: (){
                        context.read<StateManager>().getTaskStatus('Progress');
                          });
                  },
                  separatorBuilder: (context, index){
                      return SizedBox(height: 8,);
                  },
                      ),
            );
          }
        ),
      ),
    );
  }
}


