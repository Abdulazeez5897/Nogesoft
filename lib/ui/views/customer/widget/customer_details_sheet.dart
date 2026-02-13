import 'package:flutter/material.dart';

import 'package:nogesoft/core/data/models/customer.dart';
import 'package:nogesoft/ui/common/ui_helpers.dart';

class CustomerDetailsSheet extends StatelessWidget {
  final Customer customer;

  const CustomerDetailsSheet({super.key, required this.customer});

  static Future<void> show(BuildContext context, Customer customer) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => CustomerDetailsSheet(customer: customer),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryText = theme.textTheme.titleLarge?.color ?? (isDark ? Colors.white : const Color(0xFF0B1220));
    final secondaryText = isDark ? Colors.white70 : Colors.black54;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Customer Details',
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: secondaryText),
                )
              ],
            ),
            verticalSpace(6),

            Text(
              customer.name,
              style: TextStyle(
                color: primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            verticalSpace(4),
            Text(
              customer.phone,
              style: TextStyle(
                color: secondaryText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            verticalSpace(14),

            RichText(
              text: TextSpan(
                style: TextStyle(color: secondaryText, fontSize: 15, fontFamily: 'Outfit'), // Ensure font family matches app
                children: [
                  const TextSpan(
                    text: 'Address: ',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  TextSpan(text: customer.address),
                ],
              ),
            ),
            verticalSpace(14),

            GestureDetector(
              onTap: () {
                // Video shows link only; no navigation shown.
              },
              child: Text(
                'Payments',
                style: TextStyle(
                  color: secondaryText,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            verticalSpace(16),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: theme.cardColor,
                  foregroundColor: secondaryText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: isDark ? BorderSide.none : const BorderSide(color: Colors.black12),
                  ),
                ),
                child: Text(
                  'Close',
                  style: TextStyle(fontWeight: FontWeight.w800, color: secondaryText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
