import 'dart:async';
import 'package:chronomaster_pro/model/workout_step_model.dart';
import 'package:chronomaster_pro/model/workout_template_model.dart';
import 'package:chronomaster_pro/services/hive_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class TimeIntervalProvider  extends ChangeNotifier{

  List<WorkoutTemplate> templateList=[];
  bool loading =false;
  int currentStepIndex=0;
  int remainingTime=0;
  int totalSteps=0;
  bool isRunning=true;
  Timer? _timer;
  bool isWorkoutFinished = false;
  bool _isTransitioning = false;
  List<WorkoutStep> workoutStep=[];
  void fetchTemplate()async{
  loading =true;
 // templateList.clear();
  notifyListeners();
    templateList= HiveService.getAllTemplates();
    loading =false;
    notifyListeners();

  }

  void addTemplate(WorkoutTemplate workoutTemplate)async{
    HiveService.addTemplates(workoutTemplate);
    fetchTemplate();
  }

  void deleteTemplate(WorkoutTemplate workoutTemplate, int index) async {
    templateList.removeAt(index);
    notifyListeners();

    try {
      await HiveService.deleteTemplate(workoutTemplate);
    } catch (e) {

      templateList.insert(index, workoutTemplate);
      notifyListeners();
      if (kDebugMode) {
        print("Failed to delete template: $e");
      }
    }

  }

  void initializeWorkOutStep(WorkoutTemplate workoutstep){
    currentStepIndex=0;
    totalSteps=workoutstep.steps.length;
    workoutStep=workoutstep.steps;
    isWorkoutFinished = false;
    isRunning=true;
    remainingTime=workoutstep.steps[currentStepIndex].duration;
    startTimer();
  }

  void moveNext(){

    if(currentStepIndex<totalSteps-1){
      currentStepIndex++;
      remainingTime=workoutStep[currentStepIndex].duration;
    }
    else {
      finishWorkout();
    }

  }

  void moveBack(){

  }

  void stopTimer(){

    isRunning=false;
    _timer!.cancel();
    resetWorkout();
    notifyListeners();

  }

  void startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_isTransitioning) return;

      remainingTime--;
      notifyListeners();

      if (remainingTime == 0) {
        _handleStepEnd();
      }
    });
  }


  void _handleStepEnd() async {
    _isTransitioning = true;

    _timer?.cancel();

    await Future.delayed(const Duration(milliseconds: 400));

    if (currentStepIndex < totalSteps - 1) {
      currentStepIndex++;
      remainingTime = workoutStep[currentStepIndex].duration;

      _isTransitioning = false;
      startTimer();
    } else {
      finishWorkout();
    }

    notifyListeners();
  }


  void resetWorkout() {
    _timer?.cancel();
    isRunning = false;
    isWorkoutFinished = false;
    currentStepIndex = 0;
    remainingTime = 0;
  }


  void finishWorkout() {
    isRunning = false;
    _timer?.cancel();
    isWorkoutFinished = true;
    notifyListeners();
  }



}