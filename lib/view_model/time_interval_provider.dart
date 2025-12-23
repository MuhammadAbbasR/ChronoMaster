

import 'package:chronomaster_pro/model/workout_template_model.dart';
import 'package:chronomaster_pro/services/hive_services.dart';
import 'package:flutter/material.dart';

class TimeIntervalProvider  extends ChangeNotifier{

  List<WorkoutTemplate> templateList=[];

  void fetchTemplate()async{

    templateList= HiveService.getAllTemplates();
    notifyListeners();

  }


}