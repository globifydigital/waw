import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waw/models/user/user_details_model.dart';
import 'package:waw/routes/app_router.gr.dart';
import 'package:waw/theme/colors.dart';
import '../../gen/assets.gen.dart';
import 'package:iconsax/iconsax.dart';

import '../../providers/user_login_provider.dart';
import '../../rest/hive_repo.dart';
import '../../widgets/login_button.dart';

@RoutePage()
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {

  final _formKey = GlobalKey<FormState>();
  var _mobile = TextEditingController();
  var _password = TextEditingController();
  var _department = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _SignInScreenState();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: screenBackgroundColor,
          toolbarHeight: 0.0
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: const BoxDecoration(
            color: screenBackgroundColor,
              // gradient: LinearGradient(
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //     colors: [
              //       Color(0XFF1875D3),
              //       Color(0XFFF2548F),
              //     ]
              // )
          ),
          height: MediaQuery.of(context).size.height * 1.5,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.only(bottom: keyboardHeight),
                child: Column(
                  children: [
                    Gap(80),
                    Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                    Gap(40),
                    TextFormField(
                      controller: _mobile,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                      maxLength: 10,
                      decoration: InputDecoration(
                        hintText: 'Mobile Number',
                        hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 14, fontWeight: FontWeight.w300),
                        prefixIcon: Icon(Iconsax.mobile, color: Colors.yellow,),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                        prefixIconConstraints: BoxConstraints(minWidth: 50),
                        counterText: "",
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field cannot be empty';
                        }
                        return null;
                      },
                      onChanged: (v){
                        _mobile.text = v.toString();
                      },
                    ),
                    Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            context.pushRoute(SignUpRoute());
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 15.0),
                            child: Text(
                                "Register New",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.grey,
                                  decorationThickness: 2.0,
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(40),
                    LoginButton(
                      showActions: false,
                      title: "Sign In",
                      onPressed: (){
                        _login();
                      },
                    ),
                    Gap(60),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //         "Not a member ? ",
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //           color: Colors.white,
                    //         )
                    //     ),
                    //     GestureDetector(
                    //       onTap: (){
                    //         context.pushRoute(SignUpRoute());
                    //       },
                    //       child: Text(
                    //           "Register now",
                    //           style: TextStyle(
                    //             fontSize: 16,
                    //             color: Colors.white,
                    //             fontWeight: FontWeight.bold,
                    //           )
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    // setState(() {
    //   submitting = true;
    // });

    try {
      var userDetails = await ref.read(userDetailsProvider).userSignIn(_mobile.text);
      print(userDetails.data!.name);
      print(userDetails.data!.mobNo);
      print(userDetails);
      if(userDetails.data != null){
        UserDetails user = UserDetails(data: Data());
        print("dsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsds");
        user.data!.userRole = userDetails.data!.userRole;
        user.data!.name = userDetails.data!.name;
        user.data!.mobNo = userDetails.data!.mobNo;
        user.data!.whatsappNo = userDetails.data!.whatsappNo;
        user.data!.email = userDetails.data!.email;
        user.data!.address = userDetails.data!.address;
        user.data!.location = userDetails.data!.location.toString();
        user.data!.image = userDetails.data!.image;
        user.data!.updatedAt = userDetails.data!.updatedAt;
        user.data!.createdAt = userDetails.data!.createdAt;
        user.data!.id = userDetails.data!.id;
        HiveRepo.instance.user = user;
        context.pushRoute(DashboardRoute(bottomIndex: 0));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please check your username or password'),
            duration: Duration(milliseconds: 600),),
        );
      }
      // ignore: use_build_context_synchronously
      // Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
    }
    // setState(() {
    //   submitting = false;
    // });
  }
}
