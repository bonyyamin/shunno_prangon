import 'package:flutter/material.dart';
import 'package:shunno_prangon/app/constants/app_constants.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  final String selectedCategory;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      onChanged: onChanged,
      items: AppConstants.categories.map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(AppConstants.categoriesInBengali[category] ?? category),
        );
      }).toList(),
      decoration: const InputDecoration(
        labelText: 'বিভাগ',
        border: OutlineInputBorder(),
      ),
    );
  }
}
