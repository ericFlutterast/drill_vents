import 'package:drill_events/app/ui/home/widgets/event_item.dart';
import 'package:drill_events/app/ui/home/widgets/home_header.dart';
import 'package:drill_events/app/ui/home/widgets/soon_events_title.dart';
import 'package:drill_events/common/navigation/routes.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.1)),
            const HomeHeader(),
            const SoonEventsTitle(),
            SliverList.separated(
              itemCount: 10,
              itemBuilder:
                  (context, index) => EventItem(
                    title: 'Present Simple - когда и как использовать?',
                    onTap: () => Navigator.pushNamed(context, Routes.event),
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
