import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:stretches_timer/model/CountDownInfo.dart';
import 'package:wakelock/wakelock.dart';

class CountdownScreen extends StatefulWidget {
  static final routeName = 'countdown';

  const CountdownScreen({Key? key}) : super(key: key);

  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  final _controller = CountDownController();
  CountDownInfo? timerInfo;
  bool isStretching = true;
  int iterationCount = 0;
  final audioCache = AudioCache();

  @override
  void initState() {
    Wakelock.enable();
    super.initState();
  }

  @override
  void deactivate() {
    Wakelock.disable();
    super.deactivate();
  }

  void _timerIterationCompleted() async {
    if (!isStretching) {
      iterationCount++;
    }

    if (iterationCount == timerInfo!.intervalCount) {
      await audioCache.play('applause.mp3');
      Navigator.of(context).pop();
      return;
    } else {
      await audioCache.play('buzzer.wav');
    }

    setState(() {
      isStretching = !isStretching;
      _controller.restart();
    });
  }

  @override
  Widget build(BuildContext context) {
    timerInfo = ModalRoute.of(context)!.settings.arguments as CountDownInfo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Count down'),
      ),
      body: Center(
        child: CircularCountDownTimer(
          key: ValueKey(isStretching),
          controller: _controller,
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
          duration: isStretching
              ? timerInfo!.stretchDuration
              : timerInfo!.breakDuration,
          isReverse: true,
          isReverseAnimation: true,
          strokeCap: StrokeCap.round,
          strokeWidth: 20.0,
          backgroundColor: isStretching ? Colors.green[400] : Colors.red[400],
          fillColor:
              isStretching ? Colors.greenAccent[100]! : Colors.redAccent[100]!,
          fillGradient: null,
          ringColor: Colors.grey[300]!,
          textStyle: TextStyle(
            fontSize: 33.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          onComplete: _timerIterationCompleted,
        ),
      ),
    );
  }
}
