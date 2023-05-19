import '../../../application/application.dart';
import '../../core/common.dart';
import '../explore/view/explore_page.dart';
import 'nested_tabs.dart';
import 'widgets/animated_index_stack.dart';
import 'widgets/nested_route_page.dart';
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
    return Stack(
      children: [
        const _ProfileUpdateListener(),
        Scaffold(
          body: AnimatedIndexedStack(
            index: ref.watch(bottomNavPageIndexProvider),
            children: const [
              _Destination(item: TabItem.explore),
              _Destination(item: TabItem.purchases),
              _Destination(item: TabItem.messages),
              _Destination(item: TabItem.profile),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            animationDuration: Constants.longAnimationDur,
            selectedIndex: ref.watch(bottomNavPageIndexProvider),
            onDestinationSelected: (page) {
              final isTappedAgain = ref.read(bottomNavPageIndexProvider) == page;
              ref.read(bottomNavPageIndexProvider.notifier).update((state) => page);

              if (isTappedAgain) _popToFirst(page.tabItemFromIndex);
            },
            destinations: const [
              _NavDestination(item: TabItem.explore),
              _NavDestination(item: TabItem.purchases),
              _NavDestination(item: TabItem.messages),
              _NavDestination(item: TabItem.profile),
            ],
          ),
        ),
      ],
    );
  }

  void _popToFirst(TabItem item) {
    final itemData = TabItemData.all[item]!;

    Navigator.of(itemData.navKey.currentContext!).popUntil((route) => route.isFirst);
  }
}

class _ProfileUpdateListener extends ConsumerWidget {
  const _ProfileUpdateListener({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(profileStateNotifierProvider.select((value) => value.user), (previous, next) {
      // sign-in successful
      if (previous != next) {
        ref.read(messagesHomeStateNotifierProvider.notifier).fetchChats();
        ref.read(purchasesHomeStateNotifierProvider.notifier).fetchPurchases();
      }
    });
    return const SizedBox.shrink();
  }
}

class _Destination extends StatelessWidget {
  const _Destination({Key? key, required this.item}) : super(key: key);
  final TabItem item;

  @override
  Widget build(BuildContext context) {
    final itemData = TabItemData.all[item]!;
    return NestedRoutePage(nestedNavKey: itemData.navKey, child: _child);
  }

  Widget get _child {
    return switch (item) {
      TabItem.explore => const ExplorePage(),
      TabItem.profile => const ProfilePage(),
      TabItem.purchases => const PurchasesPage(),
      TabItem.messages => const MessagesPage(),
    };
  }
}

class _NavDestination extends StatelessWidget {
  const _NavDestination({Key? key, required this.item}) : super(key: key);
  final TabItem item;

  @override
  Widget build(BuildContext context) {
    final itemData = TabItemData.all[item]!;

    return NavigationDestination(icon: FaIcon(itemData.icon), label: itemData.title);
  }
}

final bottomNavPageIndexProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});
