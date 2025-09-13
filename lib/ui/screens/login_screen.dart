import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/ui/screens/main_nav_bar_holder_screen.dart';
import 'package:taskmanager/ui/widgets/screen_background.dart';
import 'package:taskmanager/ui/screens/sign_up_screen.dart';

import 'forgot_password_verify_email.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _emailTEControler = TextEditingController();
  TextEditingController _passwordTEControler = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
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
                ),
                const SizedBox(height: 4,),
                TextFormField(
                  controller: _passwordTEControler,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 16,),
                FilledButton(onPressed: _onTapLogindButton,
                    child: Icon(Icons.arrow_circle_right_outlined)),
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
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context)=>MainNavBarHolderScreen()),
        (predicate) => false,
    );
  }

  @override
  void dispose() {
    _emailTEControler.dispose();
    _passwordTEControler.dispose();
    super.dispose();
  }
}
