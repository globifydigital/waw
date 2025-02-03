import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:waw/rest/hive_repo.dart';
import 'package:waw/theme/colors.dart';

import '../../models/district/district_model.dart';
import '../../models/user/individual_user_model.dart';
import '../../models/videos/all_watched_videos_model.dart';
import '../../providers/district_provider.dart';
import '../../providers/user_login_provider.dart';
import '../../providers/video_provider.dart';
import '../../routes/app_router.gr.dart';
import '../../widgets/login_button.dart';
import '../../widgets/profile_shimmer_view.dart';
import '../../widgets/ticket_widget.dart';



@RoutePage()
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin{

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  UserModel? userModel;
  bool _loading = false;
  bool _showShimmerLoader = false;

  bool _showProfile = false;

  File? _image;

  GlobalKey globalKey = GlobalKey();

  final _formKey = GlobalKey<FormState>();
  var _name = TextEditingController();
  var _mobile = TextEditingController();
  var _mobileWhatsp = TextEditingController();
  var _email = TextEditingController();
  var _address = TextEditingController();

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


  String? _selectedDistrict;
  List<DistrictList> districtList = [];


  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    // Show dialog to choose between camera or gallery
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Update the image file
      });
    }
  }

  List<AllWatchedVideosList> allWatchedVideosListShowing = [];

  getData () async{
    setState(() {
      _showShimmerLoader = false;
    });
    allWatchedVideosListShowing.clear();
    await ref.read(videoListProvider).getAllWatchedVideos(HiveRepo.instance.user!.data!.mobNo.toString());
    final watchedVideoProvider = ref.watch(videoListProvider);
    allWatchedVideosListShowing = watchedVideoProvider.allWatchedVideosListState;
    setState(() {
      _showShimmerLoader = true;
    });
  }

  fetchDistrictData() async {

    districtList.clear();
    await ref.read(districtProvider).getAllDistricts();
    final districtListProvider = ref.watch(districtProvider);
    districtList = districtListProvider.allDistrictListState;
    setState(() {});

  }

  Future<void> _loadUserDetails() async {
    try {
      final userDetails = await ref.read(userDetailsProvider).getIndividualUser(HiveRepo.instance.user!.data!.mobNo.toString());

      setState(() {
        userModel = userDetails;
        _loading = true;
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error loading user details: $error');
      }
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDistrictData();
    if(HiveRepo.instance.user != null){
      getData();
    }
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    if(HiveRepo.instance.user != null){
      _loadUserDetails();
      _showProfile = true;
    }else{
      _showProfile = false;
    }
    print("${HiveRepo.instance.user}");
    Future.delayed(const Duration(milliseconds: 200), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () => context.pushRoute(DashboardRoute(bottomIndex: 3)),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white,size: 25,)),
        title: Text("Profile", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: PopupMenuButton<String>(
              color: Colors.transparent,
              elevation: 0,
              onSelected: (value) {
                if (value == 'edit') {
                  context.pushRoute(ProfileEditRoute(userModel: userModel));
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.045,
                      decoration: BoxDecoration(
                        color: screenBackgroundColor, // Background color
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                        border: Border.all(
                          color: Colors.white54, // Border color
                          width: 1, // Border width
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit, color: Colors.white, size: 18,), // Icon color
                            SizedBox(width: 10),
                            Text(
                              'Edit',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14, // Font size
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // You can add more items like 'Delete', 'Settings', etc.
                ];
              },
              icon: Icon(Icons.more_vert, color: Colors.white), // Icon style
            ),

          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: (_showProfile)?SingleChildScrollView(
          child: (_loading)?Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.1,
                  backgroundImage: NetworkImage(
                    "https://wawapp.globify.in/storage/app/public/${userModel!.data!.image.toString()}",
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
              Gap(15),
              Text(userModel!.data!.name.toString(), style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
              Gap(2),
              Text(userModel!.data!.mobNo.toString(), style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),),
              Gap(25),
              if(userModel!.data!.userPoints! > (userModel!.data!.userTargetPoints !=null ? userModel!.data!.userTargetPoints! : 300))Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Congratulations!\nYou have reached the target point.\nHere is your ticket to the prize draw.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 11,
                    ),
                  ),
                  SizedBox(width: 10),
                  Image.asset("assets/images/tickiconimage.png", width: 25,)
                ],
              ),
              Gap(10),
              (userModel!.data!.userPoints! < (userModel!.data!.userTargetPoints !=null ? userModel!.data!.userTargetPoints! : 300))?Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TicketWidget(userModel: userModel!),
                        Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.height * 0.045,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white54, // Original border color
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Download Ticket Image",
                                    style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.height * 0.045,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white54, // Original border color
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Share on Social Media",
                                    style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white54,
                        width: 1,
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.28,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1, width: double.infinity,
                            child: Image.asset("assets/images/lockimage.png", color: Colors.white,)),
                        Gap(10),
                        Text(
                          "Earn ${(userModel!.data!.userTargetPoints !=null ? userModel!.data!.userTargetPoints! : 300)} points to unlock your ticket.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.amber,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ):Column(
                children: [
                  RepaintBoundary(
                      key: globalKey,
                      child: TicketWidget(userModel: userModel!)),
                  Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => _captureAndSaveImage(context, globalKey, 'download'),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.045,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white54,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Download Ticket Image",
                              style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _captureAndSaveImage(context, globalKey, 'share'),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.045,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white54, // Original border color
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Share on Social Media",
                              style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Gap(20),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Points Earned : ${userModel!.data!.userPoints}", style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),)),
              Gap(8),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: allWatchedVideosListShowing.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index){
                    return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: (_showShimmerLoader)?Container(
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
                                            backgroundImage: NetworkImage("https://wawapp.globify.in/storage/app/public/${HiveRepo.instance.user!.data!.image}"),
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
                                            maxLines: 3,
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
                                            width: MediaQuery.of(context).size.width * 0.45,
                                            height: MediaQuery.of(context).size.height * 0.08,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: FittedBox(
                                                fit: BoxFit.fill,
                                                child: SizedBox(
                                                  child: Image.network(
                                                    "https://wawapp.globify.in/storage/app/public/${allWatchedVideosListShowing[index].video!.thumbnail.toString()}",
                                                  ),
                                                )
                                            ),
                                          ),
                                          Gap(3),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.45,
                                            child: Text("Video : ${allWatchedVideosListShowing[index].video!.title}",
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
                                            width: MediaQuery.of(context).size.width * 0.45,
                                            child: Text("Points Earned : ${allWatchedVideosListShowing[index].videoPoints}",
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
                                            width: MediaQuery.of(context).size.width * 0.45,
                                            child: Text("${allWatchedVideosListShowing[index].video!.totalViews} views",
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
                                            width: MediaQuery.of(context).size.width * 0.45,
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
                                            width: MediaQuery.of(context).size.width * 0.45,
                                            child: Text(allWatchedVideosListShowing[index].videoStartTime.toString(),
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
                        ) : const ShimmerProfileListView()
                    );
                  }
              )
            ],
          ):SizedBox(
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1,
              child: const Center(child: CircularProgressIndicator(color: Colors.white54,))),
        ):Align(
          alignment: Alignment.bottomCenter,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Colors.white54,
                    Colors.brown,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white54,
                  width: 0.5,
                ),
              ),

              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Gap(20),
                        Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Gap(20),
                        GestureDetector(
                          onTap: () async {
                            await _pickImage();
                          },
                          child: CircleAvatar(
                            radius: 50, // Control the size of the circle
                            backgroundColor: Colors.grey[300], // Background color of the circle
                            child: _image == null
                                ? Icon(Icons.add_a_photo, size: 30, color: Colors.grey) // Placeholder icon
                                : ClipOval(
                              child: Image.file(
                                _image!,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Gap(25),
                        TextFormField(
                          controller: _name,
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            hintText: 'Name',
                            hintStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w300),
                            prefixIcon: Icon(Iconsax.user, color: Colors.yellow,),
                            contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                            prefixIconConstraints: BoxConstraints(minWidth: 50),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name cannot be empty';
                            }
                            return null;
                          },
                          onChanged: (v){
                            _name.text = v.toString();
                          },
                        ),
                        Gap(15),
                        TextFormField(
                          controller: _mobile,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                          maxLength: 10,
                          decoration: InputDecoration(
                            hintText: 'Mobile Number',
                            hintStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w300),
                            prefixIcon: Icon(Iconsax.mobile, color: Colors.yellow,),
                            contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                            prefixIconConstraints: BoxConstraints(minWidth: 50),
                            counterText: "",
                            filled: true,
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field cannot be empty';
                            }
                            return null;
                          },
                          onChanged: (v){
                            _mobile.text = v.toString();
                          },
                        ),
                        Gap(15),
                        TextFormField(
                          controller: _mobileWhatsp,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                          maxLength: 10,
                          decoration: InputDecoration(
                            hintText: 'Mobile Number (Whats Up)',
                            hintStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w300),
                            prefixIcon: Image.asset("assets/images/whatsapplogo.png", color: Colors.yellow,),
                            contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                            prefixIconConstraints: BoxConstraints(minWidth: 50),
                            counterText: "",
                            filled: true,
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field cannot be empty';
                            }
                            return null;
                          },
                          onChanged: (v){
                            _mobileWhatsp.text = v.toString();
                          },
                        ),
                        Gap(15),
                        TextFormField(
                          controller: _email,
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w300),
                            prefixIcon: Icon(Icons.mail_outline_sharp, color: Colors.yellow,),
                            contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                            prefixIconConstraints: BoxConstraints(minWidth: 50),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email cannot be empty';
                            }
                            return null;
                          },
                          onChanged: (v) {
                            _email.text = v.toString();
                          },
                        ),
                        Gap(15),
                        TextFormField(
                          controller: _address,
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            hintText: 'Address',
                            hintStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w300),
                            prefixIcon: Icon(Icons.location_city, color: Colors.yellow,),
                            contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                            prefixIconConstraints: BoxConstraints(minWidth: 50),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email cannot be empty';
                            }
                            return null;
                          },
                          onChanged: (v) {
                            _address.text = v.toString();
                          },
                        ),
                        Gap(15),
                        DropdownButtonFormField<String>(
                          value: _selectedDistrict,
                          dropdownColor: Colors.white70,
                          hint: Text("Select District", style: GoogleFonts.poppins(
                            color: Colors.white54,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),),
                          menuMaxHeight: 500,
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Colors.yellow,
                            ),
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.location_on, color: Colors.yellow),
                            contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                            prefixIconConstraints: BoxConstraints(minWidth: 50),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white54,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          items: districtList.map((district) {
                            return DropdownMenuItem<String>(
                              value: district.id.toString(),
                              child: Text(
                                district.name.toString(),
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                          selectedItemBuilder: (BuildContext context) {
                            return districtList.map((district) {
                              return Text(
                                district.name.toString(),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }).toList();
                          },
                          onChanged: (value) {
                            setState(() {
                              _selectedDistrict = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'District cannot be empty';
                            }
                            return null;
                          },
                        ),
                        Gap(40),
                        LoginButton(
                          showActions: false,
                          title: "Sign Up",
                          onPressed: (){
                            _login();
                          },
                        ),
                        Gap(20),
                        Text.rich(
                          TextSpan(
                            text: 'Already LogIn? ',
                            style:  GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                            children: [
                              TextSpan(
                                text: ' Sign In',
                                style: GoogleFonts.poppins(
                                  color: Colors.yellow,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.yellow,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.pushRoute(const SignInRoute());
                                  },
                              ),
                            ],
                          ),
                        ),
                        Gap(40),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //         "Not a member ? ",
                        //         style: TextStyle(
                        //           fontSize: 16,
                        //           color: Colors.white,
                        //         )
                        //     ),
                        //     GestureDetector(
                        //       onTap: (){
                        //         context.pushRoute(SignUpRoute());
                        //       },
                        //       child: Text(
                        //           "Register now",
                        //           style: TextStyle(
                        //             fontSize: 16,
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.bold,
                        //           )
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    // setState(() {
    //   submitting = true;
    // });

    try {
      var userDetails = await ref.read(userDetailsProvider).registerUser(
        name: _name.text,
        mob_no: _mobile.text,
        whatsapp_no: _mobileWhatsp.text,
        email: _email.text,
        address: _address.text,
        location: _selectedDistrict.toString(),
        file: _image!,
      );
      print(userDetails.data!.name);
      print(userDetails.data!.mobNo);
      print(userDetails);
      if(userDetails.data != null){
        HiveRepo.instance.user = userDetails;
        context.pushRoute(const ProfileRoute());
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please check your username or password'),
            duration: Duration(milliseconds: 600),),
        );
      }

      // ignore: use_build_context_synchronously
      // Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
    }
    // setState(() {
    //   submitting = false;
    // });
  }
}
