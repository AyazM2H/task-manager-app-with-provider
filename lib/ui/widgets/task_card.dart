import 'package:flutter/material.dart';
import 'package:taskmanager/data/models/task_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key, required this.taskModel});

  final TaskModel taskModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
      ),
      title: Text(taskModel.title),
      subtitle: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(taskModel.description),
          const SizedBox(height: 8),
          Text('Date: ${taskModel.createdDate}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black
          ),),
          Row(
            children: [
              Chip(label: Text(taskModel.status),
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
              IconButton(onPressed: (){}, icon: Icon(Icons.edit, color: Colors.black,)),

            ],
          )
        ],
      ),
    );
  }
}
