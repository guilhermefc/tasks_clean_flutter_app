// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String title;
  final String description;
  final DateTime remindMeOn;

  const Task({
    required this.title,
    required this.description,
    required this.remindMeOn,
  });

  @override
  List<Object> get props => [title, description, remindMeOn];

  Task copyWith({
    String? title,
    String? description,
    DateTime? remindMeOn,
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      remindMeOn: remindMeOn ?? this.remindMeOn,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'remindMeOn': remindMeOn.millisecondsSinceEpoch,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] as String,
      description: map['description'] as String,
      remindMeOn: DateTime.fromMillisecondsSinceEpoch(map['remindMeOn'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);
}
