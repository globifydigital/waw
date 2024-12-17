

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waw/theme/colors.dart';
import '../../providers/video_provider.dart';
import '../../routes/app_router.gr.dart';
import '../../widgets/profile_shimmer_view.dart';

@RoutePage()
class MenuTab extends ConsumerStatefulWidget {
  const MenuTab({super.key});

  @override
  ConsumerState<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends ConsumerState<MenuTab> with SingleTickerProviderStateMixin{


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () => context.pushRoute(DashboardRoute(bottomIndex: 0)),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white,size: 25,)),
        title: Text("Menu", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child:CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.1,
                  backgroundImage: AssetImage("assets/images/personimage.jpg"),
                  backgroundColor: Colors.transparent,
                ),
              ),
              Gap(15),
              Center(child: Text("User@121232", style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),)),
              Gap(2),
              Center(child: Text("9874562130", style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),)),
              Gap(25),
              GestureDetector(
                onTap: ()=> context.pushRoute(ProfileRoute()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.white54,),
                        SizedBox(width: 10),
                        Text("Profile", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white54,size: 18,)
                  ],
                ),
              ),
              Gap(25),
              GestureDetector(
                onTap: ()=> context.pushRoute(NotificationsRoute(bottomIndex: 3)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.notifications, color: Colors.white54,),
                        SizedBox(width: 10),
                        Text("Notifications", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white54,size: 18,)
                  ],
                ),
              ),
              Gap(25),
              GestureDetector(
                onTap: ()=> context.pushRoute(AboutUsRoute()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/images/aboutusiconimage.png", height: 20, color: Colors.white54,),
                        SizedBox(width: 10),
                        Text("About Us", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white54,size: 18,)
                  ],
                ),
              ),
              Gap(25),
              GestureDetector(
                onTap: ()=> context.pushRoute(PrivacyPolicyRoute()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/images/privacypolicyiconimage.png", height: 20, color: Colors.white54,),
                            SizedBox(width: 10),
                            Text("Privacy Policy", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                          ],
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white54,size: 18,)
                  ],
                ),
              ),
              Gap(25),
              GestureDetector(
                onTap: ()=> context.pushRoute(TermsAndConditionRoute()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/images/termsandconditioniconimage.png", height: 20, color: Colors.white54,),
                        SizedBox(width: 10),
                        Text("Terms & Conditions", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white54,size: 18,)
                  ],
                ),
              ),
              Gap(40),
              GestureDetector(
                onTap: (){
                  _showSuccessDialog();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/images/logouticonimage.png", height: 20, color: Colors.white54,),
                        SizedBox(width: 10),
                        Text("Logout", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }


  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {

        return StatefulBuilder(
          builder: (BuildContext context, setState) {

            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Container(
                color: screenBackgroundColor,
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Gap(15),
                      Text(
                        "Logout",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Gap(5),
                      Text(
                        "Are you sure you want to log out ?",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Gap(25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () => context.popRoute(),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
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
                                child: Text("No", style: GoogleFonts.poppins(color: Colors.white24),),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.pushRoute(DashboardRoute(bottomIndex: 0)),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
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
                                child: Text("Yes", style: GoogleFonts.poppins(color: Colors.white24),),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}