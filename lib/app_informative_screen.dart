import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waw/rest/hive_repo.dart';
import 'package:waw/routes/app_router.gr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waw/routes/app_router.gr.dart';
import 'package:waw/theme/colors.dart';
import 'package:waw/widgets/login_button.dart';

import '../../gen/assets.gen.dart';


@RoutePage()
class AppInformationScreen extends StatefulWidget {
  const AppInformationScreen({super.key});

  @override
  State<AppInformationScreen> createState() => _AppInformationScreenState();
}

class _AppInformationScreenState extends State<AppInformationScreen> with SingleTickerProviderStateMixin{

  late AnimationController _animationController;
  late Animation<double> _animation;
  int _currentSlide = 0;
  CarouselSliderController _carouselController = CarouselSliderController ();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);

    _animationController.forward();
    HiveRepo.instance.setInfoScreenWatched(value: "watched");
    HiveRepo.instance.setInitialNotification(value: "0");
  }

  List<String> images = [
    'assets/images/infoscreenone.png',
    'assets/images/infoscreentwo.png',
    'assets/images/infoscreenthree.png',
  ];

  List<String> texts = [
    'Make Money feature to your app can be a great way to engage users, but it should be done ethically and transparently. Below is a step-by-step guide and example of how you might implement this feature, such as a rewards-based system or earning tasks',
    'Make Money feature to your app can be a great way to engage users, but it should be done ethically and transparently. Below is a step-by-step guide and example of how you might implement this feature, such as a rewards-based system or earning tasks.',
    'Make Money feature to your app can be a great way to engage users, but it should be done ethically and transparently. Below is a step-by-step guide and example of how you might implement this feature, such as a rewards-based system or earning tasks.',
  ];
  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: screenBackgroundColor,
        body: SafeArea(
          child: SizedBox(
            height: screenHeight * 1,
            width: screenWidth * 1,
            child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FadeTransition(
                        opacity: _animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0.0, 1.0),
                            end: Offset(0.0, 0.0),
                          ).animate(_animationController),
                          child: Image.asset("assets/images/ic_launcher.png", height: screenHeight * 0.05),
                        ),
                      ),
                      Container(
                        height: screenHeight * 0.8,
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 0.8,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: CarouselSlider.builder(
                          carouselController: _carouselController,
                          itemCount: images.length,
                          itemBuilder: (BuildContext context, int index, int realIndex) {
                            return Container(
                              padding: EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.asset(
                                      images[index],
                                      height: screenHeight * 0.55,
                                      width: screenWidth * 0.8,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(texts[index],
                                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey),
                                    maxLines: 5,
                                  ),
                                  LoginButton(
                                    title: "Next",
                                    showActions: false,
                                    onPressed: () {
                                      if(_currentSlide == 2){
                                        context.router.replace(DashboardRoute(bottomIndex: 0));
                                      }else{
                                        _carouselController.nextPage();
                                      }

                                    },
                                  )
                                ],
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height,
                            autoPlay: false,
                            enlargeCenterPage: true,
                            aspectRatio: 16/9,
                            autoPlayCurve: Curves.bounceIn,
                            enableInfiniteScroll: false,
                            autoPlayAnimationDuration: const Duration(milliseconds: 800),
                            viewportFraction: 1,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentSlide = index;
                              });
                            },
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: (){
                              context.router.replace(DashboardRoute(bottomIndex: 0));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 15.0),
                              child: Text(
                                  "Skip >",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey
                                  )
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Positioned(
                    bottom: screenHeight * 0.05,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(images.length, (index) {
                        return Container(
                          width: _currentSlide == index  ? 15.0 : 6.0,
                          height: 6.0,
                          margin: const EdgeInsets.symmetric(horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: _currentSlide == index ? Colors.yellow : Colors.grey
                            ,
                          ),
                        );
                      }),
                    ),
                  ),
                ]
            ),
          ),
        )
    );
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
