import 'package:drill_events/app/ui/home/widgets/event_item.dart';
import 'package:drill_events/app/ui/home/widgets/home_header.dart';
import 'package:drill_events/app/ui/home/widgets/soon_events_title.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverPadding(padding: EdgeInsets.only(top: 30)),
            const HomeHeader(),
            const SoonEventsTitle(),
            SliverList.separated(
              itemCount: 10,
              itemBuilder:
                  (context, index) => EventItem(
                    title: 'Present Simple - когда и как использовать?',
                    onTap: () {
                      print('hi: $index');
                    },
                  ),
              separatorBuilder: (_, __) => const SizedBox(height: 28),
            ),
            const SliverPadding(padding: EdgeInsets.only(top: 30)),
          ],
        ),
      ),
    );
  }
}
