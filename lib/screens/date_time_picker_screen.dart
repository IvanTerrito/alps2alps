import 'package:flutter/material.dart';

import '../core/constants/colors.dart';

class DateTimePickerScreen extends StatefulWidget {
  final DateTime initialDateTime;

  const DateTimePickerScreen({super.key, required this.initialDateTime});

  @override
  DateTimePickerScreenState createState() => DateTimePickerScreenState();
}

class DateTimePickerScreenState extends State<DateTimePickerScreen> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDateTime;
    _selectedTime = TimeOfDay.fromDateTime(widget.initialDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Date & Time'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date selector',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Card(
              color: PCBlue.withValues(alpha: 0.2),
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: PCBlue,
                    primary: PCBlue,
                  ),
                  datePickerTheme: DatePickerThemeData(
                    backgroundColor: PCBlue.withValues(alpha: 0.2),
                    dayBackgroundColor:
                        WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return PCBlue.withValues(alpha: 0.5);
                      }
                      return Colors.transparent;
                    }),
                  ),
                ),
                child: CalendarDatePicker(
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 30)),
                  onDateChanged: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Time selector',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListTile(
              tileColor: PCBlue.withValues(alpha: 0.2),
              title: Text('Selected time: ${_selectedTime.format(context)}'),
              trailing: Icon(Icons.access_time),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: PCBlue,
                          ),
                        ),
                        timePickerTheme: TimePickerThemeData(
                          backgroundColor: Colors.white,
                          dialBackgroundColor: PCBlue.withValues(alpha: 0.1),
                          dialHandColor: PCBlue,
                          hourMinuteColor:
                              WidgetStateColor.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return PCBlue;
                            }
                            return Colors.grey.shade200;
                          }),
                          hourMinuteTextColor:
                              WidgetStateColor.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return Colors.white;
                            }
                            return Colors.black;
                          }),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (picked != null && picked != _selectedTime) {
                  setState(() {
                    _selectedTime = picked;
                  });
                }
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Combine date and time
                final DateTime combined = DateTime(
                  _selectedDate.year,
                  _selectedDate.month,
                  _selectedDate.day,
                  _selectedTime.hour,
                  _selectedTime.minute,
                );
                Navigator.pop(context, combined);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('CONFIRM'),
            ),
          ],
        ),
      ),
    );
  }
}
