import 'dart:async';
import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:waw/rest/hive_repo.dart';
import 'package:waw/routes/app_router.gr.dart';
import '../../models/notification/notification_model.dart';
import '../../models/videos/all_unwatched_videos.dart';
import '../../models/videos/all_videos_model.dart';
import '../../models/videos/all_watched_videos_model.dart';
import '../../providers/notiification_provider.dart';
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

  List<VideoPlayerController> _controllersForSuccesPopUp = [];
  List<VideoPlayerController> _controllers = [];
  VideoPlayerController? _controllersWatchedVideos;
  List<VideoPlayerController> _controllersUnWatchedVideos = [];

  List<AllVideosListModel> allVideosListShowing = [];
  List<AllWatchedVideosList> allWatchedVideosListShowing = [];
  List<UnWatchedVideosList> unWatchedVideosListShowing = [];

  /// for post api when video watched
  int userVideoPoint = 0;
  String userVideoStartDateTime = "";
  String userVideoStartDate = "";
  String userWatchedVideoDuration= "";


  bool _showloader = false;

  /// for notification count
  num notificationCount = 0;
  List<NotificationList> notificationList = [];

  Map<int, Timer?> _timerMap = {};
  Map<int, bool> _isPressingMap = {};
  Map<int, double> _progressMap = {};
  Map<int, DateTime?> _pressStartTimeMap = {};
  Map<int, double> _videoDurationMap = {};
  Map<int, String> _remainingTimeMap = {};


  int calculateUserPoints(String videoPostTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');

    DateTime videoPosted = formatter.parse(videoPostTime);

    DateTime currentTime = DateTime.now();
    userVideoStartDateTime = DateFormat('MM-dd-yyyy hh:mm:ss').format(currentTime);
    userVideoStartDate = DateFormat('MM-dd-yyyy').format(currentTime);
    int timeDifferenceInMinutes = currentTime.difference(videoPosted).inMinutes;

    if (timeDifferenceInMinutes <= 15) {
      return 15;
    } else if (timeDifferenceInMinutes <= 30) {
      return 10;
    } else if (timeDifferenceInMinutes <= 45) {
      return 5;
    } else {
      return 1;
    }
  }

  void _onPressStart(int index, LongPressStartDetails details, UnWatchedVideosList unwatchedVideoModel) {
    String videoUrl = "https://wawapp.globify.in/storage/app/public/${unwatchedVideoModel.video}";
    print("Video URL: $videoUrl");
    String videoTimeDurationString = unwatchedVideoModel.videoTimeDuration.toString();  // "0:20"

    // Split the string to extract minutes and seconds
    List<String> timeParts = videoTimeDurationString.split(':');
    Duration videoDuration = Duration(
      minutes: int.parse(timeParts[0]),
      seconds: int.parse(timeParts[1]),
    );

    // Now, videoDuration is a valid Duration object
    print("Video Duration: $videoDuration");
    String videoTime = "${unwatchedVideoModel.date} ${unwatchedVideoModel.time}";
    userVideoPoint = 0;
    userVideoPoint = calculateUserPoints(videoTime);
    print("User Video Point: $userVideoPoint");

    if (HiveRepo.instance.user != null) {
      print("User is logged in");
      _controllersUnWatchedVideos[index] = VideoPlayerController.network(videoUrl);
      _controllersUnWatchedVideos[index].initialize().then((_) {
        if (_controllersUnWatchedVideos[index].value.isInitialized) {
          setState(() {
            _controllersUnWatchedVideos[index].play();
            userWatchedVideoDuration = videoDuration.toString();
            _initializeVideoData(index, videoDuration);
          });
        } else {
          print("Failed to initialize video controller.");
        }
      }).catchError((error) {
        print("Error initializing video controller: $error");
      });
    } else {
      print("User is not logged in");
      _controllers[index] = VideoPlayerController.network(videoUrl);
      _controllers[index].initialize().then((_) {
        print("Video initialized: ${_controllers[index].value.isInitialized}");
        if (_controllers[index].value.isInitialized) {
          setState(() {
            _controllers[index].play();
            print("Video started playing...");
            print("videoDurationvideoDurationvideoDurationvideoDurationvideoDuration$videoDuration");
            userWatchedVideoDuration = videoDuration.toString();
            _initializeVideoData(index, videoDuration);
          });
        } else {
          print("Failed to initialize video controller.");
        }
      }).catchError((error) {
        print("Error initializing video controller: $error");
      });
    }

    // Cancel any existing timer
    _timerMap[index]?.cancel();

    // Start a periodic timer to update every second
    _timerMap[index] = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        final elapsedTime = DateTime.now().difference(_pressStartTimeMap[index]!).inSeconds;
        final remainingTime = _videoDurationMap[index]! - elapsedTime;

        setState(() {
          _remainingTimeMap[index] = _formatRemainingTime(remainingTime);
          _progressMap[index] = elapsedTime / _videoDurationMap[index]!;
          if (remainingTime <= 0) {
            timer.cancel();
            if (HiveRepo.instance.user != null) {
              postData(unwatchedVideoModel);
            }
            _showSuccessDialog(unwatchedVideoModel);
            _resetButtonState(index);
          }
        });
      }
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
      if(HiveRepo.instance.user != null){
        _controllersUnWatchedVideos[index].seekTo(Duration.zero);
        _controllersUnWatchedVideos[index].pause();
        if (_controllersUnWatchedVideos.isNotEmpty) {
          _controllersUnWatchedVideos.clear();
          _controllersUnWatchedVideos = List.generate(unWatchedVideosListShowing.length, (index) => VideoPlayerController.network(
            unWatchedVideosListShowing[index].video.toString(),
          ));
        }
      }else{
        _controllers[index].seekTo(Duration.zero);
        _controllers[index].pause();
        if (_controllers.isNotEmpty) {
          _controllers.clear();
          _controllers = List.generate(allVideosListShowing.length, (index) => VideoPlayerController.network(
            allVideosListShowing[index].video.toString(),
          ));
        }
      }
      _isPressingMap[index] = false;
      _isPressingMap[index] = false;
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

  String formatTimeToDoubleVideoDuration(String time) {
    // Extract hours, minutes, and seconds using RegExp
    final RegExp regExp = RegExp(r'(\d{1,2}):(\d{2}):(\d{2})');
    final match = regExp.firstMatch(time);

    if (match != null) {
      // Extract hours, minutes, and seconds
      int hours = int.parse(match.group(1)!);
      int minutes = int.parse(match.group(2)!);
      int seconds = int.parse(match.group(3)!);

      // Convert the time to the m:ss format
      // If hours are present, convert them into minutes
      minutes += hours * 60;

      // Format the result as 'm:ss'
      String formattedTime = '${minutes}:${seconds.toString().padLeft(2, '0')}';
      return formattedTime;
    } else {
      return 'Invalid time format';
    }
  }


  postData(UnWatchedVideosList unwatchedVideoModel) async {
    await ref.read(videoListProvider).updateUserWatchedVideoDetails(HiveRepo.instance.user!.data!.id.toString(), unwatchedVideoModel.id.toString(), userVideoPoint.toString(), userVideoStartDateTime, userVideoStartDate, formatTimeToDoubleVideoDuration(userWatchedVideoDuration));
  }

  // Future<void> _initializeWatchedVideoControllers() async {
  //     for (int i = 0; i < allWatchedVideosListShowing.length; i++) {
  //       String videoUrl = allWatchedVideosListShowing[i].video!.video.toString();
  //       _controllersWatchedVideos.add(VideoPlayerController.network("https://wawapp.globify.in/storage/app/public/$videoUrl"));
  //       await _controllersWatchedVideos[i].initialize().then((_) {
  //         setState(() {
  //
  //         });
  //
  //       }).onError((error, stackTrace) {
  //         log("Error: $error, StackTrace: $stackTrace");
  //       });
  //     }
  //
  // }



  getData() async {
    notificationList.clear();
    await ref.read(notificationProvider).getAllNotification();
    final notifications = ref.watch(notificationProvider);
    notificationList = notifications.allNotificationListState;
    if (HiveRepo.instance.user != null) {
      unWatchedVideosListShowing.clear();
      await ref.read(videoListProvider).getUnWatchedVideos(HiveRepo.instance.user!.data!.mobNo.toString());
      final unWatchedVideoProvider = ref.watch(videoListProvider);
      unWatchedVideosListShowing = unWatchedVideoProvider.unWatchedVideosListState;
      _controllersUnWatchedVideos = List.generate(unWatchedVideosListShowing.length, (index) => VideoPlayerController.network(
        unWatchedVideosListShowing[index].video.toString(),
      ));

      allWatchedVideosListShowing.clear();
      await ref.read(videoListProvider).getAllWatchedVideos(HiveRepo.instance.user!.data!.mobNo.toString());
      final watchedVideoProvider = ref.watch(videoListProvider);
      allWatchedVideosListShowing = watchedVideoProvider.allWatchedVideosListState;

    } else {
      allVideosListShowing.clear();
      await ref.read(videoListProvider).getAllVideos();
      final videoProvider = ref.watch(videoListProvider);
      allVideosListShowing = videoProvider.allVideosListState;
      _controllers = List.generate(allVideosListShowing.length, (index) => VideoPlayerController.network(
        allVideosListShowing[index].video.toString(),
      ));
    }
    setState(() {
      _showloader = true;
    });
  }




  @override
  void initState() {
    notificationCount = num.parse(HiveRepo.instance.getNotificationValue().toString());
    getData();
    super.initState();
  }

  @override
  void dispose() {
    disposeVideoPlayer();
    super.dispose();
  }

  disposeVideoPlayer() async {
    for (var controller in _controllersForSuccesPopUp) {
      if (controller.value.isInitialized) {
        await controller.dispose();
      }
    }
    for (var timer in _timerMap.values) {
      timer?.cancel();
    }
  }


  @override
  Widget build(BuildContext context) {
    final videoProvider = ref.watch(videoListProvider);
    final allVideosListShowing = videoProvider.allVideosListState;
    final allWatchedVideosListShowing = videoProvider.allWatchedVideosListState;
    final unWatchedVideosListShowing = videoProvider.unWatchedVideosListState;
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
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.045,
                    backgroundColor: Colors.transparent,
                    child: const Icon(
                      Iconsax.notification4,
                      color: Colors.white,
                    ),
                  ),
                  if(notificationList.isNotEmpty && notificationList.length > notificationCount)Positioned(
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
                (unWatchedVideosListShowing.isNotEmpty || allVideosListShowing.isNotEmpty)?ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (HiveRepo.instance.user != null) ? unWatchedVideosListShowing.length : allVideosListShowing.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Ad posted : ${(HiveRepo.instance.user != null) ? unWatchedVideosListShowing[index].date : allVideosListShowing[index].date}  ${convertTo12HourFormat((HiveRepo.instance.user != null) ? unWatchedVideosListShowing[index].time.toString() : allVideosListShowing[index].time.toString())}", style: GoogleFonts.poppins(fontSize: 8, color: Colors.white, fontWeight: FontWeight.w500),),
                            Text("${(HiveRepo.instance.user != null) ? unWatchedVideosListShowing[index].videoTimeDuration : allVideosListShowing[index].videoTimeDuration} sec", style: GoogleFonts.poppins(fontSize: 9, color: Colors.yellow, fontWeight: FontWeight.w500),),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: double.infinity,
                          child: (HiveRepo.instance.user != null) ? FittedBox(
                              fit: BoxFit.fill,
                              child: (_controllersUnWatchedVideos[index].value.isInitialized)?SizedBox(
                                width: _controllersUnWatchedVideos[index].value.size.width,
                                height: _controllersUnWatchedVideos[index].value.size.height,
                                child: VideoPlayer(_controllersUnWatchedVideos[index]),
                              ):SizedBox(
                                child: Image.network(
                                  "https://wawapp.globify.in/storage/app/public/${unWatchedVideosListShowing[index].thumbnail.toString()}",
                                ),
                              )
                          ) : FittedBox(
                            fit: BoxFit.fill,
                            child: (_controllers[index].value.isInitialized)?SizedBox(
                              width: _controllers[index].value.size.width,
                              height: _controllers[index].value.size.height,
                              child: VideoPlayer(_controllers[index]),
                            ):SizedBox(
                              child: Image.network(
                                "https://wawapp.globify.in/storage/app/public/${allVideosListShowing[index].thumbnail.toString()}",
                              ),
                            )
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
                            onLongPressStart: (details) {
                              if(HiveRepo.instance.user == null){
                                print("asdsadasdasdasdadadadasdasdadadadadadadadadadaadadadadadadadadada");
                                UnWatchedVideosList unWatchedVideos = UnWatchedVideosList();
                                unWatchedVideos.id = allVideosListShowing[index].id;
                                unWatchedVideos.agencyId = allVideosListShowing[index].agencyId;
                                unWatchedVideos.title = allVideosListShowing[index].title;
                                unWatchedVideos.video = allVideosListShowing[index].video;
                                unWatchedVideos.date = allVideosListShowing[index].date;
                                unWatchedVideos.time = allVideosListShowing[index].time;
                                unWatchedVideos.videoTimeDuration = allVideosListShowing[index].videoTimeDuration;
                                unWatchedVideos.videoLink = allVideosListShowing[index].videoLink;
                                unWatchedVideos.totalViews = allVideosListShowing[index].totalViews;
                                unWatchedVideos.status = allVideosListShowing[index].status;
                                unWatchedVideos.createdAt = allVideosListShowing[index].createdAt;
                                unWatchedVideos.updatedAt = allVideosListShowing[index].updatedAt;
                                unWatchedVideos.deletedAt = allVideosListShowing[index].deletedAt;
                                print("unWatchedVideos.videounWatchedVideos.videounWatchedVideos.videounWatchedVideos.video${unWatchedVideos.video}");
                                _onPressStart(index, details, unWatchedVideos);
                              }else{
                                _onPressStart(index, details, unWatchedVideosListShowing[index]);
                              }
                            },
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
                ):SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    child: Center(child: Text("The videos will be uploaded soon...\nStay tuned for updates",textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12,),))),
                Gap(20),
                if(HiveRepo.instance.user != null)SizedBox(
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
                if(HiveRepo.instance.user != null)Gap(20),
                if(HiveRepo.instance.user != null)ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: allWatchedVideosListShowing.take(5).length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        _showVideoPopup(context, index);
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
                                  child: Image.network(
                                    "https://wawapp.globify.in/storage/app/public/${allWatchedVideosListShowing[index].video!.thumbnail.toString()}",
                                  ),
                                )
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

  getSuccessPopUpData(UnWatchedVideosList unwatchedVideoModel) async {
    _controllersForSuccesPopUp.clear();
    if(HiveRepo.instance.user != null) _controllersForSuccesPopUp.add(VideoPlayerController.network("https://wawapp.globify.in/storage/app/public/${unwatchedVideoModel.video}"));
    Future.wait(_controllersForSuccesPopUp.map((controller) => controller.initialize())).then((_) {
      setState(() {});
    });
  }

  Future<void> _showSuccessDialog(UnWatchedVideosList unwatchedVideoModel) async {
    await getSuccessPopUpData(unwatchedVideoModel);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        bool isVisible = false;
        VideoPlayerController? controller;
        if(HiveRepo.instance.user != null) controller =  _controllersForSuccesPopUp[0];
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: StatefulBuilder(
            builder: (BuildContext context, setState) {
              Future.delayed(Duration(milliseconds: 350), () {
                setState(() {
                  isVisible = true;
                });
              });
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                content: FractionallySizedBox(
                  widthFactor: MediaQuery.of(context).size.width * 0.0035,
                  heightFactor: (HiveRepo.instance.user != null)?0.55:0.4,
                  child: Container(
                    color: screenBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: AnimatedOpacity(
                              opacity: isVisible ? 1.0 : 0.0,
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
                                    text: userVideoPoint.toString(),
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
                          const Gap(15),
                          if(HiveRepo.instance.user != null)Container(
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
                                              backgroundImage: NetworkImage(
                                                "https://wawapp.globify.in/storage/app/public/${HiveRepo.instance.user!.data!.image.toString()}",
                                              ),
                                              backgroundColor: Colors.transparent,
                                            ),
                                            Gap(3),
                                            Text(HiveRepo.instance.user!.data!.name.toString(),
                                              maxLines: 2,
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 9,
                                              ),
                                            ),
                                            Gap(3),
                                            Text(HiveRepo.instance.user!.data!.address.toString(),
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
                                            if(HiveRepo.instance.user != null)Container(
                                              width: MediaQuery.of(context).size.width * 0.35,
                                              height: MediaQuery.of(context).size.height * 0.08,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: FittedBox(
                                                fit: BoxFit.fill,
                                                child: SizedBox(
                                                  width: controller!.value.size.width,
                                                  height: controller.value.size.height,
                                                  child: VideoPlayer(controller),
                                                ),
                                              ),
                                            ),
                                            Gap(3),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.35,
                                              child: Text("Video : ${(HiveRepo.instance.user!=null) ? unwatchedVideoModel.title : ""}",
                                                maxLines: 1,
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
                                              child: Text("Points Earned : ${userVideoPoint.toString()}",
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
                                              child: Text("${(HiveRepo.instance.user!=null) ? unwatchedVideoModel.totalViews : ""} views",
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
                                              child: Text(userVideoStartDateTime,
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
                          if(HiveRepo.instance.user == null)Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Sign In now to get your rewards..!",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Gap(10),
                              GestureDetector(
                                onTap: () => context.pushRoute(SignInRoute()),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      "Sign In",
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  super.dispose();
                                  context.pushRoute(DashboardRoute(bottomIndex: 0));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.37,
                                  height: MediaQuery.of(context).size.height * 0.045,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white54,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.home_filled, color: Colors.white54,),
                                        Gap(10),
                                        Text("Go To Home", style: GoogleFonts.poppins(color: Colors.white54),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if(HiveRepo.instance.user != null && unwatchedVideoModel.videoLink != null)GestureDetector(
                                onTap: () async {
                                  String url = unwatchedVideoModel.videoLink.toString();
                                  if (await canLaunch(url)) {
                                  await launch(url);
                                  } else {
                                  throw 'Could not ``````launch`````` $url';
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  height: MediaQuery.of(context).size.height * 0.045,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.amber,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.link, color: Colors.amber,),
                                        Gap(10),
                                        Text("Register Interest", style: GoogleFonts.poppins(color: Colors.amber),)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }


  void _showVideoPopup(BuildContext context, int index) {
    final videoUrl =
        "https://wawapp.globify.in/storage/app/public/${allWatchedVideosListShowing[index].video!.video.toString()}";

    _controllersWatchedVideos = VideoPlayerController.network(videoUrl);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            // Initialize the video controller
            if (!_controllersWatchedVideos!.value.isInitialized) {
              _controllersWatchedVideos!.initialize().then((_) {
                setStateDialog(() {
                  _controllersWatchedVideos!.play();
                });
                _controllersWatchedVideos!.addListener(() {
                  if (_controllersWatchedVideos!.value.position ==
                      _controllersWatchedVideos!.value.duration) {
                    _controllersWatchedVideos!.seekTo(Duration.zero);
                    _controllersWatchedVideos!.pause();
                    Navigator.of(context).pop();
                    context.pushRoute(DashboardRoute(bottomIndex: 0)); // Navigate
                  }
                });
              }).catchError((error) {
                print("Error initializing video controller: $error");
              });
            }

            return WillPopScope(
              onWillPop: () async {
                // Handle back navigation
                _controllersWatchedVideos!.seekTo(Duration.zero);
                _controllersWatchedVideos!.pause();
                _controllersWatchedVideos!.dispose();
                Navigator.of(context).pop();
                return Future.value(false); // Prevent default pop behavior
              },
              child: Dialog(
                backgroundColor: Colors.black,
                insetPadding: EdgeInsets.all(0),
                child: Container(
                  color: Colors.black,
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.fill,
                        child: (_controllersWatchedVideos!.value.isInitialized)
                            ? SizedBox(
                          width: MediaQuery.of(context).size.width * 1,
                          height: _controllersWatchedVideos!.value.size.height,
                          child: VideoPlayer(_controllersWatchedVideos!),
                        )
                            : const SizedBox(
                          height: 50,
                          width: 50,
                          child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white54,
                              )),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          _controllersWatchedVideos!.seekTo(Duration.zero);
                          _controllersWatchedVideos!.pause();
                          _controllersWatchedVideos!.dispose();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.045,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white54,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.home_filled,
                                  color: Colors.white54,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Go To Home",
                                  style: GoogleFonts.poppins(color: Colors.white54),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
