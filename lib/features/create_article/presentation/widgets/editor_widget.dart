import 'package:flutter/material.dart';
import 'package:shunno_prangon/app/constants/app_constants.dart';
import 'package:shunno_prangon/app/themes/theme_extensions.dart';

class EditorWidget extends StatelessWidget {

  const EditorWidget({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.summaryController,
    required this.contentController,
    required this.tagController,
    required this.selectedCategory,
    required this.tags,
    required this.onCategoryChanged,
    required this.onAddTag,
    required this.onRemoveTag,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController summaryController;
  final TextEditingController contentController;
  final TextEditingController tagController;
  final String selectedCategory;
  final List<String> tags;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onAddTag;
  final void Function(String) onRemoveTag;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTitleField(),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildCategorySelector(context),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildSummaryField(),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildTagsSection(context),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildContentField(context),
            const SizedBox(height: AppConstants.extraLargePadding),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() => TextFormField(
        controller: titleController,
        maxLength: AppConstants.maxTitleLength,
        decoration: const InputDecoration(
          labelText: 'প্রবন্ধের শিরোনাম',
          hintText: 'একটি আকর্ষণীয় শিরোনাম লিখুন...',
          prefixIcon: Icon(Icons.title),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'শিরোনাম আবশ্যক';
          }
          if (value.trim().length < 10) {
            return 'শিরোনাম কমপক্ষে ১০ অক্ষরের হতে হবে';
          }
          return null;
        },
      );

  Widget _buildCategorySelector(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('বিভাগ', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppConstants.smallPadding),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedCategory,
                isExpanded: true,
                items: AppConstants.categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: context.cosmic.categoryColors[category],
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: AppConstants.smallPadding),
                        Text(AppConstants.categoriesInBengali[category] ?? category),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: onCategoryChanged,
              ),
            ),
          ),
        ],
      );

  Widget _buildSummaryField() => TextFormField(
        controller: summaryController,
        maxLines: 3,
        maxLength: AppConstants.maxDescriptionLength,
        decoration: const InputDecoration(
          labelText: 'সংক্ষিপ্ত বিবরণ',
          hintText: 'প্রবন্ধের মূল বিষয়বস্তু সম্পর্কে একটি সংক্ষিপ্ত বিবরণ লিখুন...',
          prefixIcon: Icon(Icons.description_outlined),
          alignLabelWithHint: true,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'সংক্ষিপ্ত বিবরণ আবশ্যক';
          }
          if (value.trim().length < 20) {
            return 'সংক্ষিপ্ত বিবরণ কমপক্ষে ২০ অক্ষরের হতে হবে';
          }
          return null;
        },
      );

  Widget _buildTagsSection(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ট্যাগ সমূহ', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppConstants.smallPadding),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: tagController,
                  decoration: const InputDecoration(
                    labelText: 'ট্যাগ যোগ করুন',
                    hintText: 'যেমন: পদার্থবিজ্ঞান, নক্ষত্র',
                    prefixIcon: Icon(Icons.local_offer_outlined),
                  ),
                  onFieldSubmitted: (_) => onAddTag(),
                ),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              IconButton(
                onPressed: onAddTag,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: AppConstants.smallPadding),
            Wrap(
              spacing: AppConstants.smallPadding,
              runSpacing: AppConstants.smallPadding / 2,
              children: tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => onRemoveTag(tag),
                  backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(25),
                );
              }).toList(),
            ),
          ],
        ],
      );

  Widget _buildContentField(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('প্রবন্ধের মূল অংশ', style: Theme.of(context).textTheme.titleMedium),
              const Row(
                children: [
                  IconButton(onPressed: null, icon: Icon(Icons.format_bold), tooltip: 'বোল্ড'),
                  IconButton(onPressed: null, icon: Icon(Icons.format_italic), tooltip: 'ইটালিক'),
                  IconButton(onPressed: null, icon: Icon(Icons.image), tooltip: 'ছবি যোগ করুন'),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            ),
            child: TextFormField(
              controller: contentController,
              maxLines: 15,
              maxLength: AppConstants.maxArticleContentLength,
              decoration: const InputDecoration(
                hintText:
                    'আপনার প্রবন্ধ এখানে লিখুন...\n\nমহাকাশের রহস্য, বিজ্ঞানের নতুন আবিষ্কার, বা যে কোনো বৈজ্ঞানিক বিষয় নিয়ে আপনার চিন্তাভাবনা শেয়ার করুন।',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(AppConstants.defaultPadding),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'প্রবন্ধের মূল অংশ আবশ্যক';
                }
                if (value.trim().length < 100) {
                  return 'প্রবন্ধ কমপক্ষে ১০০ অক্ষরের হতে হবে';
                }
                return null;
              },
            ),
          ),
        ],
      );
}