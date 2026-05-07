import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  TimeOfDay? selectedTime;
  Future<void> _loadReminder() async {
    final prefs = await SharedPreferences.getInstance();

    final hour = prefs.getInt('hour');
    final minute = prefs.getInt('minute');

    if (hour != null && minute != null) {
      setState(() {
        selectedTime = TimeOfDay(hour: hour, minute: minute);
      });
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  void _saveReminder() async {
    if (selectedTime == null) return;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('hour', selectedTime!.hour);
    await prefs.setInt('minute', selectedTime!.minute);

    if (mounted) {
      Navigator.pop(context, selectedTime);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadReminder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Reminder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickTime,
              child: const Text('Pick Time'),
            ),
            const SizedBox(height: 20),
            Text(
              selectedTime == null
                  ? 'No time selected'
                  : 'Selected: ${selectedTime!.format(context)}',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveReminder,
              child: const Text('Save Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
