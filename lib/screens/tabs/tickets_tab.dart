import 'dart:ui';
import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:waw/theme/colors.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import '../../routes/app_router.gr.dart';
import '../../widgets/profile_shimmer_view.dart';
import '../../widgets/ticket_widget.dart';
import 'dart:io';
import 'package:flutter/services.dart';


class TicketsTab extends StatefulWidget {
  const TicketsTab({super.key});

  @override
  State<TicketsTab> createState() => _TicketsTabState();
}

class _TicketsTabState extends State<TicketsTab> {

  List<GlobalKey> _globalKeys = List.generate(10, (index) => GlobalKey());  // Generate a list of keys


  // Method to capture the widget as an image and save it
  Future<void> _captureAndSaveImage(BuildContext context, GlobalKey key) async {
    try {
      await Permission.storage.request();
      if (await Permission.manageExternalStorage.isGranted) {
        // Permission granted, proceed with saving the image
      } else {
        await Permission.manageExternalStorage.request();
      }

      if (await Permission.manageExternalStorage.isGranted){
        RenderRepaintBoundary boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary;
        var image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
        Uint8List uint8List = byteData!.buffer.asUint8List();

        final directory = await getExternalStorageDirectory();
        final path = directory?.path;
        final fileName = "${DateTime.now().millisecondsSinceEpoch}.png";
        final file = File('$path/$fileName');

        await file.writeAsBytes(uint8List);

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
        padding: EdgeInsets.all(10.0),
        child: (2/2 == 0)?ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.8,
                  ),
                ),
                child: Column(
                  children: [
                    Gap(10),
                    RepaintBoundary(
                        key: _globalKeys[index],
                        child: TicketWidget()
                    ),
                    Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () => _captureAndSaveImage(context, _globalKeys[index]),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
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
                              child: Text("Download Ticket Image", style: GoogleFonts.poppins(color: Colors.white24, fontSize: 12),),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.pushRoute(DashboardRoute(bottomIndex: 0)),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
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
                              child: Text("Share on Social Media", style: GoogleFonts.poppins(color: Colors.white24, fontSize: 12),),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        ): Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset("assets/images/noticketdataimage.png" , width: MediaQuery.of(context).size.width * 0.6,)),
            Text("No tickets available", style: GoogleFonts.poppins(color: Colors.white24, fontSize: 16),),
          ],
        )
      ),
    );
  }
}
