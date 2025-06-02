import 'package:flutter/material.dart';

class Task {
  final String name;
  final int computationTime;
  final int period;
  final int start;
  final Color color;
  Task({
    required this.color,
    required this.start,
    required this.name,
    required this.computationTime,
    required this.period,
  });
}
