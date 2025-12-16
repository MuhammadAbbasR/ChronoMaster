

import 'dart:async';
import 'dart:js_interop';


import 'package:chronomaster_pro/model/session_model.dart';
import 'package:chronomaster_pro/services/hive_services.dart';
import 'package:flutter/material.dart';


class LapProvider extends ChangeNotifier{

  Stopwatch _stopwatch = Stopwatch();
  Stopwatch _currectLapWatch=Stopwatch();
  Timer? _timer ;
  String total_Time="0";
  bool race_finished=true;
  List<SessionModel> list=[];
  List<String> laps=[];
  bool get isRunning => _stopwatch.isRunning;
  String get formattedTime {
    final ms = _stopwatch.elapsedMilliseconds;
    final minutes = (ms ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((ms % 60000) ~/ 1000).toString().padLeft(2, '0');
    final milliseconds = (ms % 1000).toString().padLeft(3, '0');
    return "$minutes:$seconds.$milliseconds";
  }
  String get currentLapformattedTime{
    final ms = _currectLapWatch.elapsedMilliseconds;
    final minutes = (ms ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((ms % 60000) ~/ 1000).toString().padLeft(2, '0');
    final milliseconds = (ms % 1000).toString().padLeft(3, '0');
    return "$minutes:$seconds.$milliseconds";
  }

  void startTimer(){

    race_finished=false;
    _stopwatch.start();
    _currectLapWatch.start();
    laps.clear();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      notifyListeners();
    });

  }

  void stopTimer(){
    laps.add(currentLapformattedTime);
    _stopwatch.stop();
    _currectLapWatch.stop();
    _timer?.cancel();
    race_finished=true;
    total_Time=formattedTime;
    _stopwatch.reset();
    _currectLapWatch.reset();
    notifyListeners();

  }

  void pauseTimer(){

  _stopwatch.stop();
  _currectLapWatch.stop();
  _timer?.cancel();
  notifyListeners();

  }

  void newLap(){

    laps.add(currentLapformattedTime);
    _currectLapWatch.reset();
    _currectLapWatch.start();
    notifyListeners();

  }

  void resetLap(){

    _currectLapWatch.reset();
    _stopwatch.reset();
    laps.clear();
    total_Time="0";
    notifyListeners();

  }

  Future<void> saveSession({required String name}) async {
    final id = DateTime.now().toString();
    final session = SessionModel(
      id: id,
      date: DateTime.now(),
      totalMilliseconds: formattedTime,
      laps: laps,
    //  title: name,
    );
    await HiveService.addSession(session);
    getAllSessions();
  }

  void getAllSessions() {
    list = HiveService.getAllSessions();
    notifyListeners();
  }

}
