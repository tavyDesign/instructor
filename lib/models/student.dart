import 'package:flutter/cupertino.dart';

class Student {
  final int id;
  final String email;
  final String name;
  final int? appId;
  final int status;
  final String category;
  final DateTime addedAt;
  final bool statistics;
  final double passRate;
  final int totalQuestionsResolved;
  final int totalTests;
  final DateTime? lastAnswerTime;
  final List<dynamic>? quizzes;
  final Map<String, dynamic>? quizPagination;
  final List<dynamic>? topWrongAnswers;

  Student({
    required this.id,
    required this.email,
    required this.name,
    this.appId,
    required this.status,
    required this.category,
    required this.addedAt,
    required this.statistics,
    this.passRate = 0.0,
    this.totalQuestionsResolved = 0,
    this.totalTests = 0,
    this.lastAnswerTime,
    this.quizzes,
    this.quizPagination,
    this.topWrongAnswers,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    final statistics = json['statistics'];
    return Student(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'].toString(),
      appId: json['appid'] as int?,
      status: json['status'] as int,
      category: json['category'] as String,
      addedAt: DateTime.parse(json['added_at'] ?? DateTime.now().toIso8601String()),
      statistics: statistics != null,
      passRate: statistics?['pass_rate']?.toDouble() ?? 0.0,
      totalQuestionsResolved: statistics?['total_questions_resolved'] ?? 0,
      totalTests: statistics?['total_tests'] ?? 0,
      lastAnswerTime: statistics?['last_answer_time'] != null ? DateTime.parse(statistics['last_answer_time']) : null,
      quizzes: json['quizzes'],
      quizPagination: json['quiz_pagination'],
      topWrongAnswers: json['top_wrong_answers'],
    );
  }
}
