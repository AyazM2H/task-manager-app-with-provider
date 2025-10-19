import 'package:flutter/material.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/data/services/api_caller.dart';
import 'package:taskmanager/data/utils/urls.dart';
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
  bool changeStatusInProgress = false;
  
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
              IconButton(onPressed: (){}, icon: Icon(Icons.delete_outline, color: Colors.grey,)),
              Visibility(
                visible: changeStatusInProgress == false,
                replacement: CenterProgressIndicator(),
                child: IconButton(onPressed: (){
                  _showChangeStatusDialog();
                }, icon: Icon(Icons.edit, color: Colors.black,)),
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

    changeStatusInProgress = true;
    setState(() {});
    
    final ApiResponse response = await ApiCaller.getRequest(
        url: Urls.updateTaskStatusUrl(widget.taskModel.id, status));

    changeStatusInProgress = false;
    setState(() {});

    if(response.isSuccess){
      widget.refreshParent();
    }else{
      showSnackBar(context, response.errorMessage!);
    }
    
  }
}
