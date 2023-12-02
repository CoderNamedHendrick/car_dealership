import 'package:car_dealership/main.dart';
import 'package:car_dealership/utility/signals_extension.dart';
import 'package:signals/signals_flutter.dart';

import '../sellers/view/sellers_page.dart';
import 'widgets/widgets.dart';
import '../../../application/application.dart';
import '../../core/common.dart';
import '../explore/view/explore_page.dart';
import 'nested_tabs.dart';
import '../messages/view/messages_page.dart';
import '../profile/view/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../purchases/view/purchases_page.dart';

class Home extends ConsumerStatefulWidget {
  static const route = '/home';

  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final isAdmin = locator<ProfileViewModel>()
            .profileEmitter
            .watch(context)
            .user
            ?.isAdmin ??
        false;
    return WillPopScope(
      onWillPop: isAdmin ? _adminPop : _userPop,
      child: Stack(
        children: [
          const _ProfileUpdateListener(),
          Scaffold(
            body: AnimatedIndexedStack(
              index: bottomNavPageIndexSignal.watch(context),
              children: isAdmin
                  ? const [
                      _AdminDestination(item: AdminTabItem.explore),
                      _AdminDestination(item: AdminTabItem.sellers),
                      _AdminDestination(item: AdminTabItem.profile),
                    ]
                  : const [
                      _UserDestination(item: UserTabItem.explore),
                      _UserDestination(item: UserTabItem.purchases),
                      _UserDestination(item: UserTabItem.messages),
                      _UserDestination(item: UserTabItem.profile),
                    ],
            ),
            bottomNavigationBar: NavigationBar(
              animationDuration: Constants.longAnimationDur,
              selectedIndex: bottomNavPageIndexSignal.watch(context),
              onDestinationSelected: (page) {
                final navTappedTwice = bottomNavPageIndexSignal.value == page;
                bottomNavPageIndexSignal.value = page;

                if (navTappedTwice) {
                  isAdmin
                      ? _adminPopToFirst(page.adminTabItemFromIndex)
                      : _userPopToFirst(page.userTabItemFromIndex);
                }
              },
              destinations: isAdmin
                  ? const [
                      _AdminNavDestination(item: AdminTabItem.explore),
                      _AdminNavDestination(item: AdminTabItem.sellers),
                      _AdminNavDestination(item: AdminTabItem.profile),
                    ]
                  : const [
                      _UserNavDestination(item: UserTabItem.explore),
                      _UserNavDestination(item: UserTabItem.purchases),
                      _UserNavDestination(item: UserTabItem.messages),
                      _UserNavDestination(item: UserTabItem.profile),
                    ],
            ),
          ),
        ],
      ),
    );
  }

  void _userPopToFirst(UserTabItem item) {
    final itemData = TabItemData.userTabs[item]!;

    Navigator.of(itemData.navKey.currentContext!)
        .popUntil((route) => route.isFirst);
  }

  void _adminPopToFirst(AdminTabItem item) {
    final itemData = TabItemData.adminTabs[item]!;

    Navigator.of(itemData.navKey.currentContext!)
        .popUntil((route) => route.isFirst);
  }

  Future<bool> _userPop() async {
    final tabItem = bottomNavPageIndexSignal.value.userTabItemFromIndex;
    final itemData = TabItemData.userTabs[tabItem]!;

    final canPop = Navigator.of(itemData.navKey.currentContext!).canPop();
    if (canPop) {
      Navigator.of(itemData.navKey.currentContext!).pop();
      return false;
    }

    if (tabItem != UserTabItem.explore) {
      bottomNavPageIndexSignal.value = UserTabItem.explore.index;
      return false;
    }
    return showQuitAppAlert(context);
  }

  Future<bool> _adminPop() async {
    final tabItem = bottomNavPageIndexSignal.value.adminTabItemFromIndex;
    final itemData = TabItemData.adminTabs[tabItem]!;

    final canPop = Navigator.of(itemData.navKey.currentContext!).canPop();
    if (canPop) {
      Navigator.of(itemData.navKey.currentContext!).pop();
      return false;
    }

    if (tabItem != AdminTabItem.explore) {
      bottomNavPageIndexSignal.value = AdminTabItem.explore.index;
      return false;
    }
    return showQuitAppAlert(context);
  }
}

class _ProfileUpdateListener extends StatefulWidget {
  const _ProfileUpdateListener();

  @override
  State<_ProfileUpdateListener> createState() => _ProfileUpdateListenerState();
}

class _ProfileUpdateListenerState extends State<_ProfileUpdateListener> {
  late Function() disposeEmitter;

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      disposeEmitter = locator<ProfileViewModel>()
          .profileEmitter
          .onSignalUpdate((previous, next) {
        // sign-in successful
        if (previous?.user != next.user) {
          if (previous?.user?.isAdmin != next.user?.isAdmin) {
            bottomNavPageIndexSignal.value = 0;
          }

          if (next.user?.isAdmin ?? false) return;
          locator<MessagesViewModel>().fetchChats();
          locator<PurchasesHomeViewModel>().fetchPurchases();
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
    return const SizedBox.shrink();
  }
}

class _UserDestination extends StatelessWidget {
  const _UserDestination({required this.item});

  final UserTabItem item;

  @override
  Widget build(BuildContext context) {
    final itemData = TabItemData.userTabs[item]!;
    return NestedRoutePage(nestedNavKey: itemData.navKey, child: _child);
  }

  Widget get _child {
    return switch (item) {
      UserTabItem.explore => const ExplorePage(),
      UserTabItem.profile => const ProfilePage(),
      UserTabItem.purchases => const PurchasesPage(),
      UserTabItem.messages => const MessagesPage(),
    };
  }
}

class _AdminDestination extends StatelessWidget {
  const _AdminDestination({required this.item});

  final AdminTabItem item;

  @override
  Widget build(BuildContext context) {
    final itemData = TabItemData.adminTabs[item]!;
    return NestedRoutePage(nestedNavKey: itemData.navKey, child: _child);
  }

  Widget get _child {
    return switch (item) {
      AdminTabItem.explore => const ExplorePage(),
      AdminTabItem.sellers => const SellersPage(),
      AdminTabItem.profile => const ProfilePage(),
    };
  }
}

class _UserNavDestination extends StatelessWidget {
  const _UserNavDestination({required this.item});

  final UserTabItem item;

  @override
  Widget build(BuildContext context) {
    final itemData = TabItemData.userTabs[item]!;

    return NavigationDestination(
        icon: FaIcon(itemData.icon), label: itemData.title);
  }
}

class _AdminNavDestination extends StatelessWidget {
  const _AdminNavDestination({required this.item});

  final AdminTabItem item;

  @override
  Widget build(BuildContext context) {
    final itemData = TabItemData.adminTabs[item]!;

    return NavigationDestination(
        icon: FaIcon(itemData.icon), label: itemData.title);
  }
}

final bottomNavPageIndexSignal = signal(0);
