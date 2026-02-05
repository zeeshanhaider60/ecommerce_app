import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../services/storage_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = context.read<StorageService>();
    final userId = storageService.getUserId() ?? 2;

    return FutureBuilder<UserModel>(
      future: UserRepository().getUser(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('User not found'));
        }

        final user = snapshot.data!;
        return SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              CircleAvatar(
                radius: 60.r,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.person,
                  size: 60.w,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                user.name.fullName,
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Text(
                '@${user.username}',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 32.h),
              _buildInfoCard(
                context,
                title: 'Contact Information',
                items: [
                  _InfoItem(Icons.email_outlined, 'Email', user.email),
                  _InfoItem(Icons.phone_outlined, 'Phone', user.phone),
                ],
              ),
              SizedBox(height: 16.h),
              _buildInfoCard(
                context,
                title: 'Address',
                items: [
                  _InfoItem(
                    Icons.location_on_outlined,
                    'Street',
                    '${user.address.number} ${user.address.street}',
                  ),
                  _InfoItem(Icons.location_city, 'City', user.address.city),
                  _InfoItem(
                    Icons.markunread_mailbox,
                    'Zipcode',
                    user.address.zipcode,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required List<_InfoItem> items,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16.h),
            ...items.map((item) => _buildInfoRow(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(_InfoItem item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(item.icon, size: 20.w, color: Colors.grey),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
                Text(
                  item.value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;

  _InfoItem(this.icon, this.label, this.value);
}
