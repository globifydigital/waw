import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:waw/routes/app_router.gr.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../providers/video_provider.dart';
import '../../theme/colors.dart';
import '../../widgets/dashboard_shimmer_view.dart';

@RoutePage()
class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {

  List<VideoPlayerController> _controllers = [];
  List<VideoPlayerController> _controllersWatchedVideos = [];


  bool _showloader = false;
  late Timer _timer;

  Map<int, Timer?> _timerMap = {};
  Map<int, bool> _isPressingMap = {};
  Map<int, double> _progressMap = {};
  Map<int, DateTime?> _pressStartTimeMap = {};
  Map<int, double> _videoDurationMap = {};
  Map<int, String> _remainingTimeMap = {};


  void _onPressStart(int index, LongPressStartDetails details) {
    Duration videoDuration = Duration();

    if (!_controllers[index].value.isInitialized) {
      _controllers[index].initialize().then((_) {
        setState(() {
          _controllers[index].play();
          videoDuration = _controllers[index].value.duration;
          _initializeVideoData(index, videoDuration);
        });
      });
    } else {
      setState(() {
        videoDuration = _controllers[index].value.duration;
        _controllers[index].play();
        _initializeVideoData(index, videoDuration);
      });
    }

    // Cancel any existing timer
    _timerMap[index]?.cancel();

    // Start a periodic timer to update every second
    _timerMap[index] = Timer.periodic(const Duration(seconds: 1), (timer) {
      final elapsedTime =
          DateTime.now().difference(_pressStartTimeMap[index]!).inSeconds;

      final remainingTime = _videoDurationMap[index]! - elapsedTime;

      setState(() {
        _remainingTimeMap[index] = _formatRemainingTime(remainingTime);
        _progressMap[index] = elapsedTime / _videoDurationMap[index]!;
        if (remainingTime <= 0) {
          timer.cancel();
          _showSuccessDialog();
          _resetButtonState(index);
        }
      });
    });
  }

  void _initializeVideoData(int index, Duration videoDuration) {
    _videoDurationMap[index] = videoDuration.inSeconds.toDouble();
    _isPressingMap[index] = true;
    _progressMap[index] = 0.0;
    _pressStartTimeMap[index] = DateTime.now(); 
  }

  String _formatRemainingTime(double remainingSeconds) {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '$minutes.${seconds.toStringAsFixed(0).padLeft(2, '0')}';
  }


  void _onPressEnd(int index, LongPressEndDetails details) {
    _resetButtonState(index);
  }

  void _resetButtonState(int index) {
    setState(() {
      _isPressingMap[index] = false;
      _isPressingMap[index] = false;
      _controllers[index].seekTo(Duration.zero);
      _controllers[index].pause();
      _progressMap[index] = 0.0;
      _timerMap[index]?.cancel();
      _timerMap[index] = null;
    });
  }


  String convertDuration(Duration duration) {
    try {
      int minutes = duration.inMinutes;
      int seconds = duration.inSeconds % 60;
      int milliseconds = duration.inMilliseconds % 1000;
      double fractionalSeconds = milliseconds / 1000;
      double formattedDuration = minutes + (seconds + fractionalSeconds) / 100;
      return formattedDuration.toStringAsFixed(2);
    } catch (e) {
      return "Invalid time format";
    }
  }

  String convertTo12HourFormat(String time24Hour) {
    DateTime parsedTime = DateFormat("HH:mm").parse(time24Hour);
    String time12Hour = DateFormat("h:mm a").format(parsedTime);
    return time12Hour;
  }

  getData()async{
    await ref.read(videoListProvider).getAllVideos();
    final videoProvider = ref.watch(videoListProvider);
    final allVideosListShowing = videoProvider.allVideosListState;
    for(int i=0; i<allVideosListShowing.length; i++){
      String videoUrl = allVideosListShowing[i].video.toString();
      _controllers.add(VideoPlayerController.network("https://wawapp.globify.in/public/storage/$videoUrl"));
    }
    Future.wait(_controllers.map((controller) => controller.initialize())).then((_) {
      setState(() {});
    });
    await ref.read(videoListProvider).getAllWatchedVideos("9562826851");
    final watchedVideoProvider = ref.watch(videoListProvider);
    final allWatchedVideosListShowing = watchedVideoProvider.allWatchedVideosListState;
    for(int i=0; i<allWatchedVideosListShowing.length; i++){
      String videoUrl = allWatchedVideosListShowing[i].video!.video.toString();
      _controllersWatchedVideos.add(VideoPlayerController.network("https://wawapp.globify.in/public/storage/$videoUrl"));
    }
    Future.wait(_controllersWatchedVideos.map((controller) => controller.initialize())).then((_) {
      setState(() {});
    });
  }


