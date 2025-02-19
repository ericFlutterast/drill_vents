import 'package:drill_events/app/blocs/events/bloc.dart';
import 'package:drill_events/app/blocs/events/events.dart';
import 'package:drill_events/app/ui/event/event_screen.dart';
import 'package:drill_events/app/ui/home/home_screen.dart';
import 'package:drill_events/app/ui/profile/profile_screen.dart';
import 'package:drill_events/common/di/inherited_dependencies.dart';
import 'package:drill_events/common/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final dependencies = InheritedDependencies.of(context).dependencies;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.home,
      routes: {
        Routes.home:
            (context) => BlocProvider<EventsBloc>(
              create: (_) => dependencies.eventsBloc..add(FetchEvents()),
              child: const HomeScreen(),
            ),
        Routes.profile: (context) => const ProfileScreen(),
        Routes.event: (context) => const EventScreen(),
      },
    );
  }
}
