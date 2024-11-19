import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waw/theme/colors.dart';

import '../../routes/app_router.gr.dart';
import '../../widgets/ticket_widget.dart';



@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () => context.pushRoute(DashboardRoute()),
            child: Icon(Icons.arrow_back_ios_new, color: Colors.white,size: 25,)),
        title: Text("Profile", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: PopupMenuButton<String>(
              color: Colors.transparent,
              elevation: 0,
              onSelected: (value) {
                if (value == 'edit') {

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
        child: SingleChildScrollView(
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
                    onTap: () => context.pushRoute(DashboardRoute()),
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
                    onTap: () => context.pushRoute(DashboardRoute()),
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
                    child: Container(
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
                    ),
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}
