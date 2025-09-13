import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:taskmanager/ui/screens/login_screen.dart';
import 'package:taskmanager/ui/screens/reset_password_screen.dart';
import 'package:taskmanager/ui/widgets/screen_background.dart';


class ForgotPasswordVerifyOtpScreen extends StatefulWidget {
  const ForgotPasswordVerifyOtpScreen({super.key});

  @override
  State<ForgotPasswordVerifyOtpScreen> createState() => _ForgotPasswordVerifyOtpScreenState();
}

class _ForgotPasswordVerifyOtpScreenState extends State<ForgotPasswordVerifyOtpScreen> {

  TextEditingController _otpTEControler = TextEditingController();
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
                Text('Enter Your OTP', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4,),
                Text('A 6 digit OTP has been send to your email address',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey
                    )),
                const SizedBox(height: 24,),
                PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    selectedColor: Colors.blue,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  controller: _otpTEControler, appContext: context,
                ),

                const SizedBox(height: 16,),
                FilledButton(onPressed: _onTapVerifyButton,
                    child: Text('Verify')),
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
  void _onTapVerifyButton(){
    Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context)=>ResetPasswordScreen()),
          (predicate) => false,
    );
  }


  @override
  void dispose() {
    _otpTEControler.dispose();
    super.dispose();
  }
}
