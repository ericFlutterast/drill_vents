import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/blocs/events/bloc.dart';
import 'package:drill_events/app/models/event_model.dart';
import 'package:drill_events/app/themes/app_themes.dart';
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
        child: BlocBuilder<EventsBloc, CommonBlocState<Iterable<EventModel>>>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
                const HomeHeader(),
                Expanded(
                  child: RefreshIndicator.adaptive(
                    onRefresh: () async {
                      //TODO:
                    },
                    child: CustomScrollView(
                      slivers: [
                        const SoonEventsTitle(),
                        if (state.isLoading)
                          SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.17),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  backgroundColor: context.themes.main.colors.background,
                                  color: context.themes.main.colors.accent,
                                ),
                              ),
                            ),
                          )
                        else if (state.hasValue)
                          SliverList.separated(
                            itemCount: state.value.length,
                            itemBuilder:
                                (context, index) => EventListItem(
                                  title: state.value.elementAt(index).title,
                                  onTap: () => Navigator.pushNamed(context, Routes.event),
                                ),
                            separatorBuilder: (_, __) => const SizedBox(height: 28),
                          ),
                        const SliverPadding(padding: EdgeInsets.only(top: 30)),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
