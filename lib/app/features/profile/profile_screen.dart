import 'package:cached_network_image/cached_network_image.dart';
import 'package:drill_events/app/blocs/auth.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/blocs/profile_bloc.dart';
import 'package:drill_events/app/features/profile/widgets/editing_profile_modal.dart';
import 'package:drill_events/app/features/widgets/app_avatar.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/app_icon_button.dart';
import 'package:drill_events/app/features/widgets/app_notification.dart';
import 'package:drill_events/app/features/widgets/circle_avatar_decoration.dart';
import 'package:drill_events/app/features/widgets/event_status_label.dart';
import 'package:drill_events/app/features/widgets/interpunct.dart';
import 'package:drill_events/app/features/widgets/notification_manager.dart';
import 'package:drill_events/app/features/widgets/screen_header.dart';
import 'package:drill_events/app/features/widgets/shimmer.dart';
import 'package:drill_events/app/generated/assets.gen.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen._();

  static Widget bloc(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ProfileBloc(
            imagePicker: context.dependencies.imagePicker,
            logger: context.dependencies.logger,
            repository: context.dependencies.backendApi,
            pipe: context.dependencies.pipe,
            fileStorage: context.dependencies.fileStorage,
          )..add(UserEventsReceivingEvent()),
      child: const ProfileScreen._(),
    );
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;
    final textsStyles = context.themes.main.texts;

    return Scaffold(
      backgroundColor: colors.inverse,
      body: SafeArea(
        top: false,
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.isIdle && !state.hasValue) {
              context.pop();
            }
          },
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state.isError) {
                NotificationManager.of(context).showNotification(
                  notification: AppNotification(
                    status: NotificationStatus.error,
                    message: state.errorMessage.toString(),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state.isPending) {
                return shimmer(context);
              }

              return Stack(
                children: [
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverPadding(padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.1)),
                      SliverToBoxAdapter(child: _ProfileHeader(imagePath: state.getValueOrNull?.userAvatar)),
                      const SliverPadding(padding: EdgeInsets.only(top: 10)),
                      const SliverToBoxAdapter(child: _UserInfo()),
                      const SliverPadding(padding: EdgeInsets.only(top: 26)),
                      const _LogoutButton(),
                      const SliverPadding(padding: EdgeInsets.only(top: 35)),

                      if (state.isDone && state.hasValue && state.value.organization.isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 28),
                            child: Text('Организации', style: textsStyles.body),
                          ),
                        ),
                        const SliverPadding(padding: EdgeInsets.only(top: 16)),
                        SliverList.separated(
                          itemCount: state.value.organization.length,
                          itemBuilder: (context, index) {
                            final item = state.value.organization.elementAt(index);

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: _OrgListItem(
                                title: item.title,
                                onTap: () => context.openOrgScreen(item.id),
                                eventItem: item.eventsCount,
                                imageUrl: item.imageUrl,
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => const SizedBox(height: 28),
                        ),
                        const SliverPadding(padding: EdgeInsets.only(top: 42)),
                      ],

                      if (state.isDone && state.hasValue && state.value.events.isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 28),
                            child: Text('Записи', style: textsStyles.body),
                          ),
                        ),
                        const SliverPadding(padding: EdgeInsets.only(top: 16)),
                        SliverList.separated(
                          itemCount: state.value.events.length,
                          itemBuilder: (context, index) {
                            final item = state.value.events.elementAt(index);

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: _EventListItem(
                                title: item.title,
                                bookingModel: item.booking ?? (throw 'Никогда не null'),
                                onTap: () => context.openEventScreen(eventID: item.id, orgId: item.org.id),
                                startDate: item.startDate,
                                startTime: item.startTime,
                                availableSeats: item.availableSeats,
                                imgUrl: item.org.imageUrl,
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => const SizedBox(height: 28),
                        ),
                      ],

                      const SliverPadding(padding: EdgeInsets.only(top: 30)),
                    ],
                  ),
                  PositionedScreenHeader(
                    controller: _scrollController,
                    actions: [
                      AppIconButton(
                        icon: CupertinoIcons.pencil,
                        dimension: 38,
                        onTap:
                            () => context.openBottomSheet(
                              EditingProfileModal.blocValue(
                                context,
                                authBloc: context.read<AuthBloc>(),
                                profileBloc: context.read<ProfileBloc>(),
                              ),
                            ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  static Widget shimmer(BuildContext context) => SingleChildScrollView(
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
        Center(child: _ProfileHeader.shimmer()),
        const SizedBox(height: 15),
        Center(child: Shimmer(height: 24, width: MediaQuery.sizeOf(context).width * 0.35)),
        const SizedBox(height: 10),
        Center(child: _UserInfo.shimmer(context)),
        const SizedBox(height: 45),
        Shimmer(height: 16, width: MediaQuery.sizeOf(context).width * 0.35),
        const SizedBox(height: 16),
        for (int i = 0; i < 5; i++) ...[_EventListItem.shimmer(context), const SizedBox(height: 28)],
      ],
    ),
  );
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;

    return GestureDetector(
      onTap: () {
        final userId = context.read<AuthBloc>().state.value.id;
        context.read<ProfileBloc>().add(SelectProfileAvatarEvent(userId));
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final avatar = imagePath ?? state.getValueOrNull?.userAvatar;
          if (state.isDone || state.isIdle && state.hasValue) {
            return Center(
              child: CircleAvatarDecoration(
                diameter: 100,
                strokeWidth: 7,
                child:
                    avatar != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: SizedBox.square(
                            dimension: 85,
                            child: CachedNetworkImage(imageUrl: avatar, fit: BoxFit.fill),
                          ),
                        )
                        : SizedBox.square(dimension: 85, child: Icon(Icons.person, size: 60, color: colors.secondary)),
              ),
            );
          }
          return Center(child: _ProfileHeader.shimmer());
        },
      ),
    );
  }

  static Widget shimmer() => const Shimmer(height: 80, width: 80, borderRadius: 100);
}

