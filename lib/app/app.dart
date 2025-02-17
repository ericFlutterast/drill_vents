import 'package:drill_events/app/ui/screens/home_screen.dart';
import 'package:drill_events/app/ui/screens/profile_screen.dart';
import 'package:drill_events/common/navigation/routes.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes().home,
      routes: {Routes().home: (context) => HomeScreen(), Routes().profile: (context) => ProfileScreen()},
    );
  }
}
