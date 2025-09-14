import 'package:flutter/material.dart';
import '../widgets/task_card.dart';



class CancelTaskScreen extends StatefulWidget {
  const CancelTaskScreen({super.key});

  @override
  State<CancelTaskScreen> createState() => _CancelTaskScreenState();
}

class _CancelTaskScreenState extends State<CancelTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Expanded(
            child: ListView.separated(
              itemCount: 10,
              itemBuilder: (context, index){
                return TaskCard(title: 'Cancel title', description: 'Cancel description', status: 'Cancel', color: Colors.orange,);
              },
              separatorBuilder: (context, index){
                return SizedBox(height: 8,);
              },
            )
        ),
      ),
    );
  }
}


