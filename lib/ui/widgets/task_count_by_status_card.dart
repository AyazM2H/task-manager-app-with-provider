import 'package:flutter/material.dart';

class TaskCountByStatusCard extends StatelessWidget {
  const TaskCountByStatusCard({
    super.key, required this.status, required this.count,
  });

  final String status;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          children: [
            Text('$count', style: Theme.of(context).textTheme.titleLarge,),
            Text(status, style: TextStyle(color: Colors.grey),)
          ],
        ),
      ),
    );
  }
}
