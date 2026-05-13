import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class CompactCalendar extends StatefulWidget {
  const CompactCalendar({
    super.key,
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  State<CompactCalendar> createState() => _CompactCalendarState();
}

class _CompactCalendarState extends State<CompactCalendar> {
  late DateTime _displayMonth;

  static const _weekDays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  void initState() {
    super.initState();
    _displayMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month);
  }

  bool get _canGoPrev {
    final prev = DateTime(_displayMonth.year, _displayMonth.month - 1);
    return !prev.isBefore(DateTime(widget.firstDate.year, widget.firstDate.month));
  }

  bool get _canGoNext {
    final next = DateTime(_displayMonth.year, _displayMonth.month + 1);
    return !next.isAfter(DateTime(widget.lastDate.year, widget.lastDate.month));
  }

  void _prevMonth() {
    if (_canGoPrev) {
      setState(() => _displayMonth = DateTime(_displayMonth.year, _displayMonth.month - 1));
    }
  }

  void _nextMonth() {
    if (_canGoNext) {
      setState(() => _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final daysInMonth = DateTime(_displayMonth.year, _displayMonth.month + 1, 0).day;
    final startWeekday = DateTime(_displayMonth.year, _displayMonth.month, 1).weekday % 7;
    final rows = ((startWeekday + daysInMonth) / 7).ceil();

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _canGoPrev ? _prevMonth : null,
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: _canGoPrev ? const Color(0xFF111827) : const Color(0xFFD1D5DB),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                iconSize: 22,
              ),
              Text(
                '${_months[_displayMonth.month - 1]} ${_displayMonth.year}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              IconButton(
                onPressed: _canGoNext ? _nextMonth : null,
                icon: Icon(
                  Icons.chevron_right_rounded,
                  color: _canGoNext ? const Color(0xFF111827) : const Color(0xFFD1D5DB),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                iconSize: 22,
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _weekDays
                .map((d) => SizedBox(
                      width: 32,
                      child: Text(
                        d,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ))
                .toList(),
          ),

          const SizedBox(height: 4),

          ...List.generate(rows, (row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (col) {
                final day = row * 7 + col - startWeekday + 1;
                if (day < 1 || day > daysInMonth) {
                  return const SizedBox(width: 32, height: 32);
                }

                final date = DateTime(_displayMonth.year, _displayMonth.month, day);
                final isPast = date.isBefore(DateTime(today.year, today.month, today.day));
                final isSelected = date.year == widget.selectedDate.year &&
                    date.month == widget.selectedDate.month &&
                    date.day == widget.selectedDate.day;
                final isToday = date.year == today.year &&
                    date.month == today.month &&
                    date.day == today.day;

                return GestureDetector(
                  onTap: isPast ? null : () => widget.onDateSelected(date),
                  child: Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      shape: BoxShape.circle,
                      border: isToday && !isSelected
                          ? Border.all(color: AppColors.primary, width: 1.5)
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        color: isSelected
                            ? Colors.white
                            : isPast
                                ? const Color(0xFFD1D5DB)
                                : const Color(0xFF111827),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}
