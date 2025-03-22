import 'package:drill_events/app/blocs/auth.dart';
import 'package:drill_events/app/blocs/home_bloc.dart';
import 'package:drill_events/app/features/auth/auth_provider.dart';
import 'package:drill_events/app/features/auth/auth_screen.dart';
import 'package:drill_events/app/features/create_edit_event/create_event_screen.dart';
import 'package:drill_events/app/features/create_edit_event/edit_event_screen.dart';
import 'package:drill_events/app/features/event/evenet_admin/event_admin_screen.dart';
import 'package:drill_events/app/features/event/evetn_user/event_screen.dart';
import 'package:drill_events/app/features/home/home_screen.dart';
import 'package:drill_events/app/features/org/org_screen.dart';
import 'package:drill_events/app/features/profile/profile_screen.dart';
import 'package:drill_events/app/features/spot/spot_screen.dart';
import 'package:drill_events/app/features/widgets/notification_manager.dart';
import 'package:drill_events/common/navigation/routes.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'features/event/event_screen_args.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveFormConfig(
      validationMessages: {
        ValidationMessage.email: (_) => 'Неверный email',
        ValidationMessage.required: (_) => 'Обязательное поле',
        ValidationMessage.number: (_) => 'Необходимо ввести число',
        ValidationMessage.minLength: (value) => 'Минимальная длина ${(value as Map)['requiredLength']}',
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.home,
        builder: (context, widget) => AuthProvider(child: NotificationManager(child: widget!)),
        routes: {
          Routes.home:
              (context) => BlocProvider<EventsBloc>(
                create: (_) => context.dependencies.eventsBloc..add(FetchEventsFeed()),
                child: const HomeScreen(),
              ),
          Routes.auth: (context) => const AuthScreen(),
          Routes.profile: (context) {
            final authState = context.read<AuthBloc>().state;
            if (authState.hasValue) {
              return ProfileScreen.bloc(context);
            }
            return const AuthScreen();
          },
          Routes.event: (context) {
            final orgId = context.getArgs<EventScreenArgs>().orgId ?? '';
            final isAdmin = context.read<AuthBloc>().state.getValueOrNull?.isAdmin(orgId);
            if (isAdmin == true) return EventAdminScreen.bloc(context);
            return EventScreen.bloc(context);
          },
          Routes.spot: (context) => SpotScreen.bloc(context),
          Routes.org: (context) => OrgScreen.bloc(context),
          Routes.createEvent: (context) => CreateEventScreen.bloc(context),
          Routes.editEvent: (context) => EditEventScreen.bloc(context),
        },
      ),
    );
  }
}
