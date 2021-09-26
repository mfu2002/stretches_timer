import 'package:flutter/material.dart';
import 'package:stretches_timer/model/CountDownInfo.dart';
import 'package:stretches_timer/screen/countdown_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _form = GlobalKey<FormState>();

  CountDownInfo _timerInfo = CountDownInfo(30, 5, 3);
  final _initial = {'stretch': '30', 'break': '5', 'iteration': '3'};

  void _startTimer() {
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();

    Navigator.of(context)
        .pushNamed(CountdownScreen.routeName, arguments: _timerInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stretches Timer'),
      ),
      body: Form(
        key: _form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              child: TextFormField(
                initialValue: _initial['stretch'],
                decoration: const InputDecoration(
                  labelText: 'Stretch Duration (sec):',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  return null;
                },
                onSaved: (value) => _timerInfo = CountDownInfo(
                  int.parse(value!),
                  _timerInfo.intervalCount,
                  _timerInfo.breakDuration,
                ),
              ),
            ),
            Container(
              width: 200,
              child: TextFormField(
                initialValue: _initial['break'],
                decoration: const InputDecoration(
                  labelText: 'Break Duration (sec):',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  return null;
                },
                onSaved: (value) => _timerInfo = CountDownInfo(
                  _timerInfo.stretchDuration,
                  _timerInfo.intervalCount,
                  int.parse(value!),
                ),
              ),
            ),
            Container(
              width: 200,
              child: TextFormField(
                initialValue: _initial['iteration'],
                decoration: const InputDecoration(
                  labelText: 'Iteration Count',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  return null;
                },
                onSaved: (value) => _timerInfo = CountDownInfo(
                  _timerInfo.stretchDuration,
                  int.parse(value!),
                  _timerInfo.breakDuration,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startTimer,
                child: Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
