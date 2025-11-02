import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/ui/controllers/state_manager.dart';
import 'package:taskmanager/ui/widgets/center_progress_indicator.dart';
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
    context.read<StateManager>().getTaskStatus('Completed');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<StateManager>(
          builder: (context, completeProvider, _) {
            return Visibility(
              visible: completeProvider.stateInProgress == false,
              replacement: CenterProgressIndicator(),
              child: completeProvider.taskList.isEmpty?
              const Center(
                child: Text('No complete tasks found', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey
                ),),
              )
                  :ListView.separated(
                itemCount: completeProvider.taskList.length,
                itemBuilder: (context, index){
                  return TaskCard(
                      taskModel: completeProvider.taskList[index],
                      refreshParent: (){
                        context.read<StateManager>().getTaskStatus('Completed');
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


