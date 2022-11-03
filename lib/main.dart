import 'package:flutter/material.dart';
import 'package:task_app/presentation/notifications/notification_wrapper.dart';
import 'package:task_app/presentation/task_detail/task_detail_screen.dart';
import 'package:task_app/presentation/tasks_list/tasks_list_screen.dart';

import 'data/repositories/tasks_repository_impl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotificationWrapper.initalizeNotifications(context);
    final taskRepo = TaskRepositoryImpl();

    return MaterialApp(
      title: 'TasksList',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => TaskListPage(taskRepo: taskRepo),
        '/details': (context) => TaskDetailPage(taskRepo: taskRepo),
      },
    );
  }
}
