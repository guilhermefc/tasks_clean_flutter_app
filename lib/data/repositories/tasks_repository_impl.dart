import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/domain/models/task.dart';
import 'package:task_app/domain/repositories/task_repository.dart';

class TaskRepositoryImpl extends TaskRepository {
  final kTaskListBox = 'task_box';

  @override
  Future<void> addTask(Task task) async {
    final prefs = await SharedPreferences.getInstance();

    final tasksList = await getAllTasks();
    tasksList.add(task);

    prefs.setStringList(
      kTaskListBox,
      tasksList
          .map(
            (e) => e.toJson(),
          )
          .toList(),
    );
  }

  @override
  Future<List<Task>> getAllTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final rawList = prefs.getStringList(kTaskListBox);
    final List<Task> tasksList = List.empty(growable: true);

    if (rawList != null) {
      tasksList.addAll(
        rawList
            .map(
              (e) => Task.fromJson(e),
            )
            .toList(growable: true),
      );
    }

    return tasksList;
  }
}
