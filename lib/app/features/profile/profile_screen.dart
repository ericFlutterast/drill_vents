import 'package:cached_network_image/cached_network_image.dart';
import 'package:drill_events/app/blocs/auth.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/blocs/profile_bloc.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/app_icon_button.dart';
import 'package:drill_events/app/features/widgets/app_text_field.dart';
import 'package:drill_events/app/features/widgets/circle_avatar_decoration.dart';
import 'package:drill_events/app/features/widgets/screen_header.dart';
import 'package:drill_events/app/features/widgets/shimmer.dart';
import 'package:drill_events/app/generated/assets.gen.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen._();

  static Widget bloc(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ProfileBloc(
            logger: context.dependencies.logger,
            repository: context.dependencies.backendApi,
            pipe: context.dependencies.pipe,
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
          child: BlocBuilder<ProfileBloc, ProfileState>(
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
                      const SliverToBoxAdapter(child: _ProfileHeader()),
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
                            final item = state.value.events.elementAt(index);

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: _OrgListItem(title: item.title, onTap: () {}),
                            );
                          },
                          separatorBuilder: (_, __) => const SizedBox(height: 28),
                        ),
                      ],
                      const SliverPadding(padding: EdgeInsets.only(top: 42)),
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
                              child: _EventListItem(title: item.title),
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
                    onTapLogo: () => context.openOrgScreen("7fdb5b3d-9de4-4dbb-a862-1a430feeb7fa"),
                    trailing: AppIconButton(
                      icon: CupertinoIcons.pencil,
                      onTap:
                          () => context.openBottomSheet(
                            _EditingProfileModal.blocValue(
                              context,
                              authBloc: context.read<AuthBloc>(),
                              profileBloc: context.read<ProfileBloc>(),
                            ),
                          ),
                    ),
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
        for (int i = 0; i < 5; i++) ...[_EventListItem.shimmer(), const SizedBox(height: 28)],
      ],
    ),
  );
}

class _OrgListItem extends StatelessWidget {
  const _OrgListItem({required this.title, this.onTap});

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: '',
            errorWidget:
                (_, __, ___) => Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(color: context.themes.main.colors.secondary, shape: BoxShape.circle),
                ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.themes.main.texts.body.copyWith(fontWeight: FontWeight.w600, height: 1.3)),
                const SizedBox(height: 8),
                Text('60 событий', style: context.themes.main.texts.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatarDecoration(
        diameter: 100,
        strokeWidth: 7,
        onTap: () {},
        child: Container(
          height: 80,
          width: 80,
          decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
        ),
      ),
    );
  }

  static Widget shimmer() => const Shimmer(height: 80, width: 80, borderRadius: 100);
}

//TODO: Сделать валидацию
class _EditingProfileModal extends StatefulWidget {
  const _EditingProfileModal._();

  static Widget blocValue(BuildContext context, {required AuthBloc authBloc, required ProfileBloc profileBloc}) {
    return MultiBlocProvider(
      providers: [BlocProvider<AuthBloc>.value(value: authBloc), BlocProvider<ProfileBloc>.value(value: profileBloc)],
      child: const _EditingProfileModal._(),
    );
  }

  @override
  State<_EditingProfileModal> createState() => _EditingProfileModalState();
}

class _EditingProfileModalState extends State<_EditingProfileModal> {
  late final _nameController = TextEditingController();
  late final _mailController = TextEditingController();
  late final _phoneController = TextEditingController();
  late final _telegramController = TextEditingController();
  late final _whatsAppController = TextEditingController();
  late final _vkController = TextEditingController();

  late final _phoneFocusNode = FocusNode();
  late final _whatsappFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthBloc>().state.value;
    _nameController.text = user.info.name ?? '';
    _mailController.text = user.email;
    _phoneController.text = user.info.phone ?? '';
    _telegramController.text = user.info.telegram ?? '';
    _whatsAppController.text = user.info.whatsapp ?? '';
    _vkController.text = user.info.vk ?? '';

