import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/data/services/api_caller.dart';
import 'package:taskmanager/data/utils/urls.dart';
import 'package:taskmanager/ui/screens/login_screen.dart';
import 'package:taskmanager/ui/widgets/center_progress_indicator.dart';
import 'package:taskmanager/ui/widgets/screen_background.dart';
import 'package:taskmanager/ui/widgets/snack_bar_msg.dart';


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.email, required this.otp});
  final String email;
  final int otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  TextEditingController _passwordTEControler = TextEditingController();
  TextEditingController _confrimPasswordTEControler = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool resetPasswordInProgress = false;

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
                    validator: (String? value){
                      if((value?.length ?? 0) <= 6){
                        return 'Enter a password more than 6 letters';
                      }
                      return null;
                    }
                ),

                const SizedBox(height: 8,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _confrimPasswordTEControler,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Confirm New Password'
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
                  visible: resetPasswordInProgress == false,
                  replacement: CenterProgressIndicator(),
                  child: FilledButton(onPressed: _onTapResetButton,
                      child: Icon(Icons.arrow_circle_right_outlined)),
                ),
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
    if(_formKey.currentState!.validate()){
      if(_passwordTEControler.text == _confrimPasswordTEControler.text){
        String password = _passwordTEControler.text;
        _resetPassword(widget.email, widget.otp, password);
      }else{
        showSnackBar(context, 'Passwords do not match');
      }
    }

  }

  Future<void> _resetPassword(String email, int otp, String password) async{
    resetPasswordInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody ={
      "email": email,
      "OTP": otp.toString(),
      "password": password
    };

    final ApiResponse response = await ApiCaller.postRequest(url: Urls.recoverPasswordUrl, body: requestBody);

    resetPasswordInProgress = false;
    setState(() {});

    if(response.isSuccess){
      showSnackBar(context, response.responseData['data']);
      Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context)=>LoginScreen()),
            (predicate) => false,
      );
    }else{
      showSnackBar(context, response.errorMessage!);
    }

  }




  @override
  void dispose() {
    _passwordTEControler.dispose();
    _confrimPasswordTEControler.dispose();
    super.dispose();
  }
}
