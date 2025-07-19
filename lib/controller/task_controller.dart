import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/model/task_model.dart';
import 'package:task_manager_app/service/task_service.dart';
import 'package:task_manager_app/utils/app_text.dart';
import 'package:uuid/uuid.dart';

class TaskController extends ChangeNotifier {
  final TaskService _taskService = TaskService();

  List<TaskModel> _allTasks = [];
  List<TaskModel> _filteredTasks = [];
  String _selectedPriorityFilter = 'All';
  String _selectedCompletionFilter = 'All';

  List<TaskModel> get tasks => _filteredTasks;
  String get selectedPriority => _selectedPriorityFilter;
  String get selectedCompletion => _selectedCompletionFilter;

  TaskController() {
    _init();
  }
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> _init() async {
    await _loadSavedFilter();
    loadTasks();
  }

  Future<void> _loadSavedFilter() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedPriorityFilter = prefs.getString('selected_filter') ?? 'All';
  }

  Future<void> _saveFilter(String filter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_filter', filter);
  }

  void loadTasks() async {
    setLoading(true);

    await Future.delayed(const Duration(seconds: 2));

    _allTasks = _taskService.getAllTasks();
    _applyCombinedFilters();

    setLoading(false);
  }

  void applyFilter(String priority) {
    _selectedPriorityFilter = priority;
    _saveFilter(priority);
    _applyCombinedFilters();
  }

  void applyCompletionFilter(String status) {
    _selectedCompletionFilter = status;
    _applyCombinedFilters();
  }

  void _applyCombinedFilters() {
    _filteredTasks = _allTasks.where((task) {
      final priorityMatch = _selectedPriorityFilter == 'All' ||
          task.priority.toLowerCase() == _selectedPriorityFilter.toLowerCase();

      final completionMatch = _selectedCompletionFilter == 'All' ||
          (_selectedCompletionFilter == 'Completed' && task.isCompleted) ||
          (_selectedCompletionFilter == 'Pending' && !task.isCompleted) ||
          (_selectedCompletionFilter == 'Upcoming' &&
              !task.isCompleted &&
              task.dueDate.isAfter(DateTime.now()));

      return priorityMatch && completionMatch;
    }).toList();

    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    await _taskService.addTask(task);
    loadTasks();
  }

  Future<void> updateTask(TaskModel task) async {
    await _taskService.updateTask(task);
    loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await _taskService.deleteTask(id);
    loadTasks();
  }

  Future<void> toggleComplete(String id) async {
    await _taskService.toggleComplete(id);
    loadTasks();
  }

  Future<void> submitTask({
    required TaskModel task,
    required bool isEditing,
  }) async {
    if (isEditing) {
      await updateTask(task);
    } else {
      await addTask(task);
    }
  }

  Future<void> confirmDeleteTask(BuildContext context, TaskModel task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(AppText.deleteTask),
        content: const Text(AppText.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppText.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(AppText.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      deleteTask(task.id);
    }
  }

  Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return Colors.orangeAccent;
      default:
        return Colors.green;
    }
  }

  String formatPriority(String priority) {
    if (priority.isEmpty) return '';
    return priority[0].toUpperCase() + priority.substring(1);
  }

  void handleTaskSubmission({
  required BuildContext context,
  required String title,
  required String description,
  required DateTime dueDate,
  required String priority,
  String? id,
  bool isCompleted = false,
}) {
  final isEditing = id != null;

  if (title.isNotEmpty && description.isNotEmpty) {
    final task = TaskModel(
      id: id ?? const Uuid().v4(),
      title: title,
      description: description,
      dueDate: dueDate,
      isCompleted: isCompleted,
      priority: priority,
    );

    submitTask(task: task, isEditing: isEditing);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditing
              ? AppText.taskUpdatedMessage
              : AppText.taskAddedMessage,
        ),
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
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter both Title and Description.'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}

}
