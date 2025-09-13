import 'package:flutter/material.dart';
import 'package:taskmanager/ui/widgets/screen_background.dart';
import 'package:taskmanager/ui/widgets/tm_app_bar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {

  TextEditingController _titleTEController = TextEditingController();
  TextEditingController _descriptionTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32,),
                  Text('Add New Task', style: Theme.of(context).textTheme.titleLarge,),
                  const SizedBox(height: 16,),
                  TextFormField(
                    controller: _titleTEController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Title',
                    ),
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _descriptionTEController,
                    maxLines: 6,
                    decoration: InputDecoration(
                    hintText: 'Description',
                  ),),
                  const SizedBox(height: 16,),
                  FilledButton(onPressed: (){}, child: Text('Add'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
