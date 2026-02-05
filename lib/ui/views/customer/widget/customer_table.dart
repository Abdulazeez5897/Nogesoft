import 'package:flutter/material.dart';

import 'package:nogesoft/core/data/models/customer.dart';
import 'package:nogesoft/ui/common/ui_helpers.dart';

class CustomerTable extends StatelessWidget {
  final List<Customer> customers;
  final void Function(Customer) onView;

  const CustomerTable({
    super.key,
    required this.customers,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF101A2B),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 14,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const _HeaderRow(),
          verticalSpace(6),
          const Divider(color: Colors.white10, height: 1),

          if (customers.isEmpty) ...[
            verticalSpace(28),
            const Center(
              child: Text(
                'No customers found',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            verticalSpace(28),
          ] else ...[
            ...customers.map((c) => _CustomerRow(
              customer: c,
              onView: () => onView(c),
            )),
          ],
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          flex: 5,
          child: Text(
            'Name',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            'Phone',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Action',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomerRow extends StatelessWidget {
  final Customer customer;
  final VoidCallback onView;

  const _CustomerRow({required this.customer, required this.onView});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(color: Colors.white10, height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  customer.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  customer.phone,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: onView,
                    child: const Text(
                      'View',
                      style: TextStyle(
                        color: Colors.white70,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
