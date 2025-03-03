import 'package:drill_events/app/features/widgets/app_text_field.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

class OptionsTile extends StatefulWidget {
  const OptionsTile({super.key, required this.title, required this.onEditingComplete});

  final String title;
  final Function(Iterable<String> value) onEditingComplete;

  @override
  State<OptionsTile> createState() => _OptionsTileState();
}

class _OptionsTileState extends State<OptionsTile> {
  final options = {const ValueKey<String>('first'): TextEditingController()};

  @override
  void dispose() {
    _disposeTextFields();
    super.dispose();
  }

  void _disposeTextFields() {
    for (final controller in options.values) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: texts.body.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        for (final (index, entry) in options.entries.indexed) ...[
          _Options(
            key: entry.key,
            controller: entry.value,
            onAdd: () => setState(() => options[ValueKey(entry.value.text)] = TextEditingController()),
            onDelete: () => options.remove(entry.key),
            onEditingComplete: onEditionComplete,
          ),
          if (index != options.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  void onEditionComplete() {
    final result = options.values.map((textController) => textController.text);
    widget.onEditingComplete(result);
  }
}

class _Options extends StatefulWidget {
  const _Options({
    required super.key,
    required this.controller,
    required this.onAdd,
    required this.onDelete,
    required this.onEditingComplete,
  });

  final TextEditingController controller;
  final VoidCallback onAdd;
  final VoidCallback onDelete;
  final VoidCallback onEditingComplete;

  @override
  State<_Options> createState() => _OptionsState();
}

class _OptionsState extends State<_Options> {
  bool _isShowAddButton = false;
  bool _isSave = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_textControllerListener);
  }

  void _textControllerListener() {
    if (_isShowAddButton) return;
    if (widget.controller.text.isNotEmpty && widget.controller.text.length > 5) {
      setState(() => _isShowAddButton = true);
    }
  }

  void _onEditingComplete() {}

  @override
  void dispose() {
    widget.controller.removeListener(_textControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;

    if (_isSave) {
      return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Align(alignment: Alignment.centerRight, child: Icon(Icons.delete, color: colors.inverse)),
          ),
        ),
        onDismissed: (_) => widget.onDelete(),
        child: AppTextField(readOnly: true, controller: widget.controller),
      );
    }

    return Row(
      children: [
        Expanded(
          child: AppTextField(
            onTapOutside: (_) => widget.onEditingComplete(),
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
              widget.onEditingComplete();
            },
            maxLines: 1,
            controller: widget.controller,
          ),
        ),
        if (_isShowAddButton) ...[
          const SizedBox(width: 8),
          _AddOptionButton(
            onTap: () {
              widget.onAdd();
              setState(() => _isSave = true);
            },
          ),
        ],
      ],
    );
  }
}

class _AddOptionButton extends StatelessWidget {
  const _AddOptionButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: 36,
        child: DecoratedBox(
          decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
          child: Icon(Icons.add, color: colors.inverse),
        ),
      ),
    );
  }
}
