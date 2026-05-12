import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/utils/app_responsive.dart';
import '../../../common/widgets/app_text.dart';
import '../controller/nutrition_controller.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  late final NutritionController _controller;
  late DateTime _now;
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _controller = NutritionController();
    _now = DateTime.now();
    _clockTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!mounted) return;
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = AppResponsive.horizontalPadding(context).w;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final NutritionInsights data = _controller.insights;

        return Scaffold(
          backgroundColor: const Color(0xFF06070B),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16.h,
                horizontalPadding,
                24.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(
                    controller: _controller,
                    onWeekTap: _pickDate,
                    now: _now,
                  ),
                  SizedBox(height: 22.h),
                  _WorkoutCard(controller: _controller, data: data),
                  SizedBox(height: 22.h),
                  const AppText(
                    'My Insights',
                    size: 22,
                    weight: FontWeight.w700,
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      Expanded(child: _CaloriesCard(data: data)),
                      SizedBox(width: 12.w),
                      Expanded(child: _WeightCard(data: data)),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  _HydrationCard(data: data),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await _showCalendarBottomSheet(
      context: context,
      initialDate: _controller.selectedDate,
    );

    if (picked != null) {
      _controller.selectDate(picked);
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.controller,
    required this.onWeekTap,
    required this.now,
  });

  final NutritionController controller;
  final VoidCallback onWeekTap;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final DateTime selected = controller.selectedDate;
    final bool isDayTime = now.hour >= 6 && now.hour < 18;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/notification.png',
              width: 20.w,
              height: 20.w,
              color: Colors.white,
            ),
            const Spacer(),
            Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                color: const Color(0xFF171924),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white60, width: 1),
              ),
              child: Icon(
                isDayTime ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
                color: Colors.white70,
                size: 16.sp,
              ),
            ),
            SizedBox(width: 6.w),
            InkWell(
              onTap: onWeekTap,
              borderRadius: BorderRadius.circular(8.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                child: Row(
                  children: [
                    AppText(
                      'Week ${controller.selectedWeekOfMonth}/${controller.totalWeeksInSelectedMonth}',
                      size: 15,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
        SizedBox(height: 16.h),
        AppText(_formatLongDate(selected), size: 21, weight: FontWeight.w700),
        SizedBox(height: 12.h),
        _WeekDaysRow(controller: controller),
      ],
    );
  }
}

class _WeekDaysRow extends StatelessWidget {
  const _WeekDaysRow({required this.controller});

  final NutritionController controller;

  @override
  Widget build(BuildContext context) {
    const labels = ['M', 'TU', 'W', 'TH', 'F', 'SA', 'SU'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(controller.weekDates.length, (index) {
        final DateTime d = controller.weekDates[index];
        final bool selected = _isSameDay(d, controller.selectedDate);

        return GestureDetector(
          onTap: () => controller.selectDate(d),
          child: Column(
            children: [
              AppText(labels[index], size: 11, color: Colors.white70),
              SizedBox(height: 8.h),
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? const Color(0xFF0E1A18)
                      : const Color(0xFF171924),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF00C58E)
                        : Colors.transparent,
                    width: 1.6,
                  ),
                ),
                alignment: Alignment.center,
                child: AppText('${d.day}', size: 14, weight: FontWeight.w600),
              ),
              SizedBox(height: 8.h),
              Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? const Color(0xFF00C58E)
                      : Colors.transparent,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({required this.controller, required this.data});

  final NutritionController controller;
  final NutritionInsights data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const AppText('Workouts', size: 24, weight: FontWeight.w700),
            const Spacer(),
            Icon(Icons.wb_sunny_outlined, color: Colors.white, size: 20.sp),
            SizedBox(width: 6.w),
            const AppText('9°', size: 22, weight: FontWeight.w600),
          ],
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            gradient: const LinearGradient(
              colors: [Color(0xFF141825), Color(0xFF1A1C29)],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 4.w,
                height: 52.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1BC4E7),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      '${_monthName(controller.selectedDate.month)} ${controller.selectedDate.day} - ${data.workoutMin}m',
                      size: 11,
                      weight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                    const SizedBox(height: 6),
                    AppText(
                      data.workoutTitle,
                      size: 22,
                      weight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 20.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CaloriesCard extends StatelessWidget {
  const _CaloriesCard({required this.data});

  final NutritionInsights data;

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${data.calories}',
                  style: TextStyle(
                    fontSize: 31.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: ' Calories',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          AppText(
            '${data.remaining} Remaining',
            size: 11,
            color: Colors.white60,
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              const AppText('0', size: 10, color: Colors.white54),
              const Spacer(),
              AppText('${data.goal}', size: 10, color: Colors.white54),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: LinearProgressIndicator(
              value: data.calorieProgress,
              minHeight: 6.h,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF61E4BF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightCard extends StatelessWidget {
  const _WeightCard({required this.data});

  final NutritionInsights data;

  @override
  Widget build(BuildContext context) {
    final bool up = data.weightDelta >= 0;

    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: data.weightKg.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 31.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: ' kg',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Container(
                width: 16.w,
                height: 16.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: up ? const Color(0xFF1A5B44) : const Color(0xFF5B1A1A),
                ),
                child: Icon(
                  up
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 11.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 6.w),
              AppText(
                '${up ? '+' : ''}${data.weightDelta.toStringAsFixed(1)}kg',
                size: 11,
                color: Colors.white70,
              ),
            ],
          ),
          const Spacer(),
          const AppText('Weight', size: 16, weight: FontWeight.w700),
        ],
      ),
    );
  }
}

class _HydrationCard extends StatelessWidget {
  const _HydrationCard({required this.data});

  final NutritionInsights data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF141825), Color(0xFF1A1C29)],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        '${data.hydrationPercent}%',
                        size: 34,
                        weight: FontWeight.w700,
                        color: const Color(0xFF44B5FF),
                      ),
                      const SizedBox(height: 4),
                      const AppText(
                        'Hydration',
                        size: 15,
                        weight: FontWeight.w700,
                      ),
                      const AppText('Log Now', size: 12, color: Colors.white54),
                    ],
                  ),
                ),
                SizedBox(
                  width: 88.w,
                  child: Column(
                    children: [
                      _ScaleLabel(
                        '${(data.hydrationTargetMl / 1000).toStringAsFixed(1)} L',
                      ),
                      _ScaleDash(),
                      _ScaleDash(),
                      _ScaleDash(),
                      const _ScaleLabel('0 L'),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                AppText('${data.hydrationMl}ml', size: 14),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 11.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1B4A56),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(12.r),
              ),
            ),
            child: Center(
              child: AppText(
                '${data.hydrationMl} ml added to water log',
                size: 12,
                color: Colors.white70,
                weight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScaleDash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 4.w,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0xFF44B5FF),
              shape: BoxShape.rectangle,
            ),
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: Divider(color: Colors.white24, thickness: 1.h),
          ),
        ],
      ),
    );
  }
}

