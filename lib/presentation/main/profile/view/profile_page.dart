import 'package:car_dealership/main.dart';
import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/main/home/home.dart';
import 'package:car_dealership/presentation/main/home/nested_tabs.dart';
import 'package:car_dealership/presentation/main/profile/view/wishlist.dart';
import 'package:car_dealership/utility/signals_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals/signals_flutter.dart';

import '../../../../application/application.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileViewModel _profileViewModel;

  @override
  void initState() {
    super.initState();

    _profileViewModel = locator<ProfileViewModel>();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      _profileViewModel.fetchUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          if (_profileViewModel.profileEmitter.watch(context).user?.isAdmin ??
              false)
            Text('Admin', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(width: Constants.horizontalMargin)
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Constants.horizontalMargin,
            vertical: Constants.verticalMargin),
        child: Profile(),
      ),
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late ProfileViewModel _profileViewModel;
  late Function() disposeEmitter;

  @override
  void initState() {
    super.initState();

    _profileViewModel = locator<ProfileViewModel>();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      disposeEmitter =
          _profileViewModel.profileEmitter.onSignalUpdate((previous, next) {
        if (previous?.user != next.user) {
          _profileViewModel.fetchUser();
        }
      });
    });
  }

  @override
  void dispose() {
    disposeEmitter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileUiState = _profileViewModel.profileEmitter.watch(context);

    if (profileUiState.currentState == ViewState.loading) {
      return const Center(child: CarLoader());
    }

    if (profileUiState.currentState == ViewState.error) {
      return switch (profileUiState.error) {
        MessageException(:final exception) =>
          Center(child: Text('An error occurred: ${exception.toString()}')),
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
      return Watch((context) {
        return Column(
          children: [
            UserNameAndAvatar(userName: profileUiState.user!.name),
            Constants.verticalGutter18,
            if (profileUiState.user?.isAdmin ?? false) ...[
              ProfileListTile(
                leading: const FaIcon(FontAwesomeIcons.peopleArrows),
                title: 'Sellers',
                onTap: () {
                  bottomNavPageIndexSignal.value = AdminTabItem.sellers.index;
                },
              ),
            ] else ...[
              ProfileListTile(
                leading: const FaIcon(FontAwesomeIcons.car),
                title: 'My Purchases',
                onTap: () {
                  bottomNavPageIndexSignal.value = UserTabItem.purchases.index;
                  locator<PurchasesHomeViewModel>().fetchPurchases();
                },
              ),
              Constants.verticalGutter,
              ProfileListTile(
                leading: const FaIcon(FontAwesomeIcons.heart),
                title: 'Wishlist',
                onTap: () => Navigator.of(context).pushNamed(Wishlist.route),
              ),
            ],
            Constants.verticalGutter,
            ProfileListTile(
              leading: const Icon(Icons.exit_to_app),
              title: 'Log Out',
              onTap: _profileViewModel.logout,
            ),
          ],
        );
      });
    }

    return const SizedBox.shrink();
  }
}
