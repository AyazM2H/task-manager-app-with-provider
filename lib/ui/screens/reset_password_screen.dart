import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/ui/screens/login_screen.dart';
import 'package:taskmanager/ui/widgets/screen_background.dart';


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  TextEditingController _passwordTEControler = TextEditingController();
  TextEditingController _confrimPasswordTEControler = TextEditingController();
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
                Text('Reset Password', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4,),
                Text('Password should be more than 6 letters and combination of numbers',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey
                    )),
                const SizedBox(height: 24,),

                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _passwordTEControler,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password'
                  ),
                ),

                const SizedBox(height: 8,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _confrimPasswordTEControler,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Confirm New Password'
                  ),
                ),

                const SizedBox(height: 16,),
                FilledButton(onPressed: _onTapResetButton,
                    child: Icon(Icons.arrow_circle_right_outlined)),
                const SizedBox(height: 32,),


                Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      text: "Already have an account? ",
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
    );

  }

  void _onTapLoginButton(){
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context)=>LoginScreen()),
        (predicate) => false,
    );
  }

  void _onTapResetButton(){
    Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context)=>LoginScreen()),
          (predicate) => false,
    );
  }




  @override
  void dispose() {
    _passwordTEControler.dispose();
    _confrimPasswordTEControler.dispose();
    super.dispose();
  }
}
