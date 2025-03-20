import 'package:flutter/material.dart';

class TodoHeader extends StatelessWidget {
  final int incompleteTodosCount;
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const TodoHeader({
    super.key,
    required this.incompleteTodosCount,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 0),
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
                  '$incompleteTodosCount remaining',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface.withAlpha(153),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Builder(
                  builder:
                      (context) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                ),
                IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    size: 28,
                  ),
                  onPressed: toggleTheme,
                  tooltip:
                      isDarkMode
                          ? 'Switch to light mode'
                          : 'Switch to dark mode',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
