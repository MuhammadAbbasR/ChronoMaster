import 'package:chronomaster_pro/model/session_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String sessionBoxName = 'sessions';
  static Box<SessionModel>? _box;

  /// Call this ONCE at app startup
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters if not registered
    if (!Hive.isAdapterRegistered(SessionModelAdapter().typeId)) {
      Hive.registerAdapter(SessionModelAdapter());
    }

    // Open box if not already open
    if (!Hive.isBoxOpen(sessionBoxName)) {
      _box = await Hive.openBox<SessionModel>(sessionBoxName);
    } else {
      _box = Hive.box<SessionModel>(sessionBoxName);
    }
  }

  /// Get session box anywhere in app
  static Box<SessionModel> get sessionBox {
    if (_box == null || !_box!.isOpen) {
      throw Exception(
          "HiveService not initialized. Call HiveService.init() first.");
    }
    return _box!;
  }

  /// Add a session
  /// If session.id is empty, auto-generate using timestamp
  static Future<void> addSession(SessionModel session) async {
    final id = session.id.isNotEmpty
        ? session.id
        : DateTime.now().millisecondsSinceEpoch.toString();
    await sessionBox.put(id, session);
  }

  /// Get all sessions sorted by date descending
  static List<SessionModel> getAllSessions() {
    return sessionBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Get single session by id
  static SessionModel? getSession(String id) {
    return sessionBox.get(id);
  }

  /// Update session
  static Future<void> updateSession(SessionModel session) async {
    if (session.id.isEmpty) {
      throw Exception("Session id cannot be empty for update");
    }
    await sessionBox.put(session.id, session);
  }

  /// Delete session
  static Future<void> deleteSession(String id) async {
    await sessionBox.delete(id);
  }

  /// Clear all sessions
  static Future<void> clearAllSessions() async {
    await sessionBox.clear();
  }
}
