import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import '../../models/season/season_list_model.dart';
import '../../providers/season_provider.dart';
import '../../routes/app_router.gr.dart';
import '../../theme/colors.dart';
import '../../widgets/profile_shimmer_view.dart';


class DrawTab extends ConsumerStatefulWidget {
  const DrawTab({super.key});

  @override
  ConsumerState<DrawTab> createState() => _DrawTabState();
}

class _DrawTabState extends ConsumerState<DrawTab> {

  late YoutubePlayerController _controller;
  late List<YoutubePlayerController> _controllers = [];
  bool _isControlsVisible = true;
  String id = "qVuSgK86qFw";

  fetchData() async {
    setState(() {
      loading = false;
    });

    seasonList.clear();
    await ref.read(seasonListProvider).getAllSeason();
    final seasonProvider = ref.watch(seasonListProvider);
    seasonList = seasonProvider.allSeasonListState;

    if (seasonList.isNotEmpty) {
      initializeVideoController();
    } else {
      // Handle empty season list (optional)
      print("No seasons found!");
    }

    id =  await fetchCurrentLiveStreamId();
    setState(() {
      _controller = YoutubePlayerController(
        initialVideoId: id,
        flags: const YoutubePlayerFlags(
            mute: false,
            autoPlay: true,
            disableDragSeek: false,
            showLiveFullscreenButton: false,
            controlsVisibleAtStart: true,
            hideControls: true
        ),
      );
    });

    setState(() {
      loading = true;
    });
  }

  initializeVideoController() {
    _controllers.clear();

    // Loop through all seasons and configure the player for past live streams
    print("season list length ${seasonList.length}");

    for (var season in seasonList) {
      String? videoId;
      // Check if the URL is a live stream
      if (season.videoLink!.contains("/live/")) {
        // Manually extract the video ID from live stream URL
        RegExp regExp = RegExp(r"youtube\.com\/live\/([a-zA-Z0-9_-]+)");
        var match = regExp.firstMatch(season.videoLink.toString());
        if (match != null) {
          videoId = match.group(1);  // Extracted video ID
        }
      } else {
        // For regular video URLs, use convertUrlToId
        videoId = YoutubePlayer.convertUrlToId(season.videoLink.toString());
      }

      print("${season.videoLink}");
      print("videoId: $videoId");

      if (videoId != null) {
        _controllers.add(YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            isLive: true,
            forceHD: true,
            showLiveFullscreenButton: false
          ),
        ));
      }
      setState(() {

      });
    }
  }


  Future<String> fetchCurrentLiveStreamId() async {
    String apiKey = 'AIzaSyBIo2-dUdj6fQHSsIDJhXPgSxNq38KCXb0';
    String channelId = 'UCOdwZgADx2CnjRwPnMJRYsg';

    String url = 'https://www.googleapis.com/youtube/v3/search'
        '?part=snippet'
        '&channelId=$channelId'
        '&eventType=live'
        '&type=video'
        '&key=$apiKey';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      String videoId = data['items'][0]['id']['videoId'];
      return videoId;
    } else {
      throw Exception('Failed to fetch live stream: ${response.statusCode}');
    }
  }

  List<SeasonList> seasonList = [];
  bool loading = false;


  @override
  void initState() {
    super.initState();
      fetchData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: screenBackgroundColor,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => context.pushRoute(DashboardRoute(bottomIndex: 0)),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 25),
        ),
        title: Text(
          "The Draw",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.33,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "🔴  Live Streaming",
                        style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Gap(15),
                    (id != "qVuSgK86qFw")
                        ? Stack(
                      children: [
                        YoutubePlayer(
                          controller: _controller,
                          showVideoProgressIndicator: true,
                          onReady: () {
                            print('Player is ready.');
                          },
                        ),
                        if (_isControlsVisible)
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.1,
                            left: 0,
                            right: 0,
                            child: Container(
                              width: 10,
                              height: 50,
                              color: Colors.transparent,
                              child: IconButton(
                                icon: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.play_arrow
                                      : Icons.pause,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_controller.value.isPlaying) {
                                      _controller.pause();
                                    } else {
                                      _controller.play();
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                      ],
                    )
                        : Image.asset(
                      "assets/images/livenodataimage.png",
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.25,
                      fit: BoxFit.fitHeight,
                    ),
                  ],
                ),
              ),
              Text(
                "Previous Draws",
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
              ),
              Gap(10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: seasonList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (seasonList.isNotEmpty) {
                    seasonList[0].isExpanded = true;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[850],
                    ),
                    child: ExpansionPanelList(
                      elevation: 1,
                      expandIconColor: Colors.grey,
                      expandedHeaderPadding: EdgeInsets.zero,
                      expansionCallback: (int panelIndex, bool isExpanded) {
                        setState(() {
                          seasonList[index].isExpanded = !seasonList[index].isExpanded;
                        });
                      },
                      children: [
                        ExpansionPanel(
                          backgroundColor: Colors.grey[850],
                          headerBuilder: (BuildContext context, bool isExpanded) {
                            return ListTile(
                              tileColor: Colors.transparent,
                              title: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: seasonList[index].name.toString(),
                                      style: GoogleFonts.poppins(
                                        color: Colors.yellow,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "  (${seasonList[index].startDate.toString()} - ${seasonList[index].endDate.toString()})",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Column(
                                children: [
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/winnerfirsticon.png",
                                        height: 30,
                                        width: 30,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        seasonList[index].winner1!.name.toString(),
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/winnersecond.png",
                                            color: Colors.white,
                                            height: 20,
                                            width: 20,
                                          ),
                                          SizedBox(width: 10),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.27,
                                            child: Text(
                                              seasonList[index].winner2!.name.toString(),
                                              style: GoogleFonts.poppins(
                                                color: Colors.white70,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/winnerthirdicon.png",
                                            color: Colors.brown,
                                            height: 20,
                                            width: 20,
                                          ),
                                          SizedBox(width: 10),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.27,
                                            child: Text(
                                              seasonList[index].winner3!.name.toString(),
                                              style: GoogleFonts.poppins(
                                                color: Colors.white70,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          body: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: YoutubePlayer(
                              controller: _controllers[index],
                              showVideoProgressIndicator: true,
                            ),
                          ),
                          isExpanded: seasonList[index].isExpanded,
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

}