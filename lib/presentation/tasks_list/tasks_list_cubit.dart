import 'package:bloc/bloc.dart';
import 'package:task_app/domain/usecases/get_all_tasks.dart';
import 'package:task_app/presentation/tasks_list/tasks_list_state.dart';

class TasksListsCubit extends Cubit<TasksListState> {
  TasksListsCubit({
    required this.getAllTasks,
  }) : super(const TasksListState());

  final GetAllTasksUseCase getAllTasks;

  void getTasks() async {
    final tasks = await getAllTasks();
    emit(state.copyWith(tasks: List.of(tasks)));
  }
}
