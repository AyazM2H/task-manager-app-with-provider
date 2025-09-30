import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskmanager/ui/widgets/screen_background.dart';
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
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _fnameTEControler,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'First Name',
                    ),
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _lnameTEControler,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                    ),
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _mobileTEControler,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Mobile',
                    ),
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _passwordTEControler,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(height: 16,),
                  FilledButton(onPressed: (){},
                      child: Icon(Icons.arrow_circle_right_outlined)),
                  const SizedBox(height: 32,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async{
    XFile ? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedImage != null){
      _selestedImage = pickedImage;
      setState(() {});
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

