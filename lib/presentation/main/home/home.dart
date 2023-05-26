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

  const Home({Key? key}) : super(key: key);

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(profileStateNotifierProvider.select((value) => value.user))?.isAdmin ?? false;
    return WillPopScope(
      onWillPop: isAdmin ? _adminPop : _userPop,
      child: Stack(
        children: [
          const _ProfileUpdateListener(),
          Scaffold(
            body: AnimatedIndexedStack(
              index: ref.watch(bottomNavPageIndexProvider),
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
              selectedIndex: ref.watch(bottomNavPageIndexProvider),
              onDestinationSelected: (page) {
                final navTappedTwice = ref.read(bottomNavPageIndexProvider) == page;
                ref.read(bottomNavPageIndexProvider.notifier).update((state) => page);

                if (navTappedTwice) {
                  isAdmin ? _adminPopToFirst(page.adminTabItemFromIndex) : _userPopToFirst(page.userTabItemFromIndex);
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

    Navigator.of(itemData.navKey.currentContext!).popUntil((route) => route.isFirst);
  }

  void _adminPopToFirst(AdminTabItem item) {
    final itemData = TabItemData.adminTabs[item]!;

    Navigator.of(itemData.navKey.currentContext!).popUntil((route) => route.isFirst);
  }

  Future<bool> _userPop() async {
    final tabItem = ref.read(bottomNavPageIndexProvider).userTabItemFromIndex;
    final itemData = TabItemData.userTabs[tabItem]!;

    final canPop = Navigator.of(itemData.navKey.currentContext!).canPop();
    if (canPop) {
      Navigator.of(itemData.navKey.currentContext!).pop();
      return false;
    }

    if (tabItem != UserTabItem.explore) {
      ref.read(bottomNavPageIndexProvider.notifier).update((state) => UserTabItem.explore.index);
      return false;
    }
    return showQuitAppAlert(context);
  }

  Future<bool> _adminPop() async {
    final tabItem = ref.read(bottomNavPageIndexProvider).adminTabItemFromIndex;
    final itemData = TabItemData.adminTabs[tabItem]!;

    final canPop = Navigator.of(itemData.navKey.currentContext!).canPop();
    if (canPop) {
      Navigator.of(itemData.navKey.currentContext!).pop();
      return false;
    }

    if (tabItem != AdminTabItem.explore) {
      ref.read(bottomNavPageIndexProvider.notifier).update((state) => AdminTabItem.explore.index);
      return false;
    }
    return showQuitAppAlert(context);
  }
}

class _ProfileUpdateListener extends ConsumerWidget {
  const _ProfileUpdateListener({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(profileStateNotifierProvider.select((value) => value.user), (previous, next) {
      // sign-in successful
      if (previous != next) {
        if (previous?.isAdmin != next?.isAdmin) ref.read(bottomNavPageIndexProvider.notifier).update((state) => 0);

        if (next?.isAdmin ?? false) return;
        ref.read(messagesHomeStateNotifierProvider.notifier).fetchChats();
        ref.read(purchasesHomeStateNotifierProvider.notifier).fetchPurchases();
      }
    });
    return const SizedBox.shrink();
  }
}

class _UserDestination extends StatelessWidget {
  const _UserDestination({Key? key, required this.item}) : super(key: key);
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
  const _AdminDestination({Key? key, required this.item}) : super(key: key);
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
  const _UserNavDestination({Key? key, required this.item}) : super(key: key);
  final UserTabItem item;

  @override
  Widget build(BuildContext context) {
    final itemData = TabItemData.userTabs[item]!;

    return NavigationDestination(icon: FaIcon(itemData.icon), label: itemData.title);
  }
}

class _AdminNavDestination extends StatelessWidget {
  const _AdminNavDestination({Key? key, required this.item}) : super(key: key);
  final AdminTabItem item;

  @override
  Widget build(BuildContext context) {
    final itemData = TabItemData.adminTabs[item]!;

    return NavigationDestination(icon: FaIcon(itemData.icon), label: itemData.title);
  }
}

final bottomNavPageIndexProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});
