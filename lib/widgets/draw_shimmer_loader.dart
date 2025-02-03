import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DrawShimmerLoader extends StatelessWidget {
  const DrawShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  child: shimmerContainer(width: 150, height: 20),
                ),
                SizedBox(height: 15),
                shimmerContainer(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: shimmerContainer(width: 200, height: 25),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[850],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: shimmerCircle(40),
                      title: shimmerContainer(width: 150, height: 20),
                      subtitle: shimmerContainer(width: 100, height: 15),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: shimmerContainer(width: double.infinity, height: 180),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget shimmerContainer({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget shimmerCircle(double size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
