import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key, required this.title, required this.description, required this.status, required this.color,
  });

  final String title, description, status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(8)
      ),
      title: Text(title),
      subtitle: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description),
          Text('Date: 12/01/12', style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black
          ),),
          Row(
            children: [
              Chip(label: Text(status),
                backgroundColor: color,
                labelStyle: TextStyle(
                    color: Colors.white
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(24)
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
