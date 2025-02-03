import 'dart:async';
import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:waw/theme/colors.dart';

import '../../models/district/district_model.dart';
import '../../models/user/individual_user_model.dart';
import '../../models/user/user_details_model.dart';
import '../../providers/district_provider.dart';
import '../../providers/user_login_provider.dart';
import '../../rest/hive_repo.dart';
import '../../routes/app_router.gr.dart';
import '../../widgets/login_button.dart';
import '../../widgets/profile_shimmer_view.dart';


@RoutePage()
class ProfileEditScreen extends ConsumerStatefulWidget {
  final UserModel? userModel;
  const ProfileEditScreen({super.key, required this.userModel});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState(this.userModel);
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  File? _image;
  UserModel? userModel;

  final _formKey = GlobalKey<FormState>();
  var _name = TextEditingController();
  var _mobile = TextEditingController();
  var _mobileWhatsp = TextEditingController();
  var _email = TextEditingController();
  var _address = TextEditingController();


  String? _selectedDistrict;
  List<DistrictList> districtList = [];

  fetchData() async {

    districtList.clear();
    await ref.read(districtProvider).getAllDistricts();
    final districtListProvider = ref.watch(districtProvider);
    districtList = districtListProvider.allDistrictListState;

    setState(() {});

  }

  getUserData () {
    _name.text = userModel!.data!.name.toString();
    _mobile.text = userModel!.data!.mobNo.toString();
    _mobileWhatsp.text = userModel!.data!.whatsappNo.toString();
    _email.text = userModel!.data!.email.toString();
    _address.text = userModel!.data!.address.toString();
    _selectedDistrict = userModel!.data!.location.toString();
  }



  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    fetchData();
  }

  _ProfileEditScreenState(this.userModel);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () => context.pushRoute(ProfileRoute()),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white,size: 25,)),
        title: Text("Edit Profile", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),),
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
                    Gap(40),
                    GestureDetector(
                      onTap: () async {
                        await _pickImage();
                      },
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.1,
                        backgroundColor: Colors.grey[300],
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            _image != null?
                            ClipOval(
                              child: Image.file(
                                _image!,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ):CircleAvatar(
                              radius: MediaQuery.of(context).size.width * 0.1,
                              backgroundImage: NetworkImage(
                                "https://wawapp.globify.in/storage/app/public/${userModel!.data!.image.toString()}",
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Icon(
                                Icons.add_a_photo,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )

                    ),
                    const Gap(25),
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
                          borderSide: const BorderSide(
                            color: Colors.white54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
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
                      readOnly: true,
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
                      dropdownColor: Colors.white70,
                      hint: Text("Select District",
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      menuMaxHeight: 500,
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 8.0),
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
                          borderSide: const BorderSide(
                            color: Colors.white54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
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
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                      selectedItemBuilder: (BuildContext context) {
                        return districtList.map((district) {
                          return Text(
                            district.name.toString(),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }).toList();
                      },
                      onChanged: (value) {
                        setState(() {
                          _selectedDistrict = value;
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
                      title: "Save",
                      onPressed: (){
                        print("aaaaaaa");
                        _save();
                      },
                    ),
                    Gap(60),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<File> _getFileFromNetwork(String imageUrl) async {
    try {
      // Initialize Dio to fetch the image
      final dio = Dio();
      final response = await dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes), // Expecting bytes as response
      );

      // Check if the response is valid and has data
      if (response.statusCode != 200 || response.data == null || response.data.isEmpty) {
        throw Exception('Failed to download image or received empty data');
      }

      // Get a temporary directory or a persistent one if needed
      final dir = await getTemporaryDirectory(); // Or use getApplicationDocumentsDirectory for persistent storage
      final filePath = '${dir.path}/image_from_network.jpg'; // You can change this based on your needs

      final file = File(filePath);

      // Write the data (bytes) to the file
      await file.writeAsBytes(response.data);

      print('Image saved at: $filePath');
      return file;

    } catch (e) {
      print('Error downloading image: $e');
      throw Exception("Failed to download and save image: $e");
    }
  }
  Future<File> copyFileToDocumentsDirectory(File originalFile) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final newFilePath = '${appDocDir.path}/${originalFile.uri.pathSegments.last}';
    final newFile = await originalFile.copy(newFilePath);
    return newFile;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    // setState(() {
    //   submitting = true;
    // });

    try {
      if (_image == null && userModel!.data!.image != null) {
        _image = await _getFileFromNetwork(
          "https://wawapp.globify.in/storage/app/public/${userModel!.data!.image}",
        );
        print(_image);
      }else{
        print(_image);
      }

      if (_image != null && _image!.existsSync()) {
        print('File exists at: ${_image!.path}');
      } else {
        print('File not found at: ${_image?.path}');
        // Optionally, handle the case when file is not found or needs to be fetched again
      }

      // Ensure the file is moved to a more persistent location (optional, if needed)
      File finalFile = _image!;
      if (_image!.path.contains('cache')) {
        finalFile = await copyFileToDocumentsDirectory(_image!);
        print('File moved to: ${finalFile.path}');
      }

      var userDetails = await ref.read(userDetailsProvider).editUser(
        name: _name.text,
        mob_no: _mobile.text,
        whatsapp_no: _mobileWhatsp.text,
        email: _email.text,
        address: _address.text,
        location: _selectedDistrict.toString(),
        file: finalFile,
      );
      print(userDetails.user!.name);
      print(userDetails.user!.mobNo);
      print(userDetails);
      if(userDetails.user != null){
        UserDetails user = UserDetails(data: Data());
        print("dsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsds");
        user.data!.userRole = userDetails.user!.userRole;
        user.data!.name = userDetails.user!.name;
        user.data!.mobNo = userDetails.user!.mobNo;
        user.data!.whatsappNo = userDetails.user!.whatsappNo;
        user.data!.email = userDetails.user!.email;
        user.data!.address = userDetails.user!.address;
        user.data!.location = userDetails.user!.location.toString();
        user.data!.image = userDetails.user!.image;
        user.data!.updatedAt = userDetails.user!.updatedAt;
        user.data!.createdAt = userDetails.user!.createdAt;
        user.data!.id = userDetails.user!.id;
        HiveRepo.instance.user = user;
        context.pushRoute(ProfileRoute());
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save your details'),
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
