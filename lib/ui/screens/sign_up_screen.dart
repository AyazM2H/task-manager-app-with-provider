import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/ui/widgets/screen_background.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Text('Join With Us', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 24,),
          
                  TextFormField(
                    controller: _emailTEControler,
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 4,),
                  TextFormField(
                    controller: _fnameTEControler,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'First Name',
                    ),
                  ),
                  const SizedBox(height: 4,),
                  TextFormField(
                    controller: _lnameTEControler,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                    ),
                  ),
                  const SizedBox(height: 4,),
                  TextFormField(
                    controller: _mobileTEControler,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Mobile',
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
                  FilledButton(onPressed: (){},
                      child: Icon(Icons.arrow_circle_right_outlined)),
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

  void _onTapLoginButton(){
    Navigator.pop(context);
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
