// lib/view/widgets/custom_dropdown.dart
import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> items;
  final void Function(T?) onChanged;
  final String Function(T) itemLabelBuilder;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemLabelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      value: value,
      borderRadius: BorderRadius.circular(16),
      icon: const Icon(Icons.arrow_drop_down),
      items: items.map((item) {
        final label = itemLabelBuilder(item);
        final isLast = items.last == item;
        return DropdownMenuItem<T>(
          value: item,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              if (!isLast) const Divider(height: 0, thickness: 1),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
