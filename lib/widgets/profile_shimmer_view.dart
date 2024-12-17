import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProfileListView extends StatelessWidget {
  const ShimmerProfileListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[600]!, // Base color for the shimmer effect
      highlightColor: Colors.grey[500]!, // Highlight color for the shimmer effect
      child: Container(
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
                        // Shimmer effect for image
                        Shimmer.fromColors(
                          baseColor: Colors.grey[600]!,
                          highlightColor: Colors.grey[500]!,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.height * 0.03,
                            color: Colors.grey[300],
                          ),
                        ),
                        Gap(5),
                        // Shimmer effect for text (WAW)
                        Shimmer.fromColors(
                          baseColor: Colors.grey[600]!,
                          highlightColor: Colors.grey[500]!,
                          child: Container(
                            width: 50,
                            height: 10,
                            color: Colors.grey[300],
                          ),
                        ),
                        Gap(15),
                        // Shimmer effect for CircleAvatar (User image)
                        Shimmer.fromColors(
                          baseColor: Colors.grey[600]!,
                          highlightColor: Colors.grey[500]!,
                          child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.05,
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                        Gap(3),
                        // Shimmer effect for username
                        Shimmer.fromColors(
                          baseColor: Colors.grey[600]!,
                          highlightColor: Colors.grey[500]!,
                          child: Container(
                            width: 90,
                            height: 10,
                            color: Colors.grey[300],
                          ),
                        ),
                        Gap(3),
                        // Shimmer effect for location
                        Shimmer.fromColors(
                          baseColor: Colors.grey[600]!,
                          highlightColor: Colors.grey[500]!,
                          child: Container(
                            width: 110,
                            height: 10,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 7,
                    child: Column(
                      children: [
                        // Shimmer effect for video thumbnail
                        Shimmer.fromColors(
                          baseColor: Colors.grey[600]!,
                          highlightColor: Colors.grey[500]!,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.height * 0.08,
                            color: Colors.grey[300],
                          ),
                        ),
                        Gap(3),
                        // Shimmer effect for video title
                        Shimmer.fromColors(
                          baseColor: Colors.grey[600]!,
                          highlightColor: Colors.grey[500]!,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: 10,
                            color: Colors.grey[300],
                          ),
                        ),
                        Gap(3),
                        // Shimmer effect for points earned
                        Shimmer.fromColors(
                          baseColor: Colors.grey[600]!,
                          highlightColor: Colors.grey[500]!,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: 10,
                            color: Colors.grey[300],
                          ),
                        ),
                        Gap(3),
                        // Shimmer effect for views
                        Shimmer.fromColors(
                          baseColor: Colors.grey[600]!,
                          highlightColor: Colors.grey[500]!,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: 10,
                            color: Colors.grey[300],
                          ),
                        ),
                        Gap(5),
                        // Shimmer effect for "WATCHED ON"
                        Shimmer.fromColors(
                          baseColor: Colors.grey[600]!,
                          highlightColor: Colors.grey[500]!,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: 10,
                            color: Colors.grey[300],
                          ),
                        ),
                        Gap(3),
                        // Shimmer effect for date and time
                        Shimmer.fromColors(
                          baseColor: Colors.grey[600]!,
                          highlightColor: Colors.grey[500]!,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: 10,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Gap extends StatelessWidget {
  final double size;
  const Gap(this.size);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: size);
  }
}
