import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/controller/task_controller.dart';
import 'package:task_manager_app/utils/app_text.dart';
import 'package:task_manager_app/view/add_edit_task_screen.dart';
import 'package:task_manager_app/view/widgets/custom_button.dart';
import 'package:task_manager_app/view/widgets/custom_dropdown.dart';
import 'package:task_manager_app/view/widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? selectedDate;

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final taskController = Provider.of<TaskController>(context);

    final filteredTasks = taskController.tasks.where((task) {
      final matchPriority = taskController.selectedPriority == 'All' ||
          task.priority == taskController.selectedPriority;

      final matchCompletion = taskController.selectedCompletion == 'All' ||
          (taskController.selectedCompletion == 'Completed' &&
              task.isCompleted) ||
          (taskController.selectedCompletion == 'Pending' &&
              !task.isCompleted);

      final matchDate = selectedDate == null ||
          isSameDate(task.dueDate, selectedDate!);

      return matchPriority && matchCompletion && matchDate;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        title: const Text(
          AppText.taskManager,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  AppText.filterTasks,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.grey),
                ),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      CustomDropdown<String>(
                        label: AppText.priority,
                        value: taskController.selectedPriority,
                        items: const [
                          'All',
                          AppText.low,
                          AppText.medium,
                          AppText.high
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            taskController.applyFilter(value);
                          }
                        },
                        itemLabelBuilder: (item) => item,
                      ),
                      CustomDropdown<String>(
                        label: AppText.status,
                        value: taskController.selectedCompletion,
                        items: const ['All', 'Completed', 'Pending'],
                        onChanged: (value) {
                          if (value != null) {
                            taskController.applyCompletionFilter(value);
                          }
                        },
                        itemLabelBuilder: (item) => item,
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => selectedDate = picked);
                          }
                        },
                        icon: const Icon(Icons.date_range),
                        label: Text(
                          selectedDate == null
                              ? AppText.anyDate
                              : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() => selectedDate = null);
                            taskController.applyFilter('All');
                            taskController.applyCompletionFilter('All');
                          },
                          icon: const Icon(Icons.clear),
                          label: const Text(AppText.clearFilters),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                AppText.tasks,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: filteredTasks.isEmpty
                    ? const Center(child: Text(AppText.noTasks))
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) =>
                            TaskTile(task: filteredTasks[index]),
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: CustomButton(
          label: AppText.addTask,
          icon: Icons.add,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddOrEditTaskScreen()),
            );
          },
        ),
      ),
    );
  }
}
