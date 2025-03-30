import 'package:drill_events/app/blocs/receiving_spots.dart';
import 'package:drill_events/app/features/create_edit_event/validators/event_validators.dart';
import 'package:drill_events/app/features/widgets/app_avatar.dart';
import 'package:drill_events/app/features/widgets/app_notification.dart';
import 'package:drill_events/app/features/widgets/notification_manager.dart';
import 'package:drill_events/app/features/widgets/shimmer.dart';
import 'package:drill_events/app/features/widgets/validation_builder.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpotsTile extends StatefulWidget {
  const SpotsTile._({super.key, required this.validator});

  final Validator<String> validator;

  static Widget bloc(BuildContext context, {Key? key, required Validator<String> validator, required String orgId}) {
    return BlocProvider<ReceivingSpotsBloc>(
      create: (context) {
        return ReceivingSpotsBloc(
          api: context.dependencies.backendApi,
          logger: context.dependencies.logger,
          fileStorage: context.dependencies.fileStorage,
        )..add(GetSpotsEvent(orgId));
      },
      child: SpotsTile._(key: key, validator: validator),
    );
  }

  @override
  State<SpotsTile> createState() => _SpotsTileState();
}

class _SpotsTileState extends State<SpotsTile> {
  int? _selectedIndex;

  void _selectSpot(int index) {
    if (index == _selectedIndex) {
      setState(() => _selectedIndex = null);
      widget.validator.value = null;
      return;
    }
    setState(() => _selectedIndex = index);
    widget.validator.value = context.read<ReceivingSpotsBloc>().state.value.elementAt(index).id;
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;

    return BlocListener<ReceivingSpotsBloc, ReceivingSpotsState>(
      listener: (_, state) {
        if (state.isError) {
          NotificationManager.of(context).showNotification(
            notification: AppNotification(status: NotificationStatus.error, title: state.errorMessage.toString()),
          );
        }
      },
      child: BlocBuilder<ReceivingSpotsBloc, ReceivingSpotsState>(
        builder: (context, state) {
          if (state.isDone && state.hasValue) {
            return ValidationBuilder(
              validator: widget.validator,
              builder: (_, __, widget) => widget!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text('Опубликовать в', style: texts.body.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 24),
                  for (final (index, spot) in state.value.indexed) ...[
                    _Spot(
                      title: spot.title,
                      address: spot.address,
                      onSelect: () => _selectSpot(index),
                      isSelect: _selectedIndex == index || widget.validator.value == spot.id,
                      imageUrl: spot.org.imageUrl,
                    ),
                    if (index != 3) const SizedBox(height: 20),
                  ],
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer(height: 30, width: MediaQuery.sizeOf(context).width * 0.4),
              const SizedBox(height: 24),
              for (int i = 0; i < 5; i++) ...[_Spot.shimmer(), if (i != 4) const SizedBox(height: 20)],
            ],
          );
        },
      ),
    );
  }
}

class _Spot extends StatelessWidget {
  const _Spot({
    required this.onSelect,
    this.isSelect = false,
    required this.title,
    required this.address,
    this.imageUrl,
  });

  final VoidCallback onSelect;
  final bool isSelect;
  final String title;
  final String address;
  final String? imageUrl;

  static Widget shimmer() => const Shimmer(height: 52);

  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppAvatar(imageUrl: imageUrl, size: 52),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: texts.bodySmall.copyWith(fontWeight: FontWeight.w600, height: 1.3)),
              const SizedBox(height: 4),
              Text(address, style: texts.bodySmall),
            ],
          ),
        ),
        _SelectSpotButton(onTap: onSelect, isSelect: isSelect),
      ],
    );
  }
}

class _SelectSpotButton extends StatelessWidget {
  const _SelectSpotButton({required this.onTap, required this.isSelect});

  final VoidCallback onTap;
  final bool isSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;

    return GestureDetector(
      onTap: onTap,
      child:
          isSelect
              ? SizedBox.square(
                dimension: 36,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
                  child: Icon(Icons.check_outlined, color: colors.inverse, size: 18),
                ),
              )
              : SizedBox.square(
                dimension: 36,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                  ),
                ),
              ),
    );
  }
}
