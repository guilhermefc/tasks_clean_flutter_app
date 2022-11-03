import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:task_app/domain/repositories/task_repository.dart';
import 'package:task_app/presentation/task_detail/task_detail_cubit.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../domain/usecases/add_task.dart';

class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({
    Key? key,
    required this.taskRepo,
  }) : super(key: key);

  final TaskRepository taskRepo;

  @override
  Widget build(BuildContext context) {
    final addTask = AddTaskUseCase(repo: taskRepo);

    return BlocProvider<TaskDetailCubit>(
        create: (BuildContext context) => TaskDetailCubit(addTask: addTask),
        child: const TaskDetailScreen());
  }
}

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();
    final TextEditingController titleCont = TextEditingController();
    final TextEditingController descriptionCont = TextEditingController();
    final TextEditingController remindDateCont = TextEditingController();
    final TextEditingController remindDateTimeCont = TextEditingController();
    final requiredValidator = RequiredValidator(errorText: 'Required field');
    DateTime? pickedDate;
    TimeOfDay? pickedTime;

    final titleFormField = TextFormField(
      validator: requiredValidator,
      controller: titleCont,
      decoration: const InputDecoration(
        labelText: 'Title',
        hintText: 'Title',
      ),
    );

    final descriptionFormField = TextFormField(
      validator: requiredValidator,
      controller: descriptionCont,
      minLines: 1,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Description',
        hintText: 'Description',
      ),
    );

    final whenFormField = TextFormField(
      validator: requiredValidator,
      readOnly: true,
      controller: remindDateCont,
      onTap: () async {
        pickedDate = await selectDate(pickedDate, context, remindDateCont);
      },
      decoration: const InputDecoration(
        labelText: 'When',
        hintText: 'When',
      ),
    );

    final timeFormField = TextFormField(
      validator: requiredValidator,
      readOnly: true,
      controller: remindDateTimeCont,
      onTap: () async {
        pickedTime = await selectTime(pickedTime, context, remindDateTimeCont);
      },
      decoration: const InputDecoration(
        labelText: 'Time',
        hintText: 'Time',
      ),
    );

    final saveButton = ElevatedButton(
      onPressed: () {
        onSave(formkey, pickedDate, pickedTime, context, titleCont,
            descriptionCont);
      },
      child: const Text('SAVE'),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Create Task')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                titleFormField,
                descriptionFormField,
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: whenFormField,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: timeFormField,
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: saveButton,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<DateTime?> selectDate(DateTime? pickedDate, BuildContext context,
      TextEditingController remindDateCont) async {
    pickedDate = await showDatePicker(
        context: context, //context of current state
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));

    if (pickedDate != null) {
      remindDateCont.text = DateFormat.yMd().format(pickedDate);
    }
    return pickedDate;
  }

  Future<TimeOfDay?> selectTime(TimeOfDay? pickedTime, BuildContext context,
      TextEditingController remindDateTimeCont) async {
    final localizations = MaterialLocalizations.of(context);
    pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      remindDateTimeCont.text = localizations.formatTimeOfDay(pickedTime);
    }
    return pickedTime;
  }

  void onSave(
    GlobalKey<FormState> formkey,
    DateTime? pickedDate,
    TimeOfDay? pickedTime,
    BuildContext context,
    TextEditingController titleCont,
    TextEditingController descriptionCont,
  ) {
    if (formkey.currentState!.validate()) {
      final dt = DateTime(pickedDate!.year, pickedDate.month, pickedDate.day,
          pickedTime!.hour, pickedTime.minute);

      context.read<TaskDetailCubit>().saveTask(
          title: titleCont.text, description: descriptionCont.text, when: dt);

      scheduleNotification(titleCont.text, descriptionCont.text, dt);

      Navigator.pop(context);
    }
  }

  void scheduleNotification(String title, String body, DateTime when) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        tz.TZDateTime.from(when, tz.local),
        const NotificationDetails(
            android: AndroidNotificationDetails('0', 'general',
                channelDescription: 'general')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
