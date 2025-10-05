import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/data/services/api_caller.dart';
import 'package:taskmanager/data/utils/urls.dart';
import 'package:taskmanager/ui/screens/main_nav_bar_holder_screen.dart';
import 'package:taskmanager/ui/widgets/center_progress_indicator.dart';
import 'package:taskmanager/ui/widgets/screen_background.dart';
import 'package:taskmanager/ui/screens/sign_up_screen.dart';
import 'package:taskmanager/ui/widgets/snack_bar_msg.dart';

import 'forgot_password_verify_email.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String name = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _emailTEControler = TextEditingController();
  TextEditingController _passwordTEControler = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool loginInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 82,),
                Text('Get Started With', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 24,),
                TextFormField(
                  controller: _emailTEControler,
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
                Visibility(
                  visible:  loginInProgress == false,
                  replacement: CenterProgressIndicator(),
                  child: FilledButton(onPressed: _onTapLogindButton,
                      child: Icon(Icons.arrow_circle_right_outlined)),
                ),
                const SizedBox(height: 32,),


                Center(
                  child: Column(
                    children: [
                      TextButton(onPressed: _onTapForgotPasswordButton, child: Text('Forget Password ?',
                        style: TextStyle(color: Colors.grey),)),

                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          text: "Don't have an account? ",
                          children: [
                            TextSpan(
                              style: TextStyle(color: Colors.green),
                              text: 'Sign up',
                              recognizer: TapGestureRecognizer()..onTap = _onTapSignUpButton,
                            ),
                          ]
                        )
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

  }

  void _onTapSignUpButton(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
  }

  void _onTapForgotPasswordButton(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordVerifyEmailScreen()));
  }

  void _onTapLogindButton(){

    if(_formKey.currentState!.validate()){
      _login();
    }
  }

  Future<void> _login() async{
    loginInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailTEControler.text.trim(),
      "password":_passwordTEControler.text
    };
    final ApiResponse response = await ApiCaller.postRequest(
        url: Urls.loginnUrl,
      body: requestBody
    );
    if(response.isSuccess && response.responseData['status'] == 'success'){
      Navigator.pushNamedAndRemoveUntil(
          context,
          MainNavBarHolderScreen.name,
          (predicate) => false,
      );
    }else{
      loginInProgress = false;
      setState(() {});
      showSnackBar(context, response.errorMessage!);
    }
  }

  @override
  void dispose() {
    _emailTEControler.dispose();
    _passwordTEControler.dispose();
    super.dispose();
  }
}
