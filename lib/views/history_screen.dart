
import 'package:chronomaster_pro/services/hive_services.dart';
import 'package:chronomaster_pro/view_model/lap_provider.dart';
import 'package:chronomaster_pro/views/session_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:intl/intl.dart'; // For formatting dates

class Session {
  final String id;
  final String title;
  final String duration;
  final DateTime date;

  Session({
    required this.id,
    required this.title,
    required this.duration,
    required this.date,
  });
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LapProvider>(context, listen: false).getAllSessions();
    });
  }

  // Dummy session data
  List<Session> sessions = [
    Session(id: '1', title: 'Morning Run', duration: '30 min', date: DateTime(2025, 12, 15)),
    Session(id: '2', title: 'Evening Yoga', duration: '45 min', date: DateTime(2025, 12, 14)),
    Session(id: '3', title: 'Cycling', duration: '60 min', date: DateTime(2025, 12, 13)),
    Session(id: '4', title: 'HIIT Workout', duration: '20 min', date: DateTime(2025, 12, 12)),
    Session(id: '5', title: 'Swimming', duration: '50 min', date: DateTime(2025, 12, 11)),
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Filtered sessions based on search
   final providerVm=Provider.of<LapProvider>(context);

   final filteredSessions = providerVm.list.where((session) {
     return session.id
         .toLowerCase()
         .contains(searchQuery.toLowerCase());
   }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search sessions...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          // Session List

          Expanded(
            child: providerVm.list.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.history, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No sessions found!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: providerVm.list.length,
              itemBuilder: (context, index) {
                final session = providerVm.list[index];
                return Dismissible(
                  key: Key(session.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) async {
                    await HiveService.deleteSession(session.id);
                    providerVm.getAllSessions(); // refresh list
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Session deleted')),
                    );
                  },
                  child: Card(
                    margin:  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                      ),
                      title: Text(session.id ?? 'Session'), // if you added title
               //       subtitle: Text(
               //           'Duration: ${session.totalMilliseconds}:${(session.totalMilliseconds % 60000) ~/ 1000}'),
                      trailing:  Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SessionDetailScreen(sessionModel: session,),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          )

        ],
      ),
    );
  }
}

