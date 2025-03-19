import 'package:flutter/material.dart';

class TodoHeader extends StatelessWidget {
  final int remainingTasks;
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const TodoHeader({
    super.key,
    required this.remainingTasks,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Tasks',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$remainingTasks remaining',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface.withAlpha(153),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              size: 28,
            ),
            onPressed: toggleTheme,
            tooltip:
                isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
          ),
        ],
      ),
    );
  }
}
