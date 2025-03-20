import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TodoDrawer extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;
  final Function(BuildContext) navigateToScheduledTasks;
  final Function(BuildContext) navigateToCompletedTasks;

  const TodoDrawer({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
    required this.navigateToScheduledTasks,
    required this.navigateToCompletedTasks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      child: Container(
        color: colorScheme.surface,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/app_logo.svg',
                        width: 64,
                        height: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Task Manager',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage your tasks efficiently',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimaryContainer.withAlpha(179),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.home_rounded, color: colorScheme.primary),
                title: const Text('Home'),
                selected: true,
                selectedTileColor: colorScheme.primaryContainer.withAlpha(77),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.schedule_rounded,
                  color: colorScheme.secondary,
                ),
                title: const Text('Scheduled Tasks'),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  navigateToScheduledTasks(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.check_circle_rounded,
                  color: colorScheme.tertiary,
                ),
                title: const Text('Completed Tasks'),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  navigateToCompletedTasks(context);
                },
              ),
              const Spacer(),
              const Divider(),
              ListTile(
                leading: Icon(
                  isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  color: isDarkMode ? Colors.amber : Colors.indigo,
                ),
                title: Text(isDarkMode ? 'Light Mode' : 'Dark Mode'),
                onTap: () {
                  Navigator.pop(context);
                  toggleTheme();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
