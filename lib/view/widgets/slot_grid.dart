import 'package:flutter/material.dart';
import '../../models/slot.dart';
import '../../res/app_colors.dart';

class SlotGrid extends StatelessWidget {
  final List<Slot> slots;
  final Function(Slot) onSlotTap;

  const SlotGrid({super.key, required this.slots, required this.onSlotTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.4,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        return GestureDetector(
          onTap: slot.isBooked ? null : () => onSlotTap(slot),
          child: Container(
            decoration: BoxDecoration(
              color: slot.isBooked
                  ? AppColors.booked.withOpacity(0.15)
                  : AppColors.available.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: slot.isBooked ? AppColors.booked : AppColors.available,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  slot.startTime,
                  style: TextStyle(
                    color: slot.isBooked
                        ? AppColors.booked
                        : AppColors.available,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  slot.isBooked ? 'Booked' : '₹${slot.price.toInt()}',
                  style: TextStyle(
                    color: slot.isBooked
                        ? AppColors.booked.withOpacity(0.8)
                        : AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}