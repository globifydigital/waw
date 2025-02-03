import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:waw/routes/app_router.gr.dart';
import 'package:waw/theme/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/videos/all_watched_videos_model.dart';
import '../../providers/video_provider.dart';
import '../../rest/hive_repo.dart';
import '../../widgets/profile_shimmer_view.dart';


@RoutePage()
  class RecentAdsScreen extends ConsumerStatefulWidget {
  const RecentAdsScreen({super.key});

  @override
  ConsumerState<RecentAdsScreen> createState() => _RecentAdsScreenState();
}

class _RecentAdsScreenState extends ConsumerState<RecentAdsScreen> {


  List<AllWatchedVideosList> allWatchedVideosListShowing = [];
  VideoPlayerController? _controllersWatchedVideos;

  bool isLoading = true;

  getData() async {
    setState(() {
      isLoading = true;
    });
    allWatchedVideosListShowing.clear();
    await ref.read(videoListProvider).getAllWatchedVideos(HiveRepo.instance.user!.data!.mobNo.toString());
    final watchedVideoProvider = ref.watch(videoListProvider);
    allWatchedVideosListShowing = watchedVideoProvider.allWatchedVideosListState;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    if (_controllersWatchedVideos != null) {
      if (_controllersWatchedVideos!.value.isInitialized) {
        _controllersWatchedVideos!.dispose();
      }
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final videoProvider = ref.watch(videoListProvider);
    final allWatchedVideosListShowing = videoProvider.allWatchedVideosListState;
    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () => context.pushRoute(DashboardRoute(bottomIndex: 0)),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white,size: 25,)),
        title: Text("Recent Ads", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: (isLoading == false)?ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: allWatchedVideosListShowing.length,
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
                        child: FittedBox(
                            fit: BoxFit.fill,
                            child: SizedBox(
                              child: Image.network(
                                "https://wawapp.globify.in/storage/app/public/${allWatchedVideosListShowing[index].video!.thumbnail.toString()}",
                              ),
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ):Center(child: CircularProgressIndicator(color: Colors.white54,)),
      ),
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
