import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, required this.selected, required this.onSelected});
  final String status;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(status),
      selected: selected,
      onSelected: onSelected,
    );
  }
}
