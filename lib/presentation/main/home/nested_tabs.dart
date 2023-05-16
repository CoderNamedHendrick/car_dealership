import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TabItem { explore, purchases, messages, profile }

class TabItemData {
  final String title;
  final IconData icon;
  final GlobalKey<NavigatorState> navKey;

  const TabItemData({required this.title, required this.icon, required this.navKey});

  static Map<TabItem, TabItemData> all = {
    TabItem.explore: TabItemData(title: 'Explore', icon: FontAwesomeIcons.car, navKey: GlobalKey()),
    TabItem.purchases: TabItemData(title: 'Purchases', icon: FontAwesomeIcons.cartShopping, navKey: GlobalKey()),
    TabItem.messages: TabItemData(title: 'Messages', icon: FontAwesomeIcons.message, navKey: GlobalKey()),
    TabItem.profile: TabItemData(title: 'Profile', icon: FontAwesomeIcons.user, navKey: GlobalKey()),
  };
}

extension TabItemDataX on int {
  TabItem get tabItemFromIndex => TabItem.values.elementAt(this);
}
