import 'package:bloc/bloc.dart';
import 'package:task_app/domain/usecases/add_task.dart';
import 'package:task_app/presentation/task_detail/task_detail_state.dart';

import '../../domain/models/task.dart';

class TaskDetailCubit extends Cubit<TaskDetailState> {
  TaskDetailCubit({required this.addTask}) : super(TaskDetailState());

  final AddTaskUseCase addTask;

  Future<void> saveTask({
    required String title,
    required String description,
    required DateTime when,
  }) async {
    final task = Task(
      title: title,
      description: description,
      remindMeOn: when,
    );
    await addTask.call(task);
  }
}
