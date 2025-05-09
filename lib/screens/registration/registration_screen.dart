import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waw/models/district/district_model.dart';
import 'package:waw/providers/district_provider.dart';
import 'package:waw/routes/app_router.gr.dart';
import 'package:waw/theme/colors.dart';
import 'package:iconsax/iconsax.dart';
import '../../providers/user_login_provider.dart';
import '../../rest/hive_repo.dart';
import '../../widgets/login_button.dart';

@RoutePage()
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {


  File? _image;

  final _formKey = GlobalKey<FormState>();
  var _name = TextEditingController();
  var _mobile = TextEditingController();
  var _mobileWhatsp = TextEditingController();
  var _email = TextEditingController();
  var _address = TextEditingController();


  String? _selectedDistrict;
  List<DistrictList> districtList = [];

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        print("Local File Path: ${_image!.path}");
      });
    }
  }

  fetchData() async {

    districtList.clear();
    await ref.read(districtProvider).getAllDistricts();
    final districtListProvider = ref.watch(districtProvider);
    districtList = districtListProvider.allDistrictListState;

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  _SignUpScreenState();

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
            color: screenBackgroundColor
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
                    const Gap(80),
                    const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                    const Gap(40),
                    GestureDetector(
                      onTap: () async {
                        await _pickImage();
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        child: _image == null
                            ? Icon(Icons.add_a_photo, size: 30, color: Colors.grey)
                            : ClipOval(
                          child: Image.file(
                            _image!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Gap(25),
                    TextFormField(
                      controller: _name,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: 'Name',
                        hintStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w300),
                        prefixIcon: Icon(Iconsax.user, color: Colors.yellow,),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                        prefixIconConstraints: BoxConstraints(minWidth: 50),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white54,
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
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name cannot be empty';
                        }
                        return null;
                      },
                      onChanged: (v){
                        _name.text = v.toString();
                      },
                    ),
                    Gap(15),
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
                        hintStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w300),
                        prefixIcon: Icon(Iconsax.mobile, color: Colors.yellow,),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                        prefixIconConstraints: BoxConstraints(minWidth: 50),
                        counterText: "",
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white54,
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
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white54,
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
                    Gap(15),
                    TextFormField(
                      controller: _mobileWhatsp,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                      maxLength: 10,
                      decoration: InputDecoration(
                        hintText: 'Mobile Number (Whats Up)',
                        hintStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w300),
                        prefixIcon: Image.asset("assets/images/whatsapplogo.png", color: Colors.yellow,),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                        prefixIconConstraints: BoxConstraints(minWidth: 50),
                        counterText: "",
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white54,
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
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white54,
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
                        _mobileWhatsp.text = v.toString();
                      },
                    ),
                    Gap(15),
                    TextFormField(
                      controller: _email,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w300),
                        prefixIcon: Icon(Icons.mail_outline_sharp, color: Colors.yellow,),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                        prefixIconConstraints: BoxConstraints(minWidth: 50),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white54,
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
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        return null;
                      },
                      onChanged: (v) {
                        _email.text = v.toString();
                      },
                    ),
                    Gap(15),
                    TextFormField(
                      controller: _address,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: 'Address',
                        hintStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w300),
                        prefixIcon: Icon(Icons.location_city, color: Colors.yellow,),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                        prefixIconConstraints: BoxConstraints(minWidth: 50),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white54,
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
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        return null;
                      },
                      onChanged: (v) {
                        _address.text = v.toString();
                      },
                    ),
                    Gap(15),
                    DropdownButtonFormField<String>(
                      value: _selectedDistrict,
                      dropdownColor: Colors.blueGrey,
                      hint: Text("Select District",
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      menuMaxHeight: 500,
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: Colors.yellow,
                        ),
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_on, color: Colors.yellow),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                        prefixIconConstraints: BoxConstraints(minWidth: 50),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white54,
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
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      items: districtList.map((district) {
                        return DropdownMenuItem<String>(
                          value: district.id.toString(),
                          child: Text(
                            district.name.toString(),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDistrict = value;
                          print("_selectedDistrict $_selectedDistrict");
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'District cannot be empty';
                        }
                        return null;
                      },
                    ),
                    Gap(40),
                    LoginButton(
                      showActions: false,
                      title: "Sign Up",
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
      var userDetails = await ref.read(userDetailsProvider).registerUser(
        name: _name.text,
        mob_no: _mobile.text,
        whatsapp_no: _mobileWhatsp.text,
        email: _email.text,
        address: _address.text,
        location: _selectedDistrict.toString(),
        file: _image!,
      );
      print(userDetails.data!.name);
      print(userDetails.data!.mobNo);
      print(userDetails);
      if(userDetails != null){
        HiveRepo.instance.user = userDetails;
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
