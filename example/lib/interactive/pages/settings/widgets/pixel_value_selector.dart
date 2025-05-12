import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PixelValueSelector extends StatefulWidget {
  const PixelValueSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.step = 1.0,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final String? label;
  final double step;

  @override
  State<PixelValueSelector> createState() => _PixelValueSelectorState();
}

class _PixelValueSelectorState extends State<PixelValueSelector> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toStringAsFixed(0));
  }

  @override
  void didUpdateWidget(PixelValueSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      final newValue = widget.value.toStringAsFixed(0);
      if (_controller.text != newValue) _controller.text = newValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.label != null) ...[
          Expanded(child: Text(widget.label!)),
          SizedBox(width: 8),
        ],
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            final currentValue = double.tryParse(_controller.text) ?? 0;
            widget.onChanged(currentValue - widget.step);
          },
        ),
        SizedBox(
          width: 60,
          child: TextField(
            controller: _controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.numberWithOptions(decimal: false),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(isDense: true),
            onChanged: (text) {
              final newValue = double.tryParse(text);
              if (newValue != null) {
                widget.onChanged(newValue);
              }
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            final currentValue = double.tryParse(_controller.text) ?? 0;
            widget.onChanged(currentValue + widget.step);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
