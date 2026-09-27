import 'package:flutter/material.dart';

class InputcontrolsDemo extends StatefulWidget {
  const InputcontrolsDemo({super.key});

  @override
  State<InputcontrolsDemo> createState() {
    return _InputcontrolsDemoState();
  }
}

class _InputcontrolsDemoState extends State<InputcontrolsDemo> {
  double volume = 50;
  bool isDarkMode = false;
  String selectedOption = 'Option 1';
  DateTime? selectedDate;

  // Show DatePicker
  Future<void> selectDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Controls')),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Slider
            const Text(
              'Volume',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Slider(
              value: volume,
              min: 0,
              max: 100,
              onChanged: (value) {
                setState(() {
                  volume = value;
                });
              },
            ),

            Text('Volume: ${volume.toInt()}'),

            const SizedBox(height: 20),

            //Switch
            const SizedBox(height: 10),
            Text(
              'Switch',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text(
                'Dark Mode',
              ),
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),

            const SizedBox(height: 10),

            //RadioListTile
            Text(
              'Genre',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RadioListTile<String>(
              title: const Text(
                'Action',
              ),
              value: 'Action',
              groupValue: selectedOption,

              onChanged: (value) {
                setState(() {
                  selectedOption = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text(
                'Comedy',
              ),
              value: 'Comedy',
              groupValue: selectedOption,

              onChanged: (value) {
                setState(() {
                  selectedOption = value!;
                });
              },
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: selectDate,
              child: const Text('Select Date'),
            ),

            const SizedBox(height: 10),

            Text(
              selectedDate == null
                  ? 'No date selected'
                  : 'Selected Date: '
                        '${selectedDate!.day}/'
                        '${selectedDate!.month}/'
                        '${selectedDate!.year}',
            ),
          ],
        ),
      ),
    );
  }
}
