import 'package:flutter/material.dart';

import '../models/todo.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(String, Priority) onAddTask;
  final Todo? todoToEdit;
  final Function(String, String, Priority)? onUpdateTask;

  const AddTaskDialog({
    super.key,
    required this.onAddTask,
    this.todoToEdit,
    this.onUpdateTask,
  });

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final controller = TextEditingController();
  late Priority selectedPriority;
  bool get isEditMode => widget.todoToEdit != null;
  String? errorText;
  bool attemptedSubmit = false;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      controller.text = widget.todoToEdit!.title;
      selectedPriority = widget.todoToEdit!.priority;
    } else {
      selectedPriority = Priority.medium;
    }
    controller.addListener(_validateInput);
  }

  void _validateInput() {
    setState(() {
      if (controller.text.trim().isEmpty) {
        errorText = 'Task name cannot be empty';
      } else {
        errorText = null;
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditMode ? 'Edit Task' : 'Add Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Task name',
                border: const OutlineInputBorder(),
                errorText: attemptedSubmit ? errorText : null,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Priority:'),
            _buildPriorityOption('High', Priority.high, Colors.red.shade300),
            _buildPriorityOption(
              'Medium',
              Priority.medium,
              Colors.orange.shade300,
            ),
            _buildPriorityOption('Low', Priority.low, Colors.green.shade300),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              attemptedSubmit = true;
              _validateInput();
            });

            if (controller.text.trim().isNotEmpty) {
              if (isEditMode) {
                widget.onUpdateTask?.call(
                  widget.todoToEdit!.id,
                  controller.text.trim(),
                  selectedPriority,
                );
              } else {
                widget.onAddTask(controller.text.trim(), selectedPriority);
              }
              Navigator.pop(context);
            }
          },
          child: Text(isEditMode ? 'Update' : 'Add'),
        ),
      ],
    );
  }

  Widget _buildPriorityOption(String label, Priority priority, Color color) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedPriority = priority;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Radio<Priority>(
              value: priority,
              groupValue: selectedPriority,
              onChanged: (Priority? newPriority) {
                if (newPriority != null) {
                  setState(() {
                    selectedPriority = newPriority;
                  });
                }
              },
              activeColor: color,
            ),
            Icon(Icons.flag, size: 16, color: color),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
