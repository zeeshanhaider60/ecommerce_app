import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorWidgetCustom extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorWidgetCustom({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.w, color: Colors.red[300]),
            SizedBox(height: 16.h),
            Text(
              'Oops!',
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
