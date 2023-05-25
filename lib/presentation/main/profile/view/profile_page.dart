import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/main/home/home.dart';
import 'package:car_dealership/presentation/main/home/nested_tabs.dart';
import 'package:car_dealership/presentation/main/profile/view/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../application/application.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/widgets.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      ref.read(profileStateNotifierProvider.notifier).fetchUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: Constants.horizontalMargin, vertical: Constants.verticalMargin),
        child: Profile(),
      ),
    );
  }
}

class Profile extends ConsumerWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(profileStateNotifierProvider.select((value) => value.user), (previous, next) {
      if (next == null) {
        ref.read(profileStateNotifierProvider.notifier).fetchUser();
      }
    });

    final profileUiState = ref.watch(profileStateNotifierProvider);

    if (profileUiState.currentState == ViewState.loading) {
      return const Center(child: CarLoader());
    }

    if (profileUiState.currentState == ViewState.error) {
      return switch (profileUiState.error) {
        MessageException(:final exception) => Center(child: Text('An error occurred: ${exception.toString()}')),
        AuthRequiredException() => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  const AuthRequiredException().toString(),
                ),
                Constants.verticalGutter,
                const LoginButton(),
              ],
            ),
          ),
        _ => const SizedBox.shrink(),
      };
    }

    if (profileUiState.currentState == ViewState.success) {
      return Column(
        children: [
          UserNameAndAvatar(userName: profileUiState.user!.name),
          Constants.verticalGutter18,
          ProfileListTile(
            leading: const FaIcon(FontAwesomeIcons.car),
            title: 'My Purchases',
            onTap: () {
              ref.read(bottomNavPageIndexProvider.notifier).update((state) => TabItem.purchases.index);

              ref.read(purchasesHomeStateNotifierProvider.notifier).fetchPurchases();
            },
          ),
          Constants.verticalGutter,
          ProfileListTile(
            leading: const FaIcon(FontAwesomeIcons.heart),
            title: 'Wishlist',
            onTap: () => Navigator.of(context).pushNamed(Wishlist.route),
          ),
          Constants.verticalGutter,
          ProfileListTile(
            leading: const Icon(Icons.exit_to_app),
            title: 'Log Out',
            onTap: ref.read(profileStateNotifierProvider.notifier).logout,
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
