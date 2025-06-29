import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';

import '../common/app_colors.dart';
import 'custom_time_picker.dart';

class TimePickerField extends StatefulWidget {
  final String label;
  final TimeOfDay? initialValue;
  final TimeOfDay? minTime; // ⬅️ Limit period (ensures endTime is after startTime)
  final Function(TimeOfDay) onTimeSelected;
  final String? errorText;

  const TimePickerField({
    Key? key,
    required this.label,
    required this.onTimeSelected,
    this.initialValue,
    this.minTime,
    this.errorText,
  }) : super(key: key);

  @override
  _TimePickerFieldState createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialValue ?? TimeOfDay.now();
  }

  void _onTimeSelected(DateTime pickedTime) {
    TimeOfDay newTime = TimeOfDay(
        hour: pickedTime.hour, minute: pickedTime.minute);

    // Ensure the selected time is not before minTime (if applicable)
    if (widget.minTime != null) {
      final bool isBeforeMinTime = newTime.hour < widget.minTime!.hour ||
          (newTime.hour == widget.minTime!.hour &&
              newTime.minute < widget.minTime!.minute);

      if (isBeforeMinTime) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("End time must be after the start time."),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    setState(() {
      selectedTime = newTime;
    });

    widget.onTimeSelected(newTime);
  }

  OverlayEntry? _overlayEntry; // Holds the floating picker

  @override
  void dispose() {
    _removeOverlay(); // Clean up when widget is removed
    super.dispose();
  }

  // Show the picker as an overlay
  void _showOverlay(BuildContext context) {
    _removeOverlay(); // Ensure only one overlay exists

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero); // Find position

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () => _removeOverlay(), // Tap outside to close
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            Positioned(
              left: offset.dx,
              top: offset.dy + renderBox.size.height + 8, // Position below input
              width: renderBox.size.width,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 180,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomTimePickerSpinner(
                  time: DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute),
                  is24HourMode: false,
                  isForce2Digits: true,
                  highlightedTextStyle: GoogleFonts.redHatDisplay(
                    textStyle: const TextStyle(fontSize: 18, color: kcPrimaryColor, fontWeight: FontWeight.w600),
                  ),
                  normalTextStyle: GoogleFonts.redHatDisplay(
                    textStyle: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  onTimeChange: _onTimeSelected,
                ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          backgroundColor: kcPrimaryColor,
                        ),
                        onPressed: () => _removeOverlay(),
                        child: Text(
                          "Confirm",
                          style: GoogleFonts.redHatDisplay(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              color: kcBlackColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  // Remove overlay picker
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showOverlay(context), // Show picker
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')} ${selectedTime.hour >= 12 ? 'PM' : 'AM'}",
              style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../common/app_colors.dart';
// import 'custom_time_picker.dart';
//
// class TimePickerField extends StatefulWidget {
//   final String label;
//   final TimeOfDay? initialValue;
//   final TimeOfDay? minTime; // ⬅️ Limit period (ensures endTime is after startTime)
//   final Function(TimeOfDay) onTimeSelected;
//   final String? errorText;
//
//   const TimePickerField({
//     Key? key,
//     required this.label,
//     required this.onTimeSelected,
//     this.initialValue,
//     this.minTime,
//     this.errorText,
//   }) : super(key: key);
//
//   @override
//   _TimePickerFieldState createState() => _TimePickerFieldState();
// }
//
// class _TimePickerFieldState extends State<TimePickerField> {
//   late TimeOfDay selectedTime;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedTime = widget.initialValue ?? TimeOfDay.now();
//   }
//
//   void _onTimeSelected(DateTime pickedTime) {
//     TimeOfDay newTime = TimeOfDay(hour: pickedTime.hour, minute: pickedTime.minute);
//
//     // Ensure the selected time is not before minTime (if applicable)
//     if (widget.minTime != null) {
//       final bool isBeforeMinTime = newTime.hour < widget.minTime!.hour ||
//           (newTime.hour == widget.minTime!.hour && newTime.minute < widget.minTime!.minute);
//
//       if (isBeforeMinTime) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("End time must be after the start time."),
//             duration: Duration(seconds: 2),
//           ),
//         );
//         return;
//       }
//     }
//
//     setState(() {
//       selectedTime = newTime;
//     });
//
//     widget.onTimeSelected(newTime);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CustomTimePickerSpinner(
//           time: DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute),
//           is24HourMode: false,
//           isForce2Digits: true,
//           highlightedTextStyle: GoogleFonts.redHatDisplay(
//             textStyle: const TextStyle(fontSize: 18, color: kcPrimaryColor, fontWeight: FontWeight.w600),
//           ),
//           normalTextStyle: GoogleFonts.redHatDisplay(
//             textStyle: const TextStyle(fontSize: 16, color: Colors.black54),
//           ),
//           onTimeChange: _onTimeSelected,
//         ),
//         if (widget.errorText != null)
//           Padding(
//             padding: const EdgeInsets.only(top: 4, left: 8),
//             child: Text(
//               widget.errorText!,
//               style: const TextStyle(color: Colors.red, fontSize: 12),
//             ),
//           ),
//       ],
//     );
//   }
// }
//
