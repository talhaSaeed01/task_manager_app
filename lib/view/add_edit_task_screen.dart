
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/model/task_model.dart';
import 'package:task_manager_app/view/widgets/custom_button.dart';
import 'package:task_manager_app/view/widgets/custom_dropdown.dart';
import 'package:task_manager_app/view/widgets/custom_textfield.dart';
import 'package:uuid/uuid.dart';
import '../controller/task_controller.dart';
import '../utils/priority_enum.dart' as custom;
import '../utils/app_text.dart';
import 'package:intl/intl.dart';

class AddOrEditTaskScreen extends StatefulWidget {
  final TaskModel? taskToEdit;

  const AddOrEditTaskScreen({super.key, this.taskToEdit});

  @override
  State<AddOrEditTaskScreen> createState() => _AddOrEditTaskScreenState();
}

class _AddOrEditTaskScreenState extends State<AddOrEditTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  late custom.Priority _selectedPriority;
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    if (widget.taskToEdit != null) {
      _titleController.text = widget.taskToEdit!.title;
      _descController.text = widget.taskToEdit!.description;
      _selectedPriority = custom.Priority.values.firstWhere(
        (p) => p.name == widget.taskToEdit!.priority,
        orElse: () => custom.Priority.low,
      );
    } else {
      _selectedPriority = custom.Priority.low;
    }
  }

  void _handleSubmit() {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isNotEmpty) {
      final isEditing = widget.taskToEdit != null;

      final task = TaskModel(
        id: widget.taskToEdit?.id ?? const Uuid().v4(),
        title: title,
        description: desc,
        dueDate: DateTime.now(),
        isCompleted: widget.taskToEdit?.isCompleted ?? false,
        priority: _selectedPriority.name,
      );

      final taskController =
          Provider.of<TaskController>(context, listen: false);
      taskController.submitTask(task: task, isEditing: isEditing);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditing
              ? AppText.taskUpdatedMessage
              : AppText.taskAddedMessage),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskToEdit != null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditing ? AppText.editTask : AppText.addTask,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 4,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    DateFormat(AppText.dateFormat).format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.deepPurple.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                AppText.taskDetails,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: AppText.taskTitle,
                      hint: AppText.titleHint,
                      controller: _titleController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: AppText.taskDescription,
                      hint: AppText.descriptionHint,
                      controller: _descController,
                      maxLines: 6,
                    ),
                    const SizedBox(height: 16),
                    const Text(AppText.priority,
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),

                    // Custom Dropdown
                    CustomDropdown<custom.Priority>(
                      label: AppText.priority,
                      value: _selectedPriority,
                      items: custom.Priority.values,
                      onChanged: (val) {
                        if (val != null)
                          setState(() => _selectedPriority = val);
                      },
                      itemLabelBuilder: (priority) => priority.label,
                    ),

                    if (_isDropdownOpen)
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(14),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Column(
                          children: custom.Priority.values.map((priority) {
                            final isLast =
                                custom.Priority.values.last == priority;
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  title: Text(priority.label),
                                  onTap: () {
                                    setState(() {
                                      _selectedPriority = priority;
                                      _isDropdownOpen = false;
                                    });
                                  },
                                ),
                                if (!isLast)
                                  const Divider(height: 0, color: Colors.grey),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: CustomButton(
          label: isEditing ? AppText.saveTask : AppText.addTask,
          onPressed: _handleSubmit,
        ),
      ),
    );
  }
}
