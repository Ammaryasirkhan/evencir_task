import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/widgets/app_text.dart';

class PlanPage extends StatelessWidget {
  const PlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06070B),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 24.h),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 14.h),
              child: Row(
                children: const [
                  AppText('Training Calendar', size: 23, weight: FontWeight.w700),
                  Spacer(),
                  AppText('Save', size: 14, weight: FontWeight.w600, color: Colors.white70),
                ],
              ),
            ),
            Container(height: 2.h, color: const Color(0xFF3741FF)),
            const _WeekBlock(
              title: 'Week 2/8',
              dateRange: 'December 8-14',
              total: 'Total: 60min',
              showTopAccent: false,
              days: [
                _DayPlan(
                  dayLabel: 'Mon',
                  dayNumber: 8,
                  workout: _Workout(
                    tag: 'Arms Workout',
                    tagColor: Color(0xFF0C6F5A),
                    title: 'Arm Blaster',
                    duration: '25m - 30m',
                  ),
                ),
                _DayPlan(dayLabel: 'Tue', dayNumber: 9),
                _DayPlan(dayLabel: 'Wed', dayNumber: 10),
                _DayPlan(
                  dayLabel: 'Thu',
                  dayNumber: 11,
                  workout: _Workout(
                    tag: 'Leg Workout',
                    tagColor: Color(0xFF3542B8),
                    title: 'Leg Day Blitz',
                    duration: '25m - 30m',
                  ),
                ),
                _DayPlan(dayLabel: 'Fri', dayNumber: 12),
                _DayPlan(dayLabel: 'Sat', dayNumber: 13),
                _DayPlan(dayLabel: 'Sun', dayNumber: 14),
              ],
            ),
            const _WeekBlock(
              title: 'Week 3',
              dateRange: 'December 14-22',
              total: 'Total: 60min',
              days: [
                _DayPlan(dayLabel: 'Mon', dayNumber: 15),
                _DayPlan(dayLabel: 'Tue', dayNumber: 16),
                _DayPlan(dayLabel: 'Wed', dayNumber: 17),
                _DayPlan(dayLabel: 'Thu', dayNumber: 18),
                _DayPlan(dayLabel: 'Fri', dayNumber: 19),
                _DayPlan(dayLabel: 'Sat', dayNumber: 20),
                _DayPlan(dayLabel: 'Sun', dayNumber: 21),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekBlock extends StatelessWidget {
  const _WeekBlock({
    required this.title,
    required this.dateRange,
    required this.total,
    required this.days,
    this.showTopAccent = true,
  });

  final String title;
  final String dateRange;
  final String total;
  final List<_DayPlan> days;
  final bool showTopAccent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: showTopAccent ? const Color(0xFF00D1C4) : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(title, size: 17, weight: FontWeight.w700),
                      SizedBox(height: 2.h),
                      AppText(dateRange, size: 12, color: Colors.white54),
                    ],
                  ),
                ),
                AppText(total, size: 13, color: Colors.white54),
              ],
            ),
            SizedBox(height: 8.h),
            ...days.map((day) => _DayRow(day: day)),
          ],
        ),
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({required this.day});

  final _DayPlan day;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF1E2234), width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 34.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(day.dayLabel, size: 12, color: Colors.white70),
                SizedBox(height: 4.h),
                AppText(
                  '${day.dayNumber}',
                  size: 21,
                  weight: FontWeight.w600,
                  color: day.workout != null ? Colors.white : const Color(0xFF8E94C0),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: day.workout == null
                ? SizedBox(height: 58.h)
                : _WorkoutCard(workout: day.workout!),
          ),
        ],
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({required this.workout});

  final _Workout workout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 10.h, 12.w, 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF171A28), Color(0xFF131520)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 3.w,
            height: 44.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              color: Colors.white,
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 12.w,
            child: Wrap(
              spacing: 2.5.w,
              runSpacing: 2.5.h,
              children: List.generate(
                6,
                (_) => Container(
                  width: 2.8.w,
                  height: 2.8.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7A809C),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: workout.tagColor.withAlpha(72),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.directions_run_rounded,
                        size: 10.sp,
                        color: workout.tagColor,
                      ),
                      SizedBox(width: 4.w),
                      AppText(workout.tag, size: 9, color: workout.tagColor),
                    ],
                  ),
                ),
                SizedBox(height: 6.h),
                AppText(workout.title, size: 17, weight: FontWeight.w600),
              ],
            ),
          ),
          AppText(workout.duration, size: 12, color: Colors.white70),
        ],
      ),
    );
  }
}

class _DayPlan {
  const _DayPlan({
    required this.dayLabel,
    required this.dayNumber,
    this.workout,
  });

  final String dayLabel;
  final int dayNumber;
  final _Workout? workout;
}

class _Workout {
  const _Workout({
    required this.tag,
    required this.tagColor,
    required this.title,
    required this.duration,
  });

  final String tag;
  final Color tagColor;
  final String title;
  final String duration;
}
