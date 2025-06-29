import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'dart:math';

class CustomTimePickerSpinner extends StatefulWidget {
  final DateTime? time;
  final bool is24HourMode;
  final bool isForce2Digits;
  final TextStyle? highlightedTextStyle;
  final TextStyle? normalTextStyle;
  final Function(DateTime) onTimeChange;
  final TimeOfDay? minTime; // ⬅️ Added constraint for limiting time selection

  const CustomTimePickerSpinner({
    Key? key,
    this.time,
    this.is24HourMode = true,
    this.isForce2Digits = false,
    this.highlightedTextStyle,
    this.normalTextStyle,
    required this.onTimeChange,
    this.minTime, // ⬅️ New constraint
  }) : super(key: key);

  @override
  _CustomTimePickerSpinnerState createState() => _CustomTimePickerSpinnerState();
}

class _CustomTimePickerSpinnerState extends State<CustomTimePickerSpinner> {
  late ScrollController hourController;
  late ScrollController minuteController;
  int selectedHour = 0;
  int selectedMinute = 0;
  DateTime? currentTime;

  @override
  void initState() {
    super.initState();
    currentTime = widget.time ?? DateTime.now();
    selectedHour = currentTime!.hour;
    selectedMinute = currentTime!.minute;

    hourController = ScrollController(initialScrollOffset: selectedHour * 60);
    minuteController = ScrollController(initialScrollOffset: selectedMinute * 60);
  }

  void _onHourChange(int hour) {
    setState(() {
      selectedHour = hour;
      _updateTime();
    });
  }

  void _onMinuteChange(int minute) {
    // Enforce minTime constraint
    if (widget.minTime != null) {
      final bool isBeforeMinTime = selectedHour < widget.minTime!.hour ||
          (selectedHour == widget.minTime!.hour && minute < widget.minTime!.minute);

      if (isBeforeMinTime) {
        return; // ⬅️ Prevent invalid selection
      }
    }

    setState(() {
      selectedMinute = minute;
      _updateTime();
    });
  }

  void _updateTime() {
    widget.onTimeChange(DateTime(0, 0, 0, selectedHour, selectedMinute));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildSpinner(
          controller: hourController,
          count: widget.is24HourMode ? 24 : 12,
          selectedValue: selectedHour,
          onValueChanged: _onHourChange,
        ),
        const SizedBox(width: 0),
        _buildSpinner(
          controller: minuteController,
          count: 60,
          selectedValue: selectedMinute,
          onValueChanged: _onMinuteChange,
        ),
      ],
    );
  }

  Widget _buildSpinner({
    required ScrollController controller,
    required int count,
    required int selectedValue,
    required Function(int) onValueChanged,
  }) {
    return SizedBox(
      height: 180, // ⬅️ Fixed height for ListView to prevent unbounded height error
      width: 60, // ⬅️ Ensure proper alignment and prevent overflow
      child: ListView.builder(
        controller: controller,
        itemExtent: 60,
        itemCount: count,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final bool isSelected = index == selectedValue;

          return GestureDetector(
            onTap: () => onValueChanged(index),
            child: Center(
              child: Text(
                index.toString().padLeft(2, '0'),
                style: isSelected ? widget.highlightedTextStyle : widget.normalTextStyle,
              ),
            ),
          );
        },
      ),
    );
  }
}
