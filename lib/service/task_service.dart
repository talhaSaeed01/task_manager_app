import 'package:hive/hive.dart';
import 'package:task_manager_app/model/task_model.dart';

class TaskService {
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  final Box<TaskModel> _taskBox = Hive.box<TaskModel>('tasks');

  List<TaskModel> getAllTasks() {
    return _taskBox.values.toList();
  }

  Future<void> addTask(TaskModel task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> updateTask(TaskModel task) async {
  await _taskBox.put(task.id, task); 
}


  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
  }

  Future<void> toggleComplete(String id) async {
    final task = _taskBox.get(id);
    if (task != null) {
      task.isCompleted = !task.isCompleted;
      await task.save();
    }
  }
}