class _ScaleLabel extends StatelessWidget {
  const _ScaleLabel(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: AppText(value, size: 10),
    );
  }
}

class _BaseCard extends StatelessWidget {
  const _BaseCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168.h,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF141825), Color(0xFF1A1C29)],
        ),
      ),
      child: child,
    );
  }
}

Future<DateTime?> _showCalendarBottomSheet({
  required BuildContext context,
  required DateTime initialDate,
}) async {
  DateTime displayMonth = DateTime(initialDate.year, initialDate.month, 1);
  DateTime selected = initialDate;

  return showModalBottomSheet<DateTime>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          final List<DateTime?> cells = _monthCells(displayMonth);

          return SafeArea(
            top: false,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.82,
              ),
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 18.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151825),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28.r),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 84.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9195AF),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setSheetState(() {
                                displayMonth = DateTime(
                                  displayMonth.year,
                                  displayMonth.month - 1,
                                  1,
                                );
                              });
                            },
                            icon: const Icon(
                              Icons.chevron_left_rounded,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: AppText(
                                _monthYear(displayMonth),
                                size: 17,
                                weight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setSheetState(() {
                                displayMonth = DateTime(
                                  displayMonth.year,
                                  displayMonth.month + 1,
                                  1,
                                );
                              });
                            },
                            icon: const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onHorizontalDragEnd: (details) {
                          final double velocity = details.primaryVelocity ?? 0;
                          if (velocity.abs() < 180) return;
                          setSheetState(() {
                            final int delta = velocity < 0 ? 1 : -1;
                            displayMonth = DateTime(
                              displayMonth.year,
                              displayMonth.month + delta,
                              1,
                            );
                          });
                        },
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                _WeekLabel('MON'),
                                _WeekLabel('TUE'),
                                _WeekLabel('WED'),
                                _WeekLabel('THU'),
                                _WeekLabel('FRI'),
                                _WeekLabel('SAT'),
                                _WeekLabel('SUN'),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cells.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 7,
                                    childAspectRatio: 1.1,
                                  ),
                              itemBuilder: (context, index) {
                                final DateTime? date = cells[index];
                                if (date == null) {
                                  return const SizedBox.shrink();
                                }

                                final bool isSelected = _isSameDay(
                                  date,
                                  selected,
                                );
                                return Center(
                                  child: GestureDetector(
                                    onTap: () =>
                                        Navigator.of(context).pop(date),
                                    child: Container(
                                      width: 38.w,
                                      height: 38.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? const Color(0xFF1C3D34)
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(0xFF00C58E)
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: AppText(
                                        '${date.day}',
                                        size: 14,
                                        weight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        width: 190.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7E84A8),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

class _WeekLabel extends StatelessWidget {
  const _WeekLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: AppText(
          text,
          size: 11,
          weight: FontWeight.w700,
          color: Colors.white70,
        ),
      ),
    );
  }
}

List<DateTime?> _monthCells(DateTime month) {
  final DateTime first = DateTime(month.year, month.month, 1);
  final DateTime next = DateTime(month.year, month.month + 1, 1);
  final int daysInMonth = next.subtract(const Duration(days: 1)).day;
  final int leading = first.weekday - DateTime.monday;

  final List<DateTime?> cells = List<DateTime?>.filled(
    leading,
    null,
    growable: true,
  );
  for (int day = 1; day <= daysInMonth; day++) {
    cells.add(DateTime(month.year, month.month, day));
  }
  while (cells.length < 42) {
    cells.add(null);
  }
  return cells;
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String _formatLongDate(DateTime d) {
  const weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${weekdays[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}';
}

String _monthName(int month) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return months[month - 1];
}

String _monthYear(DateTime d) => '${_monthName(d.month)} ${d.year}';
