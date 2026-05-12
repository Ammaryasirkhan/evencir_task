import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/widgets/app_text.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06070B),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w, 18.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText('Profile', size: 24, weight: FontWeight.w700),
              SizedBox(height: 24.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF151925), Color(0xFF11131D)],
                  ),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 70.w,
                      height: 70.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1D2233),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 38.sp,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            'Ammar Yasir',
                            size: 18,
                            weight: FontWeight.w700,
                          ),
                          SizedBox(height: 4),
                          AppText(
                            'ammaryasirniazi567@gmail.com',
                            size: 13,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFEC6B7A)),
                    foregroundColor: const Color(0xFFEC6B7A),
                    minimumSize: Size(double.infinity, 48.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        size: 18.sp,
                        color: const Color(0xFFEC6B7A),
                      ),
                      SizedBox(width: 8.w),
                      const AppText(
                        'Logout',
                        size: 14,
                        weight: FontWeight.w700,
                        color: Color(0xFFEC6B7A),
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
