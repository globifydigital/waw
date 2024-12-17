import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import '../../routes/app_router.gr.dart';
import '../../theme/colors.dart';
import '../../widgets/profile_shimmer_view.dart';


class DrawTab extends StatefulWidget {
  const DrawTab({super.key});

  @override
  State<DrawTab> createState() => _DrawTabState();
}

class _DrawTabState extends State<DrawTab> {

  late YoutubePlayerController _controller;
  bool _isControlsVisible = true;
  String id = "qVuSgK86qFw";


  final List<String> videoUrls = [
    'https://www.youtube.com/watch?v=3UeaPkLBdmc',
    'https://www.youtube.com/watch?v=xzkZWjwt5vw',
  ];


  fetchData () async{
    id =  await fetchCurrentLiveStreamId();
    setState(() {
      _controller = YoutubePlayerController(
        initialVideoId: id,
        flags: YoutubePlayerFlags(
            mute: false,
            autoPlay: true,
            disableDragSeek: false,
            showLiveFullscreenButton: false,
            controlsVisibleAtStart: true,
            hideControls: true
        ),
      );
    });
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

  List<Item> generateItems(int count) {
    return List<Item>.generate(count, (int index) {
      return Item(
        header: 'Panel $index',
        body: 'This is the content of panel $index',
      );
    });
  }


  List<Item> _data = [];



  @override
  void initState() {
    super.initState();
    _data = generateItems(20);
    fetchData();
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
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white,size: 25,)),
        title: Text("The Draw", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),),
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
                    (id != "qVuSgK86qFw")?Stack(
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
                    ):Image.asset("assets/images/livenodataimage.png", width: double.infinity, height: MediaQuery.of(context).size.height * 0.25, fit: BoxFit.fitHeight,),
                  ],
                ),
              ),
              Text("Previous Draws", style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),),
              Gap(10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _data.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (_data.isNotEmpty) {
                    _data[0].isExpanded = true;
                  }
                  String videoId = YoutubePlayer.convertUrlToId(videoUrls[0])!;
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
                          _data[index].isExpanded = !_data[index].isExpanded;
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
                                      text: "Season Name ",
                                      style: GoogleFonts.poppins(
                                        color: Colors.yellow,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "(12 : 12 : 2024 - 12 : 12 : 2024)",
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
                                        "Username Demo",
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
                                              "Username123",
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
                                              "Username demomoomomo",
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
                          ),
                          isExpanded: _data[index].isExpanded,
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

class Item {
  Item({
    required this.header,
    required this.body,
    this.isExpanded = false,
  });

  String header;
  String body;
  bool isExpanded;
}