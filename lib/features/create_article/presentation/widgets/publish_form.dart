import 'package:flutter/material.dart';

class PublishForm extends StatelessWidget {
  const PublishForm({
    super.key,
    required this.onPublish,
  });

  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPublish,
          child: const Text('প্রকাশ করুন'),
        ),
      ],
    );
  }
}
