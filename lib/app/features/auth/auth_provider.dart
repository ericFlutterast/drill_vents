import 'package:drill_events/app/blocs/auth.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthProvider extends StatelessWidget {
  const AuthProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => BlocProvider<AuthBloc>(
    create:
        (context) => AuthBloc(
          repository: context.dependencies.backendApi,
          secureStorage: context.dependencies.secureStorage,
          logger: context.dependencies.logger,
          fastCache: context.dependencies.fastCache,
          pipe: context.dependencies.pipe,
          fileStorage: context.dependencies.fileStorage,
        )..add(GetUserInfo()),
    child: child,
  );
}
