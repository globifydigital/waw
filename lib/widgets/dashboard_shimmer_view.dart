import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';  // Add gap package if needed

class ShimmerDashboardListView extends StatelessWidget {
  const ShimmerDashboardListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[600]!,
          highlightColor: Colors.grey[500]!,
          child: Container(
            height: 20,
            width: MediaQuery.of(context).size.width * 0.7,
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.grey,
                width: 0.3,
              ),
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[600]!,
          highlightColor: Colors.grey[500]!,
          child: Container(
            height: 15,
            width: MediaQuery.of(context).size.width * 0.5,
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.grey,
                width: 0.3,
              ),
            ),
          ),
        ),
        Gap(25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[600]!,
              highlightColor: Colors.grey[500]!,
              child: Container(
                height: 10,
                width: MediaQuery.of(context).size.width * 0.4,
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.3,
                  ),
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[600]!,
              highlightColor: Colors.grey[500]!,
              child: Container(
                height: 10,
                width: MediaQuery.of(context).size.width * 0.3,
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.3,
                  ),
                ),
              ),
            ),
          ],
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[600]!,
          highlightColor: Colors.grey[500]!,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.grey,
                width: 0.3,
              ),
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[600]!,
          highlightColor: Colors.grey[500]!,
          child: Container(
            height: 15,
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.grey,
                width: 0.3,
              ),
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[600]!,
          highlightColor: Colors.grey[500]!,
          child: Container(
            height: 70,
            width: 70,
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              shape: BoxShape.circle,  // Circle shape
              border: Border.all(
                color: Colors.grey,
                width: 0.3,
              ),
            ),
          ),
        ),
        Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[600]!,
              highlightColor: Colors.grey[500]!,
              child: Container(
                height: 10,
                width: MediaQuery.of(context).size.width * 0.4,
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.3,
                  ),
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[600]!,
              highlightColor: Colors.grey[500]!,
              child: Container(
                height: 10,
                width: MediaQuery.of(context).size.width * 0.3,
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.3,
                  ),
                ),
              ),
            ),
          ],
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[600]!,
          highlightColor: Colors.grey[500]!,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.grey,
                width: 0.3,
              ),
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[600]!,
          highlightColor: Colors.grey[500]!,
          child: Container(
            height: 15,
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.grey,
                width: 0.3,
              ),
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[600]!,
          highlightColor: Colors.grey[500]!,
          child: Container(
            height: 70,
            width: 70,
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              shape: BoxShape.circle,  // Circle shape
              border: Border.all(
                color: Colors.grey,
                width: 0.3,
              ),
            ),
          ),
        ),
        Gap(25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[600]!,
              highlightColor: Colors.grey[500]!,
              child: Container(
                height: 20,
                width: MediaQuery.of(context).size.width * 0.6,
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.3,
                  ),
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[600]!,
              highlightColor: Colors.grey[500]!,
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width * 0.2,
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.3,
                  ),
                ),
              ),
            ),
          ]
        ),
        Gap(15),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5, // Adjust the number of shimmer placeholders
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[600]!,
              highlightColor: Colors.grey[500]!,
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
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
                      child: Container(
                        height: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.045,
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
