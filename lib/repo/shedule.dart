import 'package:tp_ftm/models/task_model.dart';

List<Task> prioritize(List<Task> tasks) {
  tasks.sort((a, b) => a.period.compareTo(b.period));
  return tasks;
}

int lcmPeriods(List<Task> tasks) {
  int gcd(int a, int b) => b == 0 ? a : gcd(b, a % b);
  int lcm(int a, int b) => (a ~/ gcd(a, b)) * b;
  return tasks.map((t) => t.period).reduce(lcm);
}

List<String> scheduleTimeline(List<Task> tasks) {
  if (tasks.isEmpty) return [];
  final ordered = prioritize(tasks);

  final H = lcmPeriods(ordered);

  final remaining = {for (var t in ordered) t: 0};
  final timeline = List.filled(H, 'Idle');

  for (int time = 0; time < H; time++) {
    for (var t in ordered) {
      if (time >= t.start && (time - t.start) % t.period == 0) {
        remaining[t] = t.computationTime;
      }
    }

    Task? running;
    for (var t in ordered) {
      if (remaining[t]! > 0) {
        running = t;
        break;
      }
    }

    if (running != null) {
      timeline[time] = running.name;
      remaining[running] = remaining[running]! - 1;
    }
  }

  return timeline;
}
