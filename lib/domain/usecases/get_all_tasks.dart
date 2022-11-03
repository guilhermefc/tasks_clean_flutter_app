import 'package:task_app/domain/models/task.dart';
import 'package:task_app/domain/repositories/task_repository.dart';

class GetAllTasksUseCase {
  final TaskRepository repo;

  GetAllTasksUseCase({
    required this.repo,
  });

  Future<List<Task>> call() async {
    return await repo.getAllTasks();
  }
}
