import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  List<String> reminders = [];

  @override
  void initState() {
    super.initState();
    loadReminders();
  }

  Future<void> loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      reminders = prefs.getStringList('reminders') ?? [];
    });
  }

  Future<void> addReminder(String text) async {
    final prefs = await SharedPreferences.getInstance();
    reminders.add(text);
    await prefs.setStringList('reminders', reminders);
    setState(() {});
  }

  void showAddDialog() {
    final controller = TextEditingController();
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Add Reminder'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'Vitamin name',
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (time != null) {
                      setStateDialog(() {
                        selectedTime = time;
                      });
                    }
                  },
                  child: const Text('Pick Time'),
                ),
                if (selectedTime != null)
                  Text('Time: ${selectedTime!.format(context)}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty && selectedTime != null) {
                    final text = '${controller.text} at '
                        '${selectedTime!.format(context)}';
                    addReminder(text);
                  }
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: reminders.isEmpty
          ? const Center(child: Text('No reminders yet'))
          : ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.alarm),
                  title: Text(reminders[index]),
                );
              },
            ),
    );
  }
}
