import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:stretch_timer/model/CountDownInfo.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class CountdownScreen extends StatefulWidget {
  static const routeName = 'countdown';

  const CountdownScreen({super.key});

  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  final _controller = CountDownController();
  bool unmuted = true;
  CountDownInfo? timerInfo;
  bool isStretching = false;
  int iterationCount = 1;
  final player = AudioPlayer();

  @override
  void initState() {
    WakelockPlus.enable();
    super.initState();
  }

  @override
  void deactivate() {
    WakelockPlus.disable();
    super.deactivate();
  }

  void _timerIterationCompleted() async {
    if (unmuted) {
      if (isStretching && iterationCount == timerInfo!.intervalCount) {
        await player.play(AssetSource('applause.mp3'));
      } else if (isStretching) {
        await player.play(AssetSource('notification.mp3'));
      } else {
        await player.play(AssetSource('buzzer.wav'));
      }
    }

    if (isStretching) {
      iterationCount++;
      if (iterationCount > timerInfo!.intervalCount) {
        Navigator.of(context).pop();
        return;
      }
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
      body: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(""),
              ),
              IconButton(
                  onPressed: () => setState(() => unmuted = !unmuted),
                  icon: Icon(unmuted ? Icons.volume_up : Icons.volume_off))
            ],
          ),
          Text(
            "$iterationCount / ${timerInfo!.intervalCount}",
            style: const TextStyle(fontSize: 25),
          ),
          Text(
              !isStretching && iterationCount == 1
                  ? "Get Ready"
                  : isStretching
                      ? "Stretch"
                      : "Rest",
              style: const TextStyle(fontSize: 30)),
          Center(
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
              backgroundColor:
                  isStretching ? Colors.green[400] : Colors.red[400],
              fillColor: isStretching
                  ? Colors.greenAccent[100]!
                  : Colors.redAccent[100]!,
              fillGradient: null,
              ringColor: Colors.grey[300]!,
              textStyle: const TextStyle(
                fontSize: 33.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              onComplete: _timerIterationCompleted,
            ),
          ),
          ValueListenableBuilder(
              valueListenable: _controller.isPaused,
              builder: (context, isPaused, child) {
                return Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                          onPressed:
                              isPaused ? null : () => _controller.pause(),
                          child: const Text("Pause")),
                      ElevatedButton(
                          onPressed:
                              !isPaused ? null : () => _controller.resume(),
                          child: const Text("Resume")),
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }
}
