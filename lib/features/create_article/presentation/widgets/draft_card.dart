import 'package:flutter/material.dart';
import 'package:shunno_prangon/app/constants/app_constants.dart';
import 'package:shunno_prangon/app/themes/theme_extensions.dart';
import 'package:shunno_prangon/features/create_article/data/models/draft_model.dart';

class DraftCard extends StatelessWidget {
  const DraftCard({
    super.key,
    required this.draft,
    required this.onTap,
    required this.onDelete,
    required this.onPublish,
  });

  final DraftModel draft;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) {
    final categoryColor =
        context.cosmic.categoryColors[draft.category] ?? Colors.grey;
    final timeAgo = _formatTimeAgo(draft.lastModified);

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.smallPadding,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        AppConstants.smallBorderRadius,
                      ),
                    ),
                    child: Text(
                      AppConstants.categoriesInBengali[draft.category] ??
                          draft.category,
                      style: TextStyle(
                        color: categoryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onTap();
                          break;
                        case 'publish':
                          onPublish();
                          break;
                        case 'delete':
                          onDelete();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('সম্পাদনা'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'publish',
                        child: Row(
                          children: [
                            Icon(Icons.publish, size: 18),
                            SizedBox(width: 8),
                            Text('প্রকাশ করুন'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'মুছে ফেলুন',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                    child: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                draft.title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                draft.summary,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              if (draft.tags.isNotEmpty) ...[
                Wrap(
                  spacing: AppConstants.smallPadding / 2,
                  runSpacing: AppConstants.smallPadding / 2,
                  children: draft.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppConstants.smallBorderRadius,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppConstants.smallPadding),
              ],
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(timeAgo, style: Theme.of(context).textTheme.bodySmall),
                  const Spacer(),
                  Icon(
                    Icons.text_fields,
                    size: 14,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${draft.wordCount} শব্দ',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} মিনিট আগে';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ঘন্টা আগে';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} দিন আগে';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
