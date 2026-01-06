import 'package:chronomaster_pro/config/dummy_data/beginner_run.dart';
import 'package:chronomaster_pro/config/dummy_data/sprint_run.dart';
import 'package:chronomaster_pro/config/dummy_data/stretch_run.dart';
import 'package:chronomaster_pro/model/session_model.dart';
import 'package:chronomaster_pro/model/workout_step_model.dart';
import 'package:chronomaster_pro/model/workout_template_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {

  static const String sessionBoxName = 'sessions';
  static const String templateBoxName = 'workout_templates';
  static Box<SessionModel>? _sessionBox;
  static Box<WorkoutTemplate>? _templateBox;

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(SessionModelAdapter().typeId)) {
      Hive.registerAdapter(SessionModelAdapter());
    }

    if (!Hive.isAdapterRegistered(WorkoutStepAdapter().typeId)) {
      Hive.registerAdapter(WorkoutStepAdapter());
    }

    if (!Hive.isAdapterRegistered(WorkoutTemplateAdapter().typeId)) {
      Hive.registerAdapter(WorkoutTemplateAdapter());
    }

    _sessionBox = await Hive.openBox<SessionModel>(sessionBoxName);
    _templateBox = await Hive.openBox<WorkoutTemplate>(templateBoxName);
  }

  static Box<SessionModel> get sessionBox {
    if (_sessionBox == null || !_sessionBox!.isOpen) {
      throw Exception(
        "Session box not initialized. Call HiveService.init() first.",
      );
    }
    return _sessionBox!;
  }

  static Box<WorkoutTemplate> get templateBox {
    if (_templateBox == null || !_templateBox!.isOpen) {
      throw Exception(
        "Template box not initialized. Call HiveService.init() first.",
      );
    }
    return _templateBox!;
  }

  static Future<void> addSession(SessionModel session) async {
    final id = session.id.isNotEmpty ? session.id : DateTime.now().millisecondsSinceEpoch.toString();
    await sessionBox.put(id, session);
  }

  static List<SessionModel> getAllSessions() {
    return sessionBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static SessionModel? getSession(String id) {
    return sessionBox.get(id);
  }

  static Future<void> updateSession(SessionModel session) async {
    if (session.id.isEmpty) {
      throw Exception("Session id cannot be empty for update");
    }
    await sessionBox.put(session.id, session);
  }

  static Future<void> deleteSession(String id) async {
    await sessionBox.delete(id);
  }

  static Future<void> clearAllSessions() async {
    await sessionBox.clear();
  }

  static List<WorkoutTemplate> getAllTemplates(){
    final box = HiveService.templateBox;

    if (box.isEmpty) {
      box.addAll([
        beginnerRunTemplate,
        hiitSprintTemplate,
        recoveryTemplate,
      ]);
    }
    return  _templateBox!.values.toList();
  }

  static Future<void> addTemplates(WorkoutTemplate workoutTemplate)async{

    if(workoutTemplate!=null){
     await _templateBox!.put(workoutTemplate.id,workoutTemplate);
    }
  }

  static Future<void> deleteTemplate(WorkoutTemplate workoutTemplate)async{

    try{
      debugPrint("Template is being deleted");
      await _templateBox!.delete(workoutTemplate.id);
    }
    catch(e){
      debugPrint(e.toString());
    }

  }

  static Future<void> updateTemplate(int id, WorkoutTemplate workoutTemplate)async{
    await _templateBox!.putAt(id, workoutTemplate);
  }

}
