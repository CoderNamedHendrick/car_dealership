import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/main/home/nested_tabs.dart';
import 'package:car_dealership/presentation/main/home/widgets/animated_index_stack.dart';
import 'package:car_dealership/presentation/main/home/widgets/nested_route_page.dart';
import 'package:car_dealership/presentation/main/listing/view/listing_page.dart';
import 'package:car_dealership/presentation/main/profile/view/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../sellers/view/sellers_page.dart';

class Home extends ConsumerStatefulWidget {
  static const route = '/home';

  const Home({Key? key}) : super(key: key);

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedIndexedStack(
        index: ref.watch(_pageIndexProvider),
        children: const [
          _Destination(item: TabItem.listing),
          _Destination(item: TabItem.sellers),
          _Destination(item: TabItem.profile),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        animationDuration: Constants.longAnimationDur,
        selectedIndex: ref.watch(_pageIndexProvider),
        onDestinationSelected: (page) {
          ref.read(_pageIndexProvider.notifier).update((state) => page);
          _popToFirst(page.tabItemFromIndex);
        },
        destinations: const [
          _NavDestination(item: TabItem.listing),
          _NavDestination(item: TabItem.sellers),
          _NavDestination(item: TabItem.profile),
        ],
      ),
    );
  }

  void _popToFirst(TabItem item) {
    final itemData = TabItemData.all[item]!;

    Navigator.of(itemData.navKey.currentContext!).popUntil((route) => route.isFirst);
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
      TabItem.listing => const ListingPage(),
      TabItem.profile => const ProfilePage(),
      TabItem.sellers => const SellersPage(),
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

final _pageIndexProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});
