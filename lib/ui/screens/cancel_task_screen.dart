import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/ui/controllers/state_manager.dart';
import 'package:taskmanager/ui/widgets/center_progress_indicator.dart';
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
    context.read<StateManager>().getTaskStatus('Cancelled');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<StateManager>(
          builder: (context, cancelledProvider, _) {
            return Visibility(
              visible: cancelledProvider.stateInProgress == false,
              replacement: CenterProgressIndicator(),
              child:cancelledProvider.taskList.isEmpty?
              const Center(
                child: Text('No cancelled tasks found', style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
                ),),
              )
                  :ListView.separated(
                itemCount: cancelledProvider.taskList.length,
                itemBuilder: (context, index){
                  return TaskCard(taskModel: cancelledProvider.taskList[index],
                      refreshParent: (){
                    context.read<StateManager>().getTaskStatus('Cancelled');
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


