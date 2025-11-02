import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/ui/controllers/state_manager.dart';
import 'package:taskmanager/ui/widgets/screen_background.dart';
import 'package:taskmanager/ui/widgets/snack_bar_msg.dart';

import '../widgets/center_progress_indicator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController _emailTEControler = TextEditingController();
  TextEditingController _fnameTEControler = TextEditingController();
  TextEditingController _lnameTEControler = TextEditingController();
  TextEditingController _mobileTEControler = TextEditingController();
  TextEditingController _passwordTEControler = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final StateManager _signUpProvider;

  @override
  Widget build(BuildContext context) {
    _signUpProvider = context.read<StateManager>();
    return Scaffold(
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
                  Text('Join With Us', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 24,),
          
                  TextFormField(
                    controller: _emailTEControler,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: (String? value){
                      String input = value ?? '';
                      if(EmailValidator.validate(input) == false){
                        return 'Please enter a valid email';
                      }
                      return null;
                    }
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _fnameTEControler,
                      textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'First Name',
                    ),
                      validator: (String? value){
                        if(value?.trim().isEmpty ?? true){
                          return 'Please enter your first name';
                        }
                        return null;
                      }
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _lnameTEControler,
                      textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                    ),
                      validator: (String? value){
                        if(value?.trim().isEmpty ?? true){
                          return 'Please enter your last name';
                        }
                        return null;
                      }
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _mobileTEControler,
                      textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Mobile',
                    ),
                      validator: (String? value){
                        if(value?.trim().isEmpty ?? true){
                          return 'Please enter your mobile number';
                        }
                        return null;
                      }
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _passwordTEControler,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                      validator: (String? value){
                        if((value?.length ?? 0) <= 6){
                          return 'Enter a password more than 6 letters';
                        }
                        return null;
                      }
                  ),
                  const SizedBox(height: 16,),
                  Consumer<StateManager>(
                    builder: (context, signUpProvider, _) {
                      return Visibility(
                        visible: signUpProvider.stateInProgress == false,
                        replacement: CenterProgressIndicator(),
                        child: FilledButton(onPressed: _0nTapSubmitButton,
                            child: Icon(Icons.arrow_circle_right_outlined)),
                      );
                    }
                  ),
                  const SizedBox(height: 32,),
          
          
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        text: "Alraedy have an account? ",
                        children: [
                          TextSpan(
                            style: TextStyle(color: Colors.green),
                            text: 'Login',
                            recognizer: TapGestureRecognizer()..onTap = _onTapLoginButton,
                          ),
                        ]
                      )
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _0nTapSubmitButton(){
    if(_formKey.currentState!.validate()){
      _signUp();
    }
  }
  void _onTapLoginButton(){
    Navigator.pop(context);
  }

  Future<void> _signUp() async{
    final bool isSuccess = await _signUpProvider.signUp(
        _emailTEControler.text.trim(),
        _fnameTEControler.text.trim(),
        _lnameTEControler.text.trim(),
        _mobileTEControler.text.trim(),
        _passwordTEControler.text);
    if(isSuccess){
      _clearTextField();
      showSnackBar(context, 'Registration success! Please login.');
    } else{
      showSnackBar(context, _signUpProvider.errorMessage!);
    }
  }

  void _clearTextField(){
    _emailTEControler.clear();
    _fnameTEControler.clear();
    _lnameTEControler.clear();
    _mobileTEControler.clear();
    _passwordTEControler.clear();
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

