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
  Timer? timer;
  List<WorkoutStep> _workoutStep=[];
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
    _workoutStep=workoutstep.steps;
    isRunning=true;
    remainingTime=workoutstep.steps[currentStepIndex].duration;
    startTimer();
  }


  void moveNext(){

    if(currentStepIndex>totalSteps){
      currentStepIndex++;
      remainingTime=_workoutStep[currentStepIndex].duration;
    }


  }

  void moveBack(){

  }

  void stopTimer(){

    isRunning=false;
    timer!.cancel();
    notifyListeners();

  }

  void startTimer(){

    Timer.periodic(const Duration(seconds: 1), (timer){
      if(remainingTime>0){
        remainingTime--;
      }{
        moveNext();
      }
    });

  }

}