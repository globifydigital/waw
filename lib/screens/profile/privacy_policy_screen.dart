import 'dart:convert';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waw/theme/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../routes/app_router.gr.dart';



@RoutePage()
class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {

  late WebViewController _con;
  String _html = "";

  setHTML(){
    _html = '''
      <!DOCTYPE html>
<html lang="en">
<head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Simple HTML Page</title>
        <style>
            body {
                background-color: #0D1721;
                color: white; /* Ensures text is readable on a dark background */
                margin: 0;
                font-family: Arial, sans-serif;
                font-size: 14px; /* Reduced font size */
            }
            h1 {
                font-size: 20px; /* Reduced heading font size */
            }
            p {
                font-size: 12px; /* Reduced paragraph font size */
            }
            a {
                color: lightblue; /* Adjust link color for visibility */
                font-size: 14px; /* Consistent font size for links */
            }
        </style>
    </head>
<body>
    <p>Welcome to [Your App Name] – the ultimate platform for connecting brands with their audience in a smarter, faster, and more efficient way.

At [Your App Name], we believe in the power of impactful advertising. Whether you're a business looking to expand your reach or a user seeking valuable insights and offers, our app bridges the gap to deliver a seamless experience for everyone.

Our Mission
Our mission is to revolutionize the advertising industry by making it accessible and meaningful for all. We strive to empower businesses of all sizes to create campaigns that resonate while rewarding users for their time and attention.

What We Offer
For Businesses: A dynamic, easy-to-use platform to design, manage, and optimize ad campaigns, ensuring maximum engagement and results.
For Users: Personalized content and exclusive rewards, all while keeping your preferences and data privacy a top priority.
Why Choose Us?
Innovative Technology: Leverage cutting-edge tools for targeting and analytics.
Transparency: We prioritize honesty and clarity in all transactions and interactions.
Community-Driven: Your feedback fuels our innovation and shapes the future of advertising.
Join Our Journey
We’re here to transform the way the world interacts with advertising. Together, we can create a future where ads aren’t interruptions—they’re opportunities.</p>
</body>
</html>
    ''';
  }

  _loadHtml(){
    setHTML();
    _con..loadRequest(Uri.dataFromString(
        _html,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ));
  }

  @override
  void initState() {
    super.initState();
    setHTML();
    _con = WebViewController()
      ..loadHtmlString(_html);
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
        title: Text("Privacy Policy", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: WebViewWidget(
          controller: _con,
        ),
      ),
    );
  }
}
