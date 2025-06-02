import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tp_ftm/models/task_model.dart';
import 'package:tp_ftm/repo/shedule.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: RMSchedulerPage());
  }
}

class RMSchedulerPage extends StatefulWidget {
  const RMSchedulerPage({super.key});

  @override
  _RMSchedulerPageState createState() => _RMSchedulerPageState();
}

class _RMSchedulerPageState extends State<RMSchedulerPage> {
  Color _pickedColor = Colors.blue;
  final _formKey = GlobalKey<FormState>();
  final List<Task> tasks = [];
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _computationCtrl = TextEditingController();
  final TextEditingController _periodCtrl = TextEditingController();
  final TextEditingController _startCtrl = TextEditingController();
  @override
  void dispose() {
    _nameCtrl.dispose();
    _computationCtrl.dispose();
    _periodCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Rate Monotonic Scheduler')),
        body: Column(
          children: [
            Expanded(flex: 2, child: _buildTaskForm()),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Please add at least one task.',
                style: TextStyle(fontSize: 18, color: Colors.orange),
              ),
            ),
          ],
        ),
      );
    }

    final timeline = scheduleTimeline(tasks);

    return Scaffold(
      appBar: AppBar(title: Text('Rate Monotonic Scheduler')),
      body: Column(
        children: [
          Expanded(flex: 2, child: _buildTaskForm()),

          Expanded(flex: 2, child: _buildTimelineView(timeline, tasks)),
        ],
      ),
    );
  }

  Widget _buildTaskForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _startCtrl,
                decoration: InputDecoration(labelText: 'Start Time (ms)'),
                keyboardType: TextInputType.number,
                validator:
                    (v) =>
                        v == null || int.tryParse(v) == null
                            ? 'Enter valid number'
                            : null,
              ),
              SizedBox(height: 6),
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(labelText: 'Task Name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _computationCtrl,
                decoration: InputDecoration(labelText: 'Computation Time (ms)'),
                keyboardType: TextInputType.number,
                validator:
                    (v) =>
                        v == null || int.tryParse(v) == null
                            ? 'Enter valid number'
                            : null,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _periodCtrl,
                decoration: InputDecoration(labelText: 'Period (ms)'),
                keyboardType: TextInputType.number,
                validator:
                    (v) =>
                        v == null || int.tryParse(v) == null
                            ? 'Enter valid number'
                            : null,
              ),
              GestureDetector(
                onTap: () => _showColorPicker(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _pickedColor,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      tasks.add(
                        Task(
                          start: int.parse(_startCtrl.text),
                          name: _nameCtrl.text,
                          computationTime: int.parse(_computationCtrl.text),
                          period: int.parse(_periodCtrl.text),
                          color: _pickedColor,
                        ),
                      );
                      _nameCtrl.clear();
                      _computationCtrl.clear();
                      _periodCtrl.clear();
                      _startCtrl.clear();
                      _pickedColor = Colors.blue;
                    });
                  }
                },
                child: Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineView(List<String> timeline, List<Task> tasks) {
    // On suppose que timeline[i] == tasks[j].name
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(timeline.length, (i) {
          final label = timeline[i];
          // Cherche la tâche
          final task = tasks.firstWhere(
            (t) => t.name == label,
            orElse:
                () => Task(
                  start: 0,
                  name: 'Idle',
                  computationTime: 0,
                  period: 0,
                  color: Colors.grey.shade300,
                ),
          );
          return Container(
            width: 20,
            height: 40,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 1),
            color:
                label == 'Idle'
                    ? Colors.grey.shade300
                    : task.color.withOpacity(0.7),
            child: Text(
              label,
              style: TextStyle(fontSize: 8, color: Colors.white),
            ),
          );
        }),
      ),
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Choisissez une couleur'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: _pickedColor,
                onColorChanged: (color) => setState(() => _pickedColor = color),
                pickerAreaHeightPercent: 0.7,
              ),
            ),
            actions: [
              TextButton(
                child: Text('Annuler'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                child: Text('Valider'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }
}
