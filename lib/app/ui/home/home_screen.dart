import 'package:drill_events/app/blocs/events.dart';
import 'package:drill_events/app/ui/home/widgets/home_header.dart';
import 'package:drill_events/app/ui/home/widgets/soon_events_title.dart';
import 'package:drill_events/app/ui/widgets/event_list_item.dart';
import 'package:drill_events/common/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverPadding(padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.1)),
                const HomeHeader(),
                const SoonEventsTitle(),
                SliverList.separated(
                  itemCount: state.events.length,
                  itemBuilder:
                      (context, index) => EventListItem(
                        title: state.events.elementAt(index).title,
                        onTap: () => Navigator.pushNamed(context, Routes.event),
                      ),
                  separatorBuilder: (_, __) => const SizedBox(height: 28),
                ),
                const SliverPadding(padding: EdgeInsets.only(top: 30)),
              ],
            );
          },
        ),
      ),
    );
  }
}
