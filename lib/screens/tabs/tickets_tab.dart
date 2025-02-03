import 'dart:convert';
import 'dart:ui';
import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:waw/models/cards/card_achieved_model.dart';
import 'package:waw/providers/card_achieved_provider.dart';
import 'package:waw/rest/hive_repo.dart';
import 'package:waw/theme/colors.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import '../../routes/app_router.gr.dart';
import '../../widgets/all_ticket_widget.dart';
import '../../widgets/profile_shimmer_view.dart';
import 'dart:io';
import 'package:flutter/services.dart';


class TicketsTab extends ConsumerStatefulWidget {
  const TicketsTab({super.key});

  @override
  ConsumerState<TicketsTab> createState() => _TicketsTabState();
}

class _TicketsTabState extends ConsumerState<TicketsTab> {

  List<GlobalKey> _globalKeys = [];

  bool loading = false;

  List<CardAchievedList> cardsList = [];

  fetchData() async {
    setState(() {
      loading = true;
    });

    cardsList.clear();
    await ref.read(cardAchievedProvider).getAllTickets(HiveRepo.instance.user!.data!.mobNo.toString());
    final cardProvider = ref.watch(cardAchievedProvider);
    cardsList = cardProvider.allTicketListState;
    _globalKeys = List.generate(cardsList.isNotEmpty ? cardsList.length : 0, (index) => GlobalKey());
    setState(() {
      loading = false;
    });
  }


  // Method to capture the widget as an image and save it
  Future<void> _captureAndSaveImage(BuildContext context, GlobalKey key, String action) async {
    try {
      await Permission.storage.request();
      if (await Permission.manageExternalStorage.isGranted) {
        // Permission granted, proceed with saving the image
      } else {
        await Permission.manageExternalStorage.request();
      }

      if (await Permission.manageExternalStorage.isGranted) {
        RenderRepaintBoundary boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary;
        var image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
        Uint8List uint8List = byteData!.buffer.asUint8List();

        final directory = await getExternalStorageDirectory();
        final path = directory?.path;
        final fileName = "${DateTime.now().millisecondsSinceEpoch}.png";
        final file = File('$path/$fileName');

        await file.writeAsBytes(uint8List);

        if (action == 'download') {
          await GallerySaver.saveImage(file.path);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Ticket saved to gallery!',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
            ),
          );
        } else if (action == 'share') {
          XFile xFile = XFile(file.path);
          await Share.shareXFiles([xFile], text: 'Check out my ticket!');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Permission denied!',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
          ),
        );
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    if(HiveRepo.instance.user != null){
      fetchData();
    }
    super.initState();
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
        title: Text("Tickets", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
        child: (loading == false)?SizedBox(
          child: (cardsList.isNotEmpty)?ListView.builder(
            itemCount: cardsList.length,
            itemBuilder: (BuildContext context, int index){
              return Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white,
                      width: 0.2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Gap(10),
                      RepaintBoundary(
                          key: _globalKeys[index],
                          child: AllTicketWidget(cardAchievedList: cardsList[index])
                      ),
                      Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () => _captureAndSaveImage(context, _globalKeys[index], 'download'),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.035,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white54,
                                  width: 0.5,
                                ),
                              ),
                              child: Center(
                                child: Text("Download Ticket Image", style: GoogleFonts.poppins(color: Colors.black, fontSize: 12)),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _captureAndSaveImage(context, _globalKeys[index], 'share'),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.035,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white54,
                                  width: 0.5,
                                ),
                              ),
                              child: Center(
                                child: Text("Share on Social Media", style: GoogleFonts.poppins(color: Colors.black, fontSize: 12)),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              );
            }
          ):Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Image.asset("assets/images/noticketdataimage.png" , width: MediaQuery.of(context).size.width * 0.4,)),
              Text("No tickets available", style: GoogleFonts.poppins(color: Colors.white54, fontSize: 16),),
            ],
          )
        ):const Center(child: CircularProgressIndicator(color: Colors.white54,))
      ),
    );
  }
}
