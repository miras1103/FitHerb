import 'package:flutter/material.dart';

class IngredientCard extends StatelessWidget {
  final String name;
  final bool initiallyChecked;
  final bool evenRow;
  final ValueChanged<bool?> onChecked;

  const IngredientCard({
    super.key,
    required this.name,
    this.initiallyChecked = false,
    this.evenRow = true,
    required this.onChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: evenRow ? Colors.grey[100] : Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: CheckboxListTile(
        value: initiallyChecked,
        onChanged: onChecked,
        title: Text(
          name,
          style: TextStyle(
            decoration: initiallyChecked ? TextDecoration.lineThrough : null,
          ),
        ),
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }
}