class _UserInfo extends StatelessWidget {
  const _UserInfo();

  @override
  Widget build(BuildContext context) {
    final textStyles = context.themes.main.texts;

    return BlocBuilder<AuthBloc, CommonBlocState<UserModel>>(
      builder: (BuildContext context, state) {
        if (state.hasValue) {
          final user = state.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (user.info.name case String name) ...[Text(name, style: textStyles.h3), const SizedBox(height: 5)],
              if (user.info.phone != null && user.info.phone!.isNotEmpty) ...[
                Text(user.info.phone!, style: textStyles.bodySmall),
                const SizedBox(height: 5),
              ],
              Text(user.email, style: textStyles.bodySmall),
              if (user.info.whatsapp != null && user.info.whatsapp!.isNotEmpty) ...[
                const SizedBox(height: 5),
                Text('whatsapp: ${user.info.whatsapp}', style: textStyles.bodySmall),
              ],
              if (user.info.vk != null && user.info.vk!.isNotEmpty) ...[
                const SizedBox(height: 5),
                Text('vk: ${user.info.vk}', style: textStyles.bodySmall),
              ],
              if (user.info.telegram != null && user.info.telegram!.isNotEmpty) ...[
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.icons.telegram.svg(),
                    const SizedBox(width: 8),
                    Text('t.me/${user.info.telegram}', style: textStyles.bodySmall),
                  ],
                ),
              ],
            ],
          );
        }
        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }

  static Widget shimmer(BuildContext context) => Column(
    children: [
      Shimmer(height: 16, width: MediaQuery.sizeOf(context).width / 2),
      const SizedBox(height: 8),
      Shimmer(height: 16, width: MediaQuery.sizeOf(context).width / 2),
      const SizedBox(height: 8),
      Shimmer(height: 16, width: MediaQuery.sizeOf(context).width / 2),
    ],
  );
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 115),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.isPending) {
              return const AppButton.loading(title: 'Выйти');
            }
            return AppButton.secondary(onTap: () => _LogoutDialog.show<bool>(context), title: 'Выйти');
          },
        ),
      ),
    );
  }
}

class _LogoutDialog extends StatelessWidget {
  const _LogoutDialog();

  static Future<T?> show<T>(BuildContext context) {
    return showDialog<T>(context: context, builder: (context) => const _LogoutDialog());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;
    final texts = context.themes.main.texts;

    return Dialog(
      backgroundColor: colors.inverse,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Вы действительно хотите выйти?', style: texts.h3),
            const SizedBox(height: 30),
            AppButton.primary(title: 'Остаться', onTap: () => context.pop()),
            const SizedBox(height: 10),
            AppButton.custom(
              title: 'Выйти',
              onTap: () {
                context.read<AuthBloc>().add(Logout());
                context.pop();
              },
              backgroundColor: colors.error200,
              splashColor: colors.error200.withValues(green: 100, blue: 100),
              highlightColor: colors.error200.withValues(green: 100, blue: 100),
              titleStyle: texts.body.copyWith(color: colors.error600),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrgListItem extends StatelessWidget {
  const _OrgListItem({required this.title, this.onTap, required this.eventItem, this.imageUrl});

  final String title;
  final int eventItem;
  final VoidCallback? onTap;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppAvatar(imageUrl: imageUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.themes.main.texts.body.copyWith(fontWeight: FontWeight.w600, height: 1.3)),
                const SizedBox(height: 8),
                Text('$eventItem событий', style: context.themes.main.texts.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventListItem extends StatelessWidget {
  const _EventListItem({
    required this.startDate,
    required this.startTime,
    required this.title,
    required this.availableSeats,
    this.imgUrl,
    this.onTap,
    this.bookingModel,
  });

  final String title;
  final String? imgUrl;
  final VoidCallback? onTap;
  final ShortBookingModel? bookingModel;
  final DateTime startTime;
  final DateTime startDate;
  final int availableSeats;

  EventStatus get _eventStatus {
    if (bookingModel?.approved == null) return EventStatus.processing;
    return bookingModel?.approved == true ? EventStatus.success : EventStatus.decline;
  }

  String get _time => DateFormat('HH:mm').format(startTime);

  String get _date => DateFormat('dd MMMM').format(startDate);

  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;
    final colors = context.themes.main.colors;

    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppAvatar(imageUrl: imgUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (bookingModel != null) ...[EventStatusLabel(status: _eventStatus), const SizedBox(height: 4)],
                Text(title, style: context.themes.main.texts.body.copyWith(fontWeight: FontWeight.w600, height: 1.3)),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (startDate.difference(DateTime.now()) < const Duration(days: 1))
                      Text('Завтра', style: texts.bodySmall)
                    else
                      Text(_date, style: texts.bodySmall),
                    const SizedBox(width: 8),
                    const Interpunct(),
                    const SizedBox(width: 8),
                    Text(_time, style: texts.bodySmall),
                    const Spacer(),
                    if (availableSeats <= 0) Text('Мест нет', style: texts.bodySmall.copyWith(color: colors.secondary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget shimmer(BuildContext context) => Row(
    children: [
      const Shimmer(height: 52, width: 52, borderRadius: 100),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Shimmer(height: 23, borderRadius: 6),
            const SizedBox(height: 4),
            Shimmer(height: 23, width: MediaQuery.sizeOf(context).width * 0.3, borderRadius: 6),
          ],
        ),
      ),
      const SizedBox(width: 40),
    ],
  );
}
