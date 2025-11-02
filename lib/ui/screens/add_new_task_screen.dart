import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/data/services/api_caller.dart';
import 'package:taskmanager/data/utils/urls.dart';
import 'package:taskmanager/ui/controllers/state_manager.dart';
import 'package:taskmanager/ui/widgets/center_progress_indicator.dart';
import 'package:taskmanager/ui/widgets/screen_background.dart';
import 'package:taskmanager/ui/widgets/snack_bar_msg.dart';
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
  bool addNewTaskInProgress = false;

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
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Please enter your title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _descriptionTEController,
                    maxLines: 6,
                    decoration: InputDecoration(
                    hintText: 'Description',
                  ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Please enter your description ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16,),
                  Visibility(
                      visible: addNewTaskInProgress == false,
                      replacement: CenterProgressIndicator(),
                      child: FilledButton(onPressed: _onTapAddButton, child: Text('Add')))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapAddButton(){
    if(_formKey.currentState!.validate()){
      _addNewTsk();
    }
  }

  Future<void> _addNewTsk() async{
    addNewTaskInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status":"New"
    };
    
    ApiResponse response = await ApiCaller.postRequest(
      url: Urls.createTaskUrl,
      body: requestBody
    );
    addNewTaskInProgress = false;
    setState(() {});
    if(response.isSuccess){
      context.read<StateManager>().getNewTaskStatus('New');
      _clearTextFields();
      showSnackBar(context, 'New task has been added');
    }else {
      showSnackBar(context, response.errorMessage!);
    }
  }

  void _clearTextFields(){
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
