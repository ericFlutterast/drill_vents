import 'package:drill_events/app/blocs/events/bloc.dart';
import 'package:drill_events/app/blocs/events/events.dart';
import 'package:drill_events/app/ui/widgets/app_text_field.dart';
import 'package:drill_events/app/ui/widgets/profile_progress_indicator.dart';
import 'package:drill_events/common/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AppTextField(
              hintText: 'Поиск...',
              onChanged: (value) {
                if (value.isEmpty) {
                  context.read<EventsBloc>().add(const FetchEvents());
                } else {
                  context.read<EventsBloc>().add(SearchEvents(value: value));
                }
              },
            ),
          ),
          const SizedBox(width: 20),
          ProfileProgressIndicator(
            onTap: () => Navigator.pushNamed(context, Routes.profile),
            child: const SizedBox(
              height: 38,
              width: 38,
              child: DecoratedBox(decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle)),
            ),
            // TODO: вернуть, ошибка заебала просто))))
            // CachedNetworkImage(
            //   imageUrl: '',
            //   errorWidget:
            //       (_, __, ___) => const SizedBox(
            //         height: 38,
            //         width: 38,
            //         child: DecoratedBox(decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle)),
            //       ),
            // ),
          ),
        ],
      ),
    );
  }
}
