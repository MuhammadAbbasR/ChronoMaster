import 'dart:async';
import 'package:chronomaster_pro/config/sound_notification/beep_notification.dart';
import 'package:chronomaster_pro/model/workout_step_model.dart';
import 'package:chronomaster_pro/model/workout_template_model.dart';
import 'package:chronomaster_pro/services/hive_services.dart';
import 'package:flutter/material.dart';


class TimeIntervalProvider extends ChangeNotifier {
  BeepNotification p=BeepNotification();
  List<WorkoutTemplate> templateList = [];
  bool loading = false;
  int currentStepIndex = 0;
  int remainingTime = 0;
  int totalSteps = 0;
  bool isRunning = false;
  bool isWorkoutFinished = false;
  Timer? _timer;
  bool _isTransitioning = false;
  List<WorkoutStep> workoutSteps = [];


  Future<void> fetchTemplate() async {
    loading = true;
    notifyListeners();
    templateList = HiveService.getAllTemplates();
    debugPrint(templateList.length.toString());
    loading = false;
    notifyListeners();
  }

  Future<void> addTemplate(WorkoutTemplate template) async {
    await HiveService.addTemplates(template);
    fetchTemplate();
  }

  Future<void> deleteTemplate(WorkoutTemplate template, int index) async {
    final removed = templateList.removeAt(index);
    notifyListeners();

    try {
      await HiveService.deleteTemplate(template);
    } catch (e) {
      templateList.insert(index, removed);
      notifyListeners();
      debugPrint("Delete failed: $e");
    }
  }


  void initializeWorkout(WorkoutTemplate template) {
    _timer?.cancel();
    p.init();
    workoutSteps = template.steps;
    currentStepIndex = 0;
    remainingTime = workoutSteps.first.duration;
    isWorkoutFinished = false;
    isRunning = true;
    _startTimer();
    notifyListeners();
  }

  void _startTimer() async{
    _timer?.cancel();
   // p.playStartBeep();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isRunning) return;

      if(remainingTime==4){
        p.stopPlayer();
        debugPrint("4 second remaining");
        p.playEndBeep();
     // p.playEndBeep();
      }

      if (remainingTime > 0) {
        remainingTime--;
        notifyListeners();
      } else {
        p.stopPlayer();
        _moveToNextStep();
      }
    });
  }

  void _moveToNextStep() {

    if (currentStepIndex < workoutSteps.length - 1) {
      Future.delayed(const Duration(milliseconds: 300));
      p.playStartBeep();
      currentStepIndex++;
      remainingTime = workoutSteps[currentStepIndex].duration;
      notifyListeners();
    } else {
      finishWorkout();
    }
  }

  void pause() {
    isRunning = false;
    notifyListeners();
  }

  void resume() {
    if (isWorkoutFinished) return;
    isRunning = true;
    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    reset();
  }

  void finishWorkout() {
   // p.disposePlayer();
    _timer?.cancel();
    isRunning = false;
    isWorkoutFinished = true;
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
   // p.disposePlayer();
    isRunning = false;
    isWorkoutFinished = false;
    currentStepIndex = 0;
    remainingTime = 0;
    workoutSteps = [];
    notifyListeners();
  }

  @override
  void dispose() {
    p.disposePlayer();
    _timer?.cancel();
    super.dispose();
  }

}
