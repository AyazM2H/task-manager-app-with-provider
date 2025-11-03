import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/data/models/user_model.dart';
import 'package:taskmanager/ui/controllers/auth_controller.dart';
import 'package:taskmanager/ui/controllers/state_manager.dart';
import 'package:taskmanager/ui/widgets/center_progress_indicator.dart';
import 'package:taskmanager/ui/widgets/screen_background.dart';
import 'package:taskmanager/ui/widgets/snack_bar_msg.dart';
import 'package:taskmanager/ui/widgets/tm_app_bar.dart';
import '../widgets/photo_picker_field.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  TextEditingController _emailTEControler = TextEditingController();
  TextEditingController _fnameTEControler = TextEditingController();
  TextEditingController _lnameTEControler = TextEditingController();
  TextEditingController _mobileTEControler = TextEditingController();
  TextEditingController _passwordTEControler = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ImagePicker _imagePicker = ImagePicker();
  XFile ? _selestedImage;
  bool updateProfileInProgress = false;

  @override
  void initState() {
    super.initState();

    UserModel user = AuthController.userModel!;

    _emailTEControler.text = user.email;
    _fnameTEControler.text = user.firstName;
    _lnameTEControler.text = user.lastName;
    _mobileTEControler.text = user.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(
        fromUpdateProfile: true,
      ),
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
                  const SizedBox(height: 82,),
                  Text('Update profile', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 24,),

                  PhotoPickerField(
                    onTap: _pickImage,
                    selectedPhoto: _selestedImage,
                  ),


                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _emailTEControler,
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                    enabled: false,
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _fnameTEControler,
                    decoration: InputDecoration(
                      hintText: 'First Name',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _lnameTEControler,
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _mobileTEControler,
                    decoration: InputDecoration(
                      hintText: 'Mobile',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Please enter your mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _passwordTEControler,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                      validator: (String? value){
                        if((value != null && value.isNotEmpty) && value.length <= 6){
                          return 'Enter a password more than 6 letters';
                        }
                        return null;
                      },

                  ),
                  const SizedBox(height: 16,),
                  Consumer<StateManager>(
                    builder: (context, updateProfileProvider, _) {
                      return Visibility(
                        visible: updateProfileProvider.updateProfileInProgress == false,
                        replacement: CenterProgressIndicator(),
                        child: FilledButton(
                            onPressed: _onTapUpdateButton,
                            child: Icon(Icons.arrow_circle_right_outlined)),
                      );
                    }
                  ),
                  const SizedBox(height: 32,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  void _onTapUpdateButton(){
    if(_formKey.currentState!.validate()){
      _updateProfile();
    }
  }



  Future<void> _pickImage() async{
    XFile ? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedImage != null){
      _selestedImage = pickedImage;
      setState(() {});
    }
  }

  Future<void> _updateProfile() async{
    final bool isSuccess = await context.read<StateManager>().updateProfile(
        _emailTEControler.text,
        _fnameTEControler.text.trim(),
        _lnameTEControler.text.trim(),
        _mobileTEControler.text.trim(),
        _passwordTEControler.text,
        _selestedImage);

    if(isSuccess){
      _passwordTEControler.clear();
      showSnackBar(context, 'Profile has been updated!');

    }else{
      showSnackBar(context, context.read<StateManager>().errorMessage!);
    }

  }

  @override
  void dispose() {
    _emailTEControler.dispose();
    _fnameTEControler.dispose();
    _lnameTEControler.dispose();
    _mobileTEControler.dispose();
    _passwordTEControler.dispose();
    super.dispose();
  }
}

