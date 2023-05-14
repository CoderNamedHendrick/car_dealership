import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TabItem { listing, sellers, profile }

class TabItemData {
  final String title;
  final IconData icon;
  final GlobalKey<NavigatorState> navKey;

  const TabItemData({required this.title, required this.icon, required this.navKey});

  static Map<TabItem, TabItemData> all = {
    TabItem.listing: TabItemData(title: 'Listings', icon: FontAwesomeIcons.car, navKey: GlobalKey()),
    TabItem.sellers: TabItemData(title: 'Sellers', icon: FontAwesomeIcons.users, navKey: GlobalKey()),
    TabItem.profile: TabItemData(title: 'Profile', icon: FontAwesomeIcons.user, navKey: GlobalKey()),
  };
}

extension TabItemDataX on int {
  TabItem get tabItemFromIndex {
    return switch (this) {
      0 => TabItem.listing,
      1 => TabItem.sellers,
      2 => TabItem.profile,
      _ => throw UnimplementedError(),
    };
  }
}
