import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PomodoroApp(),
    );
  }
}

class PomodoroApp extends StatefulWidget {
  const PomodoroApp({super.key});

  @override
  State<PomodoroApp> createState() => _PomodoroAppState();
}

class _PomodoroAppState extends State<PomodoroApp> {
  Timer? repeatedFunction;
  Duration duration = const Duration(minutes: 25);
  bool isRunning = false;

  startTimer() {
    repeatedFunction = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        int newSec = duration.inSeconds - 1;
        duration = Duration(seconds: newSec);
        if (duration.inSeconds == 0) {
          repeatedFunction!.cancel();
          duration = const Duration(minutes: 25);
          isRunning = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 40, 43),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 50, 65, 71),
        title: const Text(
          "Pomodoro App",
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 130,
              lineWidth: 8.0,
              percent: duration.inMinutes / 25,
              animation: true,
              animateFromLastPercent: true,
              animationDuration: 1000,
              center: Text(
                  "${duration.inMinutes.toString().padLeft(2, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}",
                  style: const TextStyle(fontSize: 80, color: Colors.white)),
            ),
            const SizedBox(height: 50),
            isRunning
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: repeatedFunction!.isActive
                                ? MaterialStateProperty.all(Colors.red)
                                : MaterialStateProperty.all(Colors.blue),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(15)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        onPressed: () {
                          setState(() {
                            if (repeatedFunction!.isActive) {
                              repeatedFunction!.cancel();
                            } else {
                              startTimer();
                            }
                          });
                        },
                        child: Text(
                            repeatedFunction!.isActive ? "STOP" : "Resume",
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white)),
                      ),
                      const SizedBox(width: 30),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(15)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        onPressed: () {
                          repeatedFunction!.cancel();
                          setState(() {
                            duration = const Duration(minutes: 25);
                            isRunning = false;
                          });
                        },
                        child: const Text("Cancel",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ],
                  )
                : ElevatedButton(
                    style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(15)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                    onPressed: () {
                      startTimer();
                      setState(() {
                        isRunning = true;
                      });
                    },
                    child: const Text("Start Timer",
                        style: TextStyle(fontSize: 23, color: Colors.white)),
                  )
          ],
        ),
      ),
    );
  }
}
