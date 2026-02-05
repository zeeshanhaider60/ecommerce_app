import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: Container(color: Colors.white)),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 14.h,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          height: 14.h,
                          width: 100.w,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
