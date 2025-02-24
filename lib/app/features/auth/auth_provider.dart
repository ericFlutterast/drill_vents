import 'package:drill_events/app/blocs/auth/bloc.dart';
import 'package:drill_events/app/blocs/auth/events.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthProvider extends StatelessWidget {
  const AuthProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => context.dependencies.authBloc..add(GetJwtTokenEvent()),
      child: child,
    );
  }
}
