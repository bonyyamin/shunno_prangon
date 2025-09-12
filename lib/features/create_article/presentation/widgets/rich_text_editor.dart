import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class RichTextEditor extends StatefulWidget {
  const RichTextEditor({super.key, required this.controller});

  final QuillController controller;

  @override
  State<RichTextEditor> createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuillSimpleToolbar(
          controller: widget.controller,
          config: const QuillSimpleToolbarConfig(),
        ),
        Expanded(
          child: QuillEditor.basic(
            controller: widget.controller,
          ),
        ),
      ],
    );
  }
}
