import 'package:flutter_test/flutter_test.dart';
import 'package:task_app/domain/models/task.dart';

void main() {
  late Task task;
  late DateTime remindMeDate;

  setUp(() async {
    remindMeDate = DateTime(2022, 11, 03);
  });

  test("parses correctly from json", () {
    task = Task.fromJson(
        '{"title":"title","description":"description","remindMeOn":1667444400000}');

    expect(task.title, "title");
    expect(task.description, "description");
    expect(task.remindMeOn, remindMeDate);
  });

  test("parses correctly to json", () {
    task = Task(
        title: 'title', description: 'description', remindMeOn: remindMeDate);

    expect(task.toJson(),
        '{"title":"title","description":"description","remindMeOn":1667444400000}');
  });
}
