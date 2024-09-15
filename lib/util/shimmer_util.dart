import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

ListView shimmerList(double screenWidth) {
  return ListView.builder(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemCount: 15,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            // margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02), // Responsive margin
            width: screenWidth * 0.4, // Responsive width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(
                    height:
                    screenWidth * 0.02), // Responsive spacing
                Container(
                  color: Colors.grey[300],
                  height: 30,
                  width: screenWidth * 0.3, // Responsive width
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget buildShimmerList(BuildContext context, double defaultWidth) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: 10,
    itemBuilder: (context, index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          width: defaultWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                color: Colors.grey[300],
                height: 16,
                width: defaultWidth * 0.8,
              ),
            ],
          ),
        ),
      );
    },
  );
}