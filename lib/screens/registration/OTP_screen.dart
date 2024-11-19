import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:waw/routes/app_router.gr.dart';
import 'package:waw/theme/colors.dart';

import '../../widgets/login_button.dart';


@RoutePage()
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  // Create 6 text controllers for each OTP box
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());

  // Focus nodes for each OTP box
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    // Dispose controllers and focus nodes when the screen is destroyed
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Function to handle text change and move focus to next box
  void _onOTPChanged(String value, int index) {
    if (value.isNotEmpty) {
      if(value.length>5){
        print("qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq");
        _onOTPPaste(value);
      }
      // Move focus to next field
      else if (index < 5) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      }
    }
    if (_controllers[index].text.isEmpty && index > 0) {
      _onBackspacePressed(index);
    }
  }

  // Function to handle backspace behavior
  void _onBackspacePressed(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      // If the box is empty and we press backspace, move to the previous box
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  // Handle pasting OTP (6 digits)
  void _onOTPPaste(String value) {
    // Ensure that we only handle 6 digits
    if (value.length == 6) {
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = value[i];
        if (i < 5) {
          FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
        }
      }
    }
  }

  // Build OTP text field for each box
  Widget _buildOTPBox(int index) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        // inputFormatters: [
        //   LengthLimitingTextInputFormatter(1), // Allow only one character per box
        // ],
        onChanged: (value) {
          _onOTPChanged(value, index);
        },
        onTap: () {
          // Clear the current text field when tapping
          if (_controllers[index].text.isEmpty && index > 0) {
            _focusNodes[index].unfocus();
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
        },
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "-",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
          backgroundColor: screenBackgroundColor,
          toolbarHeight: 0.0
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(80),
                Text("Enter OTP", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                Gap(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _buildOTPBox(index),
                  )),
                ),
                Gap(50),
                LoginButton(
                  showActions: false,
                  title: "Submit OTP",
                  onPressed: (){
                    context.pushRoute(SignInRoute());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
