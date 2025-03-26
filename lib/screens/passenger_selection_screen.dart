import 'package:flutter/material.dart';

class PassengerSelectionScreen extends StatefulWidget {
  final int initialCount;

  const PassengerSelectionScreen({super.key, this.initialCount = 1});

  @override
  PassengerSelectionScreenState createState() =>
      PassengerSelectionScreenState();
}

class PassengerSelectionScreenState extends State<PassengerSelectionScreen> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initialCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Passengers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'How many passengers?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: _count > 1
                      ? () {
                          setState(() {
                            _count--;
                          });
                        }
                      : null,
                  iconSize: 36,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '$_count',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: _count < 4
                      ? () {
                          setState(() {
                            _count++;
                          });
                        }
                      : null,
                  iconSize: 36,
                ),
              ],
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _count);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
