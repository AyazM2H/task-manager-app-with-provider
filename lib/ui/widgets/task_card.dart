import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/ui/controllers/state_manager.dart';
import 'package:taskmanager/ui/widgets/center_progress_indicator.dart';
import 'package:taskmanager/ui/widgets/snack_bar_msg.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key, required this.taskModel, required this.refreshParent});

  final TaskModel taskModel;
  final VoidCallback refreshParent;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
      ),
      title: Text(widget.taskModel.title),
      subtitle: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.taskModel.description),
          const SizedBox(height: 8),
          Text('Date: ${widget.taskModel.createdDate}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black
          ),),
          Row(
            children: [
              Chip(label: Text(widget.taskModel.status),
                backgroundColor: Colors.blue,
                labelStyle: TextStyle(
                    color: Colors.white
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)
                ),
              ),
              Spacer(),
              Consumer<StateManager>(
                builder: (context, deleteTaskProvider, _) {
                  return Visibility(
                    visible: deleteTaskProvider.deleteStatusInProgress == false,
                    replacement: CenterProgressIndicator(),
                    child: IconButton(onPressed: (){
                      _deleteStatus();
                    }, icon: Icon(Icons.delete_outline, color: Colors.grey,)),
                  );
                }
              ),
              Consumer<StateManager>(
                builder: (context, changeStatusProvider, _) {
                  return Visibility(
                    visible: changeStatusProvider.changeStatusInProgress == false,
                    replacement: CenterProgressIndicator(),
                    child: IconButton(onPressed: (){
                      _showChangeStatusDialog();
                    }, icon: Icon(Icons.edit, color: Colors.black,)),
                  );
                }
              ),

            ],
          )
        ],
      ),
    );
  }

  void _showChangeStatusDialog(){
   showDialog(context: context, builder: (ctx){
     return AlertDialog(
       title: Text('Change Status'),
       content: Column(
         mainAxisSize: MainAxisSize.min,
         children: [
           ListTile(
             onTap: (){
               _changeStatus('New');
             },
             title: Text('New'),
             trailing: widget.taskModel.status == 'New'? Icon(Icons.done) : null,
           ),
           ListTile(
             onTap: (){
               _changeStatus('Progress');
             },
             title: Text('Progress'),
             trailing: widget.taskModel.status == 'Progress'? Icon(Icons.done) : null,
           ),
           ListTile(
             onTap: (){
               _changeStatus('Cancelled');
             },
             title: Text('Cancelled'),
             trailing: widget.taskModel.status == 'Cancelled'? Icon(Icons.done) : null,
           ),
           ListTile(
             onTap: (){
               _changeStatus('Completed');
             },
             title: Text('Completed'),
             trailing: widget.taskModel.status == 'Completed'? Icon(Icons.done) : null,
           )
         ],
       ),
     );
   });
  }

  Future<void> _changeStatus(String status) async{
    if(status == widget.taskModel.status) {
      return;
    }
    Navigator.pop(context);

    String id = widget.taskModel.id;
    final bool isSuccess = await context.read<StateManager>().changeStatus(id, status);

    if(isSuccess){
      context.read<StateManager>().getAllTaskStatusCount();
      widget.refreshParent();
    }else{
      showSnackBar(context, context.read<StateManager>().errorMessage!);
    }
    
  }
  
  Future<void> _deleteStatus() async {
    String id = widget.taskModel.id;
    final bool isSuccess = await context.read<StateManager>().deleteStatus(id);


    if(isSuccess){
      context.read<StateManager>().getAllTaskStatusCount();
      widget.refreshParent();
    }else{
      showSnackBar(context, context.read<StateManager>().errorMessage!);
    }
  }
}
