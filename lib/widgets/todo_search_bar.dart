import 'package:flutter/material.dart';

class TodoSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Orientation orientation;
  final ColorScheme colorScheme;
  final Function(String) onChanged;

  const TodoSearchBar({
    super.key,
    required this.controller,
    required this.orientation,
    required this.colorScheme,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: orientation == Orientation.portrait ? 16.0 : 24.0,
          vertical: 8.0,
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Search tasks...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withAlpha(128),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
