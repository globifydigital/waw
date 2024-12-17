import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waw/theme/colors.dart';

import '../../routes/app_router.gr.dart';
import '../../widgets/login_button.dart';
import '../../widgets/profile_shimmer_view.dart';
import '../../widgets/ticket_widget.dart';



@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin{

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;


  bool _showProfile = false;

  bool _showShimmerLoader = false;
  late Timer _timer;
  File? _image;

  final _formKey = GlobalKey<FormState>();
  var _name = TextEditingController();
  var _mobile = TextEditingController();
  var _mobileWhatsp = TextEditingController();
  var _email = TextEditingController();
  var _address = TextEditingController();


  String? _selectedDistrict;
  final List<String> countries = [
    'Afghanistan',
    'Albania',
    'Algeria',
    'Andorra',
    'Angola',
    'Antigua and Barbuda',
    'Argentina',
    'Armenia',
    'Australia',
    'Austria',
    'Azerbaijan',
    'Bahamas',
    'Bahrain',
    'Bangladesh',
    'Barbados',
    'Belarus',
    'Belgium',
    'Belize',
    'Benin',
    'Bhutan',
    'Bolivia',
    'Bosnia and Herzegovina',
    'Botswana',
    'Brazil',
    'Brunei',
    'Bulgaria',
    'Burkina Faso',
    'Burundi',
    'Cabo Verde',
    'Cambodia',
    'Cameroon',
    'Canada',
    'Central African Republic',
    'Chad',
    'Chile',
    'China',
    'Colombia',
    'Comoros',
    'Congo (Congo-Brazzaville)',
    'Costa Rica',
    'Croatia',
    'Cuba',
    'Cyprus',
    'Czechia (Czech Republic)',
    'Denmark',
    'Djibouti',
    'Dominica',
    'Dominican Republic',
    'Ecuador',
    'Egypt',
    'El Salvador',
    'Equatorial Guinea',
    'Eritrea',
    'Estonia',
    'Eswatini (fmr. "Swaziland")',
    'Ethiopia',
    'Fiji',
    'Finland',
    'France',
    'Gabon',
    'Gambia',
    'Georgia',
    'Germany',
    'Ghana',
    'Greece',
    'Grenada',
    'Guatemala',
    'Guinea',
    'Guinea-Bissau',
    'Guyana',
    'Haiti',
    'Holy See',
    'Honduras',
    'Hungary',
    'Iceland',
    'India',
    'Indonesia',
    'Iran',
    'Iraq',
    'Ireland',
    'Israel',
    'Italy',
    'Jamaica',
    'Japan',
    'Jordan',
    'Kazakhstan',
    'Kenya',
    'Kiribati',
    'Kuwait',
    'Kyrgyzstan',
    'Laos',
    'Latvia',
    'Lebanon',
    'Lesotho',
    'Liberia',
    'Libya',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Madagascar',
    'Malawi',
    'Malaysia',
    'Maldives',
    'Mali',
    'Malta',
    'Marshall Islands',
    'Mauritania',
    'Mauritius',
    'Mexico',
    'Micronesia',
    'Moldova',
    'Monaco',
    'Mongolia',
    'Montenegro',
    'Morocco',
    'Mozambique',
    'Myanmar (formerly Burma)',
    'Namibia',
    'Nauru',
    'Nepal',
    'Netherlands',
    'New Zealand',
    'Nicaragua',
    'Niger',
    'Nigeria',
    'North Korea',
    'North Macedonia',
    'Norway',
    'Oman',
    'Pakistan',
    'Palau',
    'Palestine State',
    'Panama',
    'Papua New Guinea',
    'Paraguay',
    'Peru',
    'Philippines',
    'Poland',
    'Portugal',
    'Qatar',
    'Romania',
    'Russia',
    'Rwanda',
    'Saint Kitts and Nevis',
    'Saint Lucia',
    'Saint Vincent and the Grenadines',
    'Samoa',
    'San Marino',
    'Sao Tome and Principe',
    'Saudi Arabia',
    'Senegal',
    'Serbia',
    'Seychelles',
    'Sierra Leone',
    'Singapore',
    'Slovakia',
    'Slovenia',
    'Solomon Islands',
    'Somalia',
    'South Africa',
    'South Korea',
    'South Sudan',
    'Spain',
    'Sri Lanka',
    'Sudan',
    'Suriname',
    'Sweden',
    'Switzerland',
    'Syria',
    'Tajikistan',
    'Tanzania',
    'Thailand',
    'Timor-Leste',
    'Togo',
    'Tonga',
    'Trinidad and Tobago',
    'Tunisia',
    'Turkey',
    'Turkmenistan',
    'Tuvalu',
    'Uganda',
    'Ukraine',
    'United Arab Emirates',
    'United Kingdom',
    'United States of America',
    'Uruguay',
    'Uzbekistan',
    'Vanuatu',
    'Venezuela',
    'Vietnam',
    'Yemen',
    'Zambia',
    'Zimbabwe',
  ];


  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    // Show dialog to choose between camera or gallery
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Update the image file
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: 1), () {
      setState(() {
        _showShimmerLoader = true;
      });
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1), // Start off-screen (bottom)
      end: Offset(0, 0),   // Move to its final position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start the animation after a slight delay
    Future.delayed(const Duration(milliseconds: 200), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () => context.pushRoute(DashboardRoute(bottomIndex: 3)),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white,size: 25,)),
        title: Text("Profile", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: PopupMenuButton<String>(
              color: Colors.transparent,
              elevation: 0,
              onSelected: (value) {
                if (value == 'edit') {
                  context.pushRoute(ProfileEditRoute());
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.045,
                      decoration: BoxDecoration(
                        color: screenBackgroundColor, // Background color
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                        border: Border.all(
                          color: Colors.white24, // Border color
                          width: 1, // Border width
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit, color: Colors.white, size: 18,), // Icon color
                            SizedBox(width: 10),
                            Text(
                              'Edit',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14, // Font size
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // You can add more items like 'Delete', 'Settings', etc.
                ];
              },
              icon: Icon(Icons.more_vert, color: Colors.white), // Icon style
            ),

          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: (_showProfile)?SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.1,
                  backgroundImage: AssetImage("assets/images/personimage.jpg"),
                  backgroundColor: Colors.transparent,
                ),
              ),
              Gap(15),
              Text("User @121232", style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
              Gap(2),
              Text("9874562130", style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),),
              Gap(25),
              Center(
                child: Text(
                  "Congratulations!\nYou have reached the target point.\nHere is your ticket to the prize draw.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 11,
                  ),
                ),
              ),
              Gap(10),
              TicketWidget(),
              Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => context.pushRoute(DashboardRoute(bottomIndex: 0)),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.045,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white24, // Set the border color
                          width: 1, // Set the border width
                        ),
                      ),
                      child: Center(
                        child: Text("Download Ticket Image", style: GoogleFonts.poppins(color: Colors.white24, fontSize: 12),),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pushRoute(DashboardRoute(bottomIndex: 0)),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.045,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white24, // Set the border color
                          width: 1, // Set the border width
                        ),
                      ),
                      child: Center(
                        child: Text("Share on Social Media", style: GoogleFonts.poppins(color: Colors.white24, fontSize: 12),),
                      ),
                    ),
                  )
                ],
              ),
              Gap(20),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Points Earned : 304", style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),)),
              Gap(8),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index){
                    return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: (_showShimmerLoader)?Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.22,
                          decoration: BoxDecoration(
                            color: Color(0XFF535353),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 8,
                                spreadRadius: 0.5,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/images/ic_launcher.png",
                                            width: MediaQuery.of(context).size.width * 0.15,
                                            height: MediaQuery.of(context).size.height * 0.03,
                                          ),
                                          Text(
                                            "WAW",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Gap(15),
                                          CircleAvatar(
                                            radius: MediaQuery.of(context).size.width * 0.05,
                                            backgroundImage: AssetImage("assets/images/personimage.jpg"),
                                            backgroundColor: Colors.transparent,
                                          ),
                                          Gap(3),
                                          Text("User @121324234",
                                            maxLines: 2,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 9,
                                            ),
                                          ),
                                          Gap(3),
                                          Text("Trivandrum, Technocity 123",
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 9,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex: 7,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.45,
                                            height: MediaQuery.of(context).size.height * 0.08,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Image.asset(
                                              "assets/images/thumbnailimage.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Gap(3),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.45,
                                            child: Text("Video : Demo title video 123",
                                              maxLines: 2,
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                          Gap(3),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.45,
                                            child: Text("Points Earned : 15",
                                              maxLines: 2,
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                          Gap(3),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.45,
                                            child: Text("5426 views",
                                              maxLines: 2,
                                              style: GoogleFonts.poppins(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                          Gap(5),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.45,
                                            child: Text("WATCHED ON",
                                              maxLines: 1,
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                          Gap(3),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.45,
                                            child: Text("16.12.2024 10:00 AM",
                                              maxLines: 1,
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ) : ShimmerProfileListView()
                    );
                  }
              )
            ],
          ),
        ):Align(
          alignment: Alignment.bottomCenter,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white24,
                    Colors.brown,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white24,
                  width: 0.5,
                ),
              ),

              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Gap(20),
                      Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      Gap(20),
                      GestureDetector(
                        onTap: () async {
                          await _pickImage();
                        },
                        child: CircleAvatar(
                          radius: 50, // Control the size of the circle
                          backgroundColor: Colors.grey[300], // Background color of the circle
                          child: _image == null
                              ? Icon(Icons.add_a_photo, size: 30, color: Colors.grey) // Placeholder icon
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
                          hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 14, fontWeight: FontWeight.w300),
                          prefixIcon: Icon(Iconsax.user, color: Colors.yellow,),
                          contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                          prefixIconConstraints: BoxConstraints(minWidth: 50),
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
                          hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 14, fontWeight: FontWeight.w300),
                          prefixIcon: Image.asset("assets/images/whatsapplogo.png", color: Colors.yellow,),
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
                          _mobileWhatsp.text = v.toString();
                        },
                      ),
                      Gap(15),
                      TextFormField(
                        controller: _email,
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 14, fontWeight: FontWeight.w300),
                          prefixIcon: Icon(Icons.mail_outline_sharp, color: Colors.yellow,),
                          contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                          prefixIconConstraints: BoxConstraints(minWidth: 50),
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
                          hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 14, fontWeight: FontWeight.w300),
                          prefixIcon: Icon(Icons.location_city, color: Colors.yellow,),
                          contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                          prefixIconConstraints: BoxConstraints(minWidth: 50),
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
                        menuMaxHeight: 500,
                        icon: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: Colors.yellow,
                          ),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Select District',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.white38,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          prefixIcon: Icon(Icons.location_on, color: Colors.yellow),
                          contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                          prefixIconConstraints: BoxConstraints(minWidth: 50),
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
                        items: countries.map((district) {
                          return DropdownMenuItem<String>(
                            value: district,
                            child: Text(
                              district,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                        selectedItemBuilder: (BuildContext context) {
                          return countries.map((district) {
                            return Text(
                              district,
                              style: GoogleFonts.poppins(
                                color: Colors.white, // White color for selected item
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
      ),
    );
  }

  Future<void> _login() async {
    // if (!_formKey.currentState!.validate()) return;
    // setState(() {
    //   submitting = true;
    // });
    context.pushRoute(OtpRoute());
    try {

    } catch (e) {
      // ignore: use_build_context_synchronously
    }
    // setState(() {
    //   submitting = false;
    // });
  }
}
