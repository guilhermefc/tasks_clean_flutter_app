import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_app/domain/usecases/get_all_tasks.dart';
import 'package:task_app/presentation/tasks_list/tasks_list_cubit.dart';
import 'package:task_app/presentation/tasks_list/tasks_list_state.dart';

import '../../domain/repositories/task_repository.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({
    Key? key,
    required this.taskRepo,
  }) : super(key: key);

  final TaskRepository taskRepo;

  @override
  Widget build(BuildContext context) {
    final getAllTasks = GetAllTasksUseCase(repo: taskRepo);

    return BlocProvider<TasksListsCubit>(
        create: (BuildContext context) =>
            TasksListsCubit(getAllTasks: getAllTasks),
        child: const TasksListScreen());
  }
}

class TasksListScreen extends StatelessWidget {
  const TasksListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    updateTasks(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Tasks')),
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<TasksListsCubit, TasksListState>(
              buildWhen: (previous, current) =>
                  previous.tasks.length != current.tasks.length,
              builder: (context, state) {
                final taskList = state.tasks;

                final emptyState = Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: const [
                        Image(
                            image: AssetImage('assets/images/empty_list.png')),
                        Text('Let\'s create some tasks to start.  :)')
                      ],
                    ),
                  ),
                );

                final taskListWidget = ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: taskList.length,
                  itemBuilder: (context, index) {
                    final item = taskList[index];
                    return ListTile(
                      title: Text(item.title),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Text(item.description),
                          ),
                          Text(DateFormat.yMd()
                              .add_Hm()
                              .format(item.remindMeOn)),
                        ],
                      ),
                    );
                  },
                );

                final addButton = Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: FloatingActionButton(
                    onPressed: () async {
                      Navigator.pushNamed(context, '/details')
                          .then((value) => updateTasks(context));
                    },
                    child: const Text('+'),
                  ),
                );

                return Expanded(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      if (taskList.isEmpty) emptyState,
                      if (taskList.isNotEmpty) taskListWidget,
                      addButton,
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void updateTasks(BuildContext context) {
    context.read<TasksListsCubit>().getTasks();
  }
}
