import 'package:flutter/material.dart';

class EditorToolbar extends StatelessWidget {
  const EditorToolbar({
    super.key,
    required this.onBold,
    required this.onItalic,
    required this.onUnderline,
    required this.onLink,
    required this.onList,
    required this.onImage,
  });

  final VoidCallback onBold;
  final VoidCallback onItalic;
  final VoidCallback onUnderline;
  final VoidCallback onLink;
  final VoidCallback onList;
  final VoidCallback onImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.format_bold),
            onPressed: onBold,
          ),
          IconButton(
            icon: const Icon(Icons.format_italic),
            onPressed: onItalic,
          ),
          IconButton(
            icon: const Icon(Icons.format_underline),
            onPressed: onUnderline,
          ),
          IconButton(
            icon: const Icon(Icons.link),
            onPressed: onLink,
          ),
          IconButton(
            icon: const Icon(Icons.format_list_bulleted),
            onPressed: onList,
          ),
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: onImage,
          ),
        ],
      ),
    );
  }
}