    _phoneFocusNode.addListener(() {
      if (!_phoneFocusNode.hasFocus) {
        context.read<ProfileBloc>().add(UpdateProfileInfoEvent(phone: _phoneController.text));
      }
    });
    _whatsappFocusNode.addListener(() {
      if (!_whatsappFocusNode.hasFocus) {
        context.read<ProfileBloc>().add(UpdateProfileInfoEvent(whatsapp: _whatsAppController.text));
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mailController.dispose();
    _phoneController.dispose();
    _telegramController.dispose();
    _whatsAppController.dispose();
    _vkController.dispose();
    _phoneFocusNode.dispose();
    _whatsappFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(padding: const EdgeInsets.only(left: 8), child: Text('Контактные данные', style: texts.h3)),
          const SizedBox(height: 32),
          AppTextField(
            controller: _nameController,
            hintText: 'Имя',
            keyboardType: TextInputType.name,
            maxLines: 1,
            onEditingComplete: () {
              context.read<ProfileBloc>().add(UpdateProfileInfoEvent(name: _nameController.text));
            },
          ),
          const SizedBox(height: 8),
          AppTextField(
            controller: _mailController,
            hintText: 'Эл. почта',
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
            onEditingComplete: () {
              context.read<ProfileBloc>().add(UpdateProfileInfoEvent(email: _mailController.text));
            },
          ),
          const SizedBox(height: 8),
          AppTextField(
            focusNode: _phoneFocusNode,
            controller: _phoneController,
            hintText: '+7777777777 (номер)',
            keyboardType: TextInputType.phone,
            maxLines: 1,
            inputFormatters: [_PhoneNumberFormatter()],
          ),
          const SizedBox(height: 8),
          AppTextField(
            controller: _telegramController,
            hintText: '@telegram',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: SizedBox.square(dimension: 25, child: Assets.icons.telegram.svg()),
            ),
            prefixIconConstraints: const BoxConstraints(maxWidth: 40, maxHeight: 25),
            maxLines: 1,
            onEditingComplete: () {
              context.read<ProfileBloc>().add(UpdateProfileInfoEvent(telegram: _telegramController.text));
            },
          ),
          const SizedBox(height: 8),
          AppTextField(
            focusNode: _whatsappFocusNode,
            controller: _whatsAppController,
            hintText: '+7777777777 (WhatsApp)',
            keyboardType: TextInputType.phone,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: SizedBox.square(dimension: 25, child: Assets.icons.telegram.svg()),
            ),
            prefixIconConstraints: const BoxConstraints(maxWidth: 40, maxHeight: 25),
            maxLines: 1,
            inputFormatters: [_PhoneNumberFormatter()],
          ),
          const SizedBox(height: 8),
          AppTextField(
            controller: _vkController,
            hintText: 'link (vk)',
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: SizedBox.square(dimension: 25, child: Assets.icons.telegram.svg()),
            ),
            prefixIconConstraints: const BoxConstraints(maxWidth: 40, maxHeight: 25),
            maxLines: 1,
            onEditingComplete: () {
              context.read<ProfileBloc>().add(UpdateProfileInfoEvent(vk: _vkController.text));
            },
          ),
        ],
      ),
    );
  }
}

final class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 12) return oldValue;
    if (oldValue.text.isEmpty) return TextEditingValue(text: '+7${newValue.text}');
    return newValue;
  }
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
              if (user.info.name case String name) Text(name, style: textStyles.h3),
              const SizedBox(height: 5),
              if (user.info.phone case String phone) Text(phone, style: textStyles.bodySmall),
              const SizedBox(height: 5),
              Text(user.email, style: textStyles.bodySmall),
              if (user.info.whatsapp != null) ...[
                const SizedBox(height: 5),
                Text('whatsapp: ${user.info.whatsapp}', style: textStyles.bodySmall),
              ],
              if (user.info.whatsapp != null) ...[
                const SizedBox(height: 5),
                Text('vk: ${user.info.vk}', style: textStyles.bodySmall),
              ],
              if (user.info.telegram != null) ...[
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

//TODO
const _items = ['Завтра', 'Surf x Post', 'English club'];

class _EventListItem extends StatelessWidget {
  const _EventListItem({required this.title, this.imgUrl, this.onTap});

  final String title;
  final String? imgUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: '',
            errorWidget:
                (_, __, ___) => Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(color: context.themes.main.colors.secondary, shape: BoxShape.circle),
                ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.themes.main.texts.body.copyWith(fontWeight: FontWeight.w600, height: 1.3)),
                const SizedBox(height: 8),
                Wrap(
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (final (i, item) in _items.indexed) ...[
                      Text(item, style: context.themes.main.texts.bodySmall),
                      if (i != _items.length - 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7.5),
                          child: SizedBox.square(
                            dimension: 5,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: context.themes.main.colors.secondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget shimmer() => const Row(
    children: [
      Shimmer(height: 52, width: 52, borderRadius: 100),
      SizedBox(width: 12),
      Expanded(child: Column(children: [Shimmer(height: 23), SizedBox(height: 4), Shimmer(height: 23)])),
    ],
  );
}
