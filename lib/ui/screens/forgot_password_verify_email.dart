import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/ui/controllers/state_manager.dart';
import 'package:taskmanager/ui/widgets/center_progress_indicator.dart';
import 'package:taskmanager/ui/widgets/screen_background.dart';
import 'package:taskmanager/ui/widgets/snack_bar_msg.dart';
import 'forgot_password_verify_otp_screen.dart';


class ForgotPasswordVerifyEmailScreen extends StatefulWidget {
  const ForgotPasswordVerifyEmailScreen({super.key});

  @override
  State<ForgotPasswordVerifyEmailScreen> createState() => _ForgotPasswordVerifyEmailScreenState();
}

class _ForgotPasswordVerifyEmailScreenState extends State<ForgotPasswordVerifyEmailScreen> {

  TextEditingController _emailTEControler = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final StateManager _verifyEmailProvider;


  @override
  Widget build(BuildContext context) {
    _verifyEmailProvider = context.read<StateManager>();
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
                Text('Your Email Address', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4,),
                Text('A 6 digit OTP will be send to your email address',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey
                    )),
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
                  },
                ),

                const SizedBox(height: 16,),
                Consumer<StateManager>(
                  builder: (context, verifyEmailProvider, _) {
                    return Visibility(
                      visible: verifyEmailProvider.stateInProgress == false,
                      replacement: CenterProgressIndicator(),
                      child: FilledButton(onPressed: _onTapVerifyEmailButton,
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
                      text: "Already have an account? ",
                      children: [
                        TextSpan(
                          style: TextStyle(color: Colors.green),
                          text: 'Login ',
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
    Navigator.pop(context);
  }
  void _onTapVerifyEmailButton(){
    if(_formKey.currentState!.validate()){
      final email = _emailTEControler.text.trim();
      _validEmailChecker(email);
    }
  }

  Future<void> _validEmailChecker(String email) async{
    final bool isSuccess = await _verifyEmailProvider.validEmailChecker(email);
    if(isSuccess){
      _emailTEControler.clear();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordVerifyOtpScreen(email: email)));

    }else{
      showSnackBar(context, _verifyEmailProvider.errorMessage!);
    }

  }

  @override
  void dispose() {
    _emailTEControler.dispose();
    super.dispose();
  }
}
