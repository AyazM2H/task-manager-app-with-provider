import 'package:flutter/material.dart';
import '../widgets/task_card.dart';



class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Expanded(
            child: ListView.separated(
              itemCount: 10,
              itemBuilder: (context, index){
                //return TaskCard(title: 'Completed title', description: 'Completed description', status: 'Completed', color: Colors.purple,);
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


