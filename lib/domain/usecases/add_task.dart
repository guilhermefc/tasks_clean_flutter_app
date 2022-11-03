import 'package:task_app/domain/models/task.dart';
import 'package:task_app/domain/repositories/task_repository.dart';

class AddTaskUseCase {
  final TaskRepository repo;

  AddTaskUseCase({
    required this.repo,
  });

  Future<void> call(Task task) async {
    await repo.addTask(task);
  }
}
