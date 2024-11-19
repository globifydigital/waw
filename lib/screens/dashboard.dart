import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:waw/routes/app_router.gr.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../theme/colors.dart';

@RoutePage()
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<String> videoUrls = [
    'https://www.youtube.com/watch?v=3UeaPkLBdmc',
    'https://www.youtube.com/watch?v=xzkZWjwt5vw',
  ];

  final List<String> recentlyViewedVideoUrls = [
    'https://www.youtube.com/watch?v=xTpv9lc_qMw',
    'https://www.youtube.com/watch?v=Dr_8tvQjY9M',
    'https://www.youtube.com/watch?v=-nG5enxw100',
    'https://www.youtube.com/watch?v=xzkZWjwt5vw',

  ];

  Map<int, double> _progressMap = {};
  Map<int, double> _videoDurationMap = {};
  Map<int, bool> _isPressingMap = {};
  Map<int, DateTime> _pressStartTimeMap = {};

  final int _holdDuration = 60;

  // Function to handle the start of the press for each video
  void _onPressStart(int index, LongPressStartDetails details) {
    setState(() {
      _isPressingMap[index] = true;
      _progressMap[index] = 0.0; // Reset progress when press starts
      _pressStartTimeMap[index] = DateTime.now();
    });
  }

  // Function to handle the press update (long press progress)
  void _onPressUpdate(int index, LongPressMoveUpdateDetails details) {
    if (_isPressingMap[index] == true) {
      final elapsedTime = DateTime.now().difference(_pressStartTimeMap[index]!).inSeconds;
      setState(() {
        _progressMap[index] = (elapsedTime / _videoDurationMap[index]!).clamp(0.0, 1.0);
      });
    }
    if (_progressMap[index] == 1.0) {
      _showSuccessDialog();
      setState(() {
        _isPressingMap[index] = false;
        _progressMap[index] = 0.0; // Reset progress when the press ends
      });
    }
  }

  // Function to handle the end of the press for each video
  void _onPressEnd(int index, LongPressEndDetails details) {
    setState(() {
      _isPressingMap[index] = false;
      _progressMap[index] = 0.0; // Reset progress when the press ends
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
          title: Text('Waw' , style: GoogleFonts.laBelleAurore(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.yellow),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: () => context.pushRoute(const ProfileRoute()),
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.045,
                backgroundImage: AssetImage("assets/images/personimage.jpg"),
                backgroundColor: Colors.transparent,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(5),
              Center(
                  child: Text("Watch this videos and get a chance to", style: GoogleFonts.poppins(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),)),
              Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'WIN : ',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: 'INR 5,00,000',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              Gap(15),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: videoUrls.length,
                itemBuilder: (context, index) {
                  String videoId = YoutubePlayer.convertUrlToId(videoUrls[index])!;
                  _videoDurationMap[index] = 10.00;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Ad posted : 11/06/2024 10:00 AM", style: GoogleFonts.poppins(fontSize: 8, color: Colors.white, fontWeight: FontWeight.w500),),
                          Text("30 sec", style: GoogleFonts.poppins(fontSize: 9, color: Colors.yellow, fontWeight: FontWeight.w500),),
                        ],
                      ),
                      Gap(5),
                      YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId: videoId,
                          flags: YoutubePlayerFlags(
                            autoPlay: false,
                            mute: false,
                            isLive: false,
                            forceHD: true,
                          ),
                        ),
                        showVideoProgressIndicator: true,
                      ),
                      Gap(10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * (_progressMap[index] ?? 0.0),
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.yellow[300],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                            // Text in the center
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                                child: Text(
                                  (_isPressingMap[index] == true)
                                      ? "Reward in ${(_videoDurationMap[index]! - (_progressMap[index] ?? 0.0) * _videoDurationMap[index]!).toStringAsFixed(1)} seconds"
                                      : "Press and hold to watch the Ad!",
                                  style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(15),
                      Center(
                        child: GestureDetector(
                          onLongPressStart: (details) => _onPressStart(index, details),
                          onLongPressMoveUpdate: (details) => _onPressUpdate(index, details),
                          onLongPressEnd: (details) => _onPressEnd(index, details),
                          child: AvatarGlow(
                            glowCount: 2,
                            glowRadiusFactor: 0.2,
                            glowShape: BoxShape.circle,
                            child: Material(
                              elevation: 8.0,
                              shape: CircleBorder(),
                              child: CircleAvatar(
                                  // backgroundColor: Color(0XFFFF0033),
                                  backgroundColor: Colors.yellow,
                                  radius: 30,
                                  child: Center(child: Icon(Icons.play_arrow, color: Colors.black, size: 30 ,))),
                            ),
                          ),
                        ),
                      ),
                      Gap(10),
                    ],
                  );
                },
              ),
              Gap(20),
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Recently viewed ads", style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),),
                    GestureDetector(
                      onTap: () => context.pushRoute(RecentAdsRoute()),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 30,
                        decoration: BoxDecoration(
                          color: screenBackgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: Center(child: Text("See All", style: GoogleFonts.poppins(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),)),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentlyViewedVideoUrls.length,
                itemBuilder: (context, index) {
                  String videoId = YoutubePlayer.convertUrlToId(recentlyViewedVideoUrls[index])!;
                  return GestureDetector(
                    onTap: (){
                       _showVideoPopup(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: screenBackgroundColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.3,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text("New mango flavour KitKat extra pack", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 13),)),
                          SizedBox(
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: YoutubePlayer(
                              controller: YoutubePlayerController(
                                initialVideoId: videoId,
                                flags: const YoutubePlayerFlags(
                                  autoPlay: false,
                                  mute: false,
                                  isLive: false,
                                  forceHD: true,
                                ),
                              ),
                              showVideoProgressIndicator: true,
                              onReady: () {
                                // Additional setup if needed
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          )
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Initializing _isVisible here to ensure it's within the builder scope
        bool _isVisible = false;

        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            // Use setState within the StatefulBuilder to trigger rebuilds inside the dialog
            Future.delayed(Duration(milliseconds: 350), () {
              setState(() {
                _isVisible = true;
              });
            });

            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: FractionallySizedBox(
                widthFactor: MediaQuery.of(context).size.width * 0.0035,
                heightFactor: 0.55,
                child: Container(
                  color: screenBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
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
                              child: CircleAvatar(
                                  backgroundColor:Colors.grey,
                                  radius: MediaQuery.of(context).size.height * 0.04,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Image.asset("assets/images/successicon.png"),
                                  ))
                            ),
                          ),
                        ),
                        Gap(15),
                        Center(
                          child: Text(
                            "You have successfully watched the video ad.",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Gap(5),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "You won ",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                  text: "15",
                                  style: GoogleFonts.poppins(
                                    color: Colors.yellow, // Change this to your desired color
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                TextSpan(
                                  text: " points",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap(15),
                        Container(
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
                                            width: MediaQuery.of(context).size.width * 0.35,
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
                                            width: MediaQuery.of(context).size.width * 0.35,
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
                                            width: MediaQuery.of(context).size.width * 0.35,
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
                                            width: MediaQuery.of(context).size.width * 0.35,
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
                                            width: MediaQuery.of(context).size.width * 0.35,
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
                                            width: MediaQuery.of(context).size.width * 0.35,
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
                        Gap(25),
                        GestureDetector(
                          onTap: () => context.pushRoute(DashboardRoute()),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.35,
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.home_filled, color: Colors.white24,),
                                  Gap(10),
                                  Text("Go To Home", style: GoogleFonts.poppins(color: Colors.white24),)
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }


  void _showVideoPopup(BuildContext context) {
    String videoId = YoutubePlayer.convertUrlToId(videoUrls[0])!;

    // Create the controller for YoutubePlayer
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        isLive: false,
        forceHD: true,
      ),
    );

    // Show a dialog with the video player
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.all(0),
          child: Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height * 1,
            width: double.infinity,
            child: Column(
              children: [
                // Video Player
                Expanded(
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    onReady: () {
                      _controller.play();
                    },
                  ),
                ),
                // Close Button
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    _controller.dispose(); // Dispose of the controller when closing
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
