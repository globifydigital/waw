import 'dart:convert';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waw/theme/colors.dart';

import '../../routes/app_router.gr.dart';



@RoutePage()
class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {


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
            onTap: () => context.pushRoute(DashboardRoute(bottomIndex: 3)),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white,size: 25,)),
        title: Text("About Us", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          "Welcome to [Your App Name] – the ultimate platform for connecting brands with their audience in a smarter, faster, and more efficient way.At [Your App Name], we believe in the power of impactful advertising. Whether you're a business looking to expand your reach or a user seeking valuable insights and offers, our app bridges the gap to deliver a seamless experience for everyone.Our MissionOur mission is to revolutionize the advertising industry by making it accessible and meaningful for all. We strive to empower businesses of all sizes to create campaigns that resonate while rewarding users for their time and attention.What We OfferFor Businesses: A dynamic, easy-to-use platform to design, manage, and optimize ad campaigns, ensuring maximum engagement and results.For Users: Personalized content and exclusive rewards, all while keeping your preferences and data privacy a top priority.Why Choose UsInnovative Technology: Leverage cutting-edge tools for targeting and analytics.Transparency: We prioritize honesty and clarity in all transactions and interactions.Community-Driven: Your feedback fuels our innovation and shapes the future of advertising.Join Our JourneyWe’re here to transform the way the world interacts with advertising. Together, we can create a future where ads aren’t interruptions—they’re opportunities.",
          style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontSize: 12, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),
        ),
      ),
    );
}
}
