import 'package:chronomaster_pro/services/hive_services.dart';
import 'package:chronomaster_pro/view_model/lap_provider.dart';
import 'package:chronomaster_pro/view_model/time_interval_provider.dart';
import 'package:chronomaster_pro/views/interval_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main()async{

  await HiveService.init();

  runApp(

    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LapProvider()),
        ChangeNotifierProvider(create: (_) =>  TimeIntervalProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      home: IntervalMainScreen(),
    );
  }

}
