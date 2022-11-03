import 'package:task_app/domain/models/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getAllTasks();
  Future<void> addTask(Task task);
}
