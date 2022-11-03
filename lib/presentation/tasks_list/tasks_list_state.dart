import 'package:equatable/equatable.dart';

import '../../domain/models/task.dart';

class TasksListState extends Equatable {
  final List<Task> tasks;

  const TasksListState({
    this.tasks = const [],
  });

  TasksListState copyWith({
    List<Task>? tasks,
  }) {
    return TasksListState(
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  List<Object> get props => [tasks];
}
