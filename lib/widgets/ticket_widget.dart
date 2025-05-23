import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/user/individual_user_model.dart';

class TicketWidget extends StatelessWidget {
  final UserModel userModel;
  TicketWidget({Key? key, required this.userModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = userModel.data;
    return CustomPaint(
      painter: TicketPainter(),
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                height: double.infinity,
                width: MediaQuery.of(context).size.width * 0.15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: QrImageView(
                      data: user!.coupenNo.toString(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                "assets/images/ic_launcher.png",
                                width: MediaQuery.of(context).size.width * 0.09,
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
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              Text(
                                'COUPON NO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                  user!.coupenNo ?? "XXXXXXXXXXXXXXX",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.05,
                            backgroundImage: NetworkImage(
                              "https://wawapp.globify.in/storage/app/public/${user.image.toString()}",
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.name.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  user.address.toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Watch Hour',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                user.totalWatchTime.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${user.userPoints.toString()} POINTS',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TicketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[850]!
      ..style = PaintingStyle.fill;

    Path path = Path();

    // Draw the rounded corners of the ticket (all four corners)
    path.moveTo(16, 0);  // Move to top-left corner
    path.lineTo(size.width - 16, 0);  // Top-right corner line
    path.quadraticBezierTo(size.width, 0, size.width, 16);  // top-right curve
    path.lineTo(size.width, size.height - 16);  // Bottom-right corner line
    path.quadraticBezierTo(size.width, size.height, size.width - 16, size.height);  // bottom-right curve
    path.lineTo(16, size.height);  // Bottom-left corner line
    path.quadraticBezierTo(0, size.height, 0, size.height - 16);  // bottom-left curve
    path.lineTo(0, 16);  // Top-left corner line
    path.quadraticBezierTo(0, 0, 16, 0);  // top-left curve

    // Draw the cutouts at the sides (left and right)
    const double cutoutRadius = 8.0;

    // Left side cutout (semi-circular)
    path.moveTo(0, size.height / 3 - cutoutRadius);  // Move to the position of the left cutout
    path.arcToPoint(Offset(0, size.height / 3 + cutoutRadius),
        radius: Radius.circular(cutoutRadius), clockwise: false);

    // Right side cutout (semi-circular)
    path.moveTo(size.width, 2 * size.height / 3 - cutoutRadius);  // Move to the position of the right cutout
    path.arcToPoint(Offset(size.width, 2 * size.height / 3 + cutoutRadius),
        radius: Radius.circular(cutoutRadius), clockwise: false);

    // Fill the path with the paint color
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
