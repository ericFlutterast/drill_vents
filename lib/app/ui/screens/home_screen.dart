import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/navigation/routes.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes().profile);
              },
              child: Text('Press', style: TextStyle()),
            ),
            Text('The brown dog has eaten the frog', style: context.themes.main.texts.h1),
            SizedBox(height: 10),
            Text('The brown dog has eaten the frog', style: context.themes.main.texts.h2),
            SizedBox(height: 10),
            Text('The brown dog has eaten the frog', style: context.themes.main.texts.h3),
            SizedBox(height: 10),
            Text('The brown dog has eaten the frog', style: context.themes.main.texts.body),
            SizedBox(height: 10),
            Text('The brown dog has eaten the frog', style: context.themes.main.texts.bodySmall),
            SizedBox(height: 10),
            Text('The brown dog has eaten the frog', style: context.themes.main.texts.caption),
          ],
        ),
      ),
    );
  }
}
