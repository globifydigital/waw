import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waw/routes/app_router.gr.dart';
import 'package:waw/theme/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


@RoutePage()
class RecentAdsScreen extends StatefulWidget {
  const RecentAdsScreen({super.key});

  @override
  State<RecentAdsScreen> createState() => _RecentAdsScreenState();
}

class _RecentAdsScreenState extends State<RecentAdsScreen> {

  final List<String> videoUrls = [
    'https://www.youtube.com/watch?v=3UeaPkLBdmc',
  ];

  final List<String> recentlyViewedVideoUrls = [
    'https://www.youtube.com/watch?v=xTpv9lc_qMw',
    'https://www.youtube.com/watch?v=Dr_8tvQjY9M',
    'https://www.youtube.com/watch?v=-nG5enxw100',
    'https://www.youtube.com/watch?v=xzkZWjwt5vw',
    'https://www.youtube.com/watch?v=xTpv9lc_qMw',
    'https://www.youtube.com/watch?v=Dr_8tvQjY9M',
    'https://www.youtube.com/watch?v=-nG5enxw100',
    'https://www.youtube.com/watch?v=xzkZWjwt5vw',
    'https://www.youtube.com/watch?v=xTpv9lc_qMw',
    'https://www.youtube.com/watch?v=Dr_8tvQjY9M',
    'https://www.youtube.com/watch?v=-nG5enxw100',
    'https://www.youtube.com/watch?v=xzkZWjwt5vw',
    'https://www.youtube.com/watch?v=xTpv9lc_qMw',
    'https://www.youtube.com/watch?v=Dr_8tvQjY9M',
    'https://www.youtube.com/watch?v=-nG5enxw100',
    'https://www.youtube.com/watch?v=xzkZWjwt5vw',
  ];

  @override
  Widget build(BuildContext context) {
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
        child: ListView.builder(
          shrinkWrap: true,
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
      ),
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
