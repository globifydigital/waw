import 'dart:async'; // Import for Timer
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:waw/routes/app_router.gr.dart';
import 'package:waw/theme/colors.dart';
import '../rest/hive_repo.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  with TickerProviderStateMixin{

  bool _isVisible = false;
  String infoScreenValue = "";

  @override
  void initState() {
    super.initState();
    HiveRepo.instance.setBaseUrl(baseUrl: "https://wawapp.globify.in/api");
    infoScreenValue = HiveRepo.instance.getInfoScreenValue() ?? "";
    Timer(const Duration(seconds: 2), () {
      if(infoScreenValue == "watched"){
        context.router.replace(DashboardRoute(bottomIndex: 0));
      }else{
        context.router.replace(const AppInformationRoute());
      }
    });
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          color: screenBackgroundColor,
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 500),
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Image.asset(
                "assets/images/ic_launcher.png",
                width: MediaQuery.of(context).size.width * 0.3,
              ),
            ),
          ),
        ),
      )
    );
  }
}