  @override
  void initState() {
    getData();
    super.initState();
    _timer = Timer(Duration(seconds: 2), () {
      setState(() {
        _showloader = true;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = ref.watch(videoListProvider);
    final allVideosListShowing = videoProvider.allVideosListState;
    final allWatchedVideosListShowing = videoProvider.allWatchedVideosListState;
    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Image.asset("assets/images/wawtheme.png", height: MediaQuery.of(context).size.height * 0.02),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: () => context.pushRoute(NotificationsRoute(bottomIndex: 0)),
              child: Stack(
                clipBehavior: Clip.none, // Allows the dot to overflow
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.045,
                    backgroundColor: Colors.transparent,
                    child: const Icon(
                      Iconsax.notification4,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 10,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        shape: BoxShape.circle
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
            child: (_showloader)?Column(
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
                  itemCount: allVideosListShowing.length,
                  itemBuilder: (context, index) {
                    VideoPlayerController controller = _controllers[index];
                    final video = allVideosListShowing[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Ad posted : ${allVideosListShowing[index].date}  ${convertTo12HourFormat(allVideosListShowing[index].time.toString())}", style: GoogleFonts.poppins(fontSize: 8, color: Colors.white, fontWeight: FontWeight.w500),),
                            Text("${_controllers[index].value.duration.inSeconds.toDouble()} sec", style: GoogleFonts.poppins(fontSize: 9, color: Colors.yellow, fontWeight: FontWeight.w500),),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.28,
                          width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: SizedBox(
                              width: controller.value.size.width,
                              height: controller.value.size.height,
                              child: VideoPlayer(controller),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
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
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                                  child: Text(
                                    _isPressingMap[index] == true
                                        ? "Rewards in ${_remainingTimeMap[index] ?? ""} seconds"
                                        : "Press and hold to watch the Ad!",
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                            // onLongPressMoveUpdate: (details) => _onPressUpdate(index, details),
                            onLongPressEnd: (details) => _onPressEnd(index, details),
                            child: AvatarGlow(
                              glowCount: 2,
                              glowRadiusFactor: 0.2,
                              glowShape: BoxShape.circle,
                              child: const Material(
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
                  itemCount: allWatchedVideosListShowing.length,
                  itemBuilder: (context, index) {
                    VideoPlayerController controller = _controllersWatchedVideos[index];
                    return GestureDetector(
                      onTap: (){
                        _showVideoPopup(context, _controllersWatchedVideos[index]);
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
                                child: Text(allWatchedVideosListShowing[index].video!.title.toString(), style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 13),)),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: SizedBox(
                                  width: controller.value.size.width,
                                  height: controller.value.size.height,
                                  child: VideoPlayer(controller),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ): ShimmerDashboardListView()
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
                heightFactor: (2/2==0)?0.55:0.4,
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
                        if(2/2==0)Container(
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
                        if(2/2==1)Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Register now to get your rewards..!",
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Gap(10),
                            GestureDetector(
                              onTap: () => context.pushRoute(SignUpRoute()),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    "Register",
                                    style: GoogleFonts.poppins(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -1,
                                    child: Container(
                                      width: 90,
                                      height: 3,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Gap(25),
                        GestureDetector(
                          onTap: () => context.pushRoute(DashboardRoute(bottomIndex: 0)),
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


  void _showVideoPopup(BuildContext context, VideoPlayerController controller) {

    if (!controller.value.isInitialized) {
      controller.initialize().then((_) {
        setState(() {
          controller.play();
        });
      });
    } else {
      setState(() {
        controller.play();
      });
    }

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
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                ),
                // Close Button
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    controller.seekTo(Duration.zero);
                    controller.pause();
                    Navigator.of(context).pop();
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
