import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum UserTabItem { explore, purchases, messages, profile }

enum AdminTabItem { explore, sellers, profile }

class TabItemData {
  final String title;
  final IconData icon;
  final GlobalKey<NavigatorState> navKey;

  const TabItemData({required this.title, required this.icon, required this.navKey});

  static Map<UserTabItem, TabItemData> userTabs = {
    UserTabItem.explore: TabItemData(title: 'Explore', icon: FontAwesomeIcons.car, navKey: GlobalKey()),
    UserTabItem.purchases: TabItemData(title: 'Purchases', icon: FontAwesomeIcons.cartShopping, navKey: GlobalKey()),
    UserTabItem.messages: TabItemData(title: 'Messages', icon: FontAwesomeIcons.message, navKey: GlobalKey()),
    UserTabItem.profile: TabItemData(title: 'Profile', icon: FontAwesomeIcons.user, navKey: GlobalKey()),
  };

  static Map<AdminTabItem, TabItemData> adminTabs = {
    AdminTabItem.explore: TabItemData(title: 'Explore', icon: FontAwesomeIcons.car, navKey: GlobalKey()),
    AdminTabItem.sellers: TabItemData(title: 'sellers', icon: FontAwesomeIcons.peopleGroup, navKey: GlobalKey()),
    AdminTabItem.profile: TabItemData(title: 'Profile', icon: FontAwesomeIcons.user, navKey: GlobalKey()),
  };
}

extension TabItemDataX on int {
  UserTabItem get userTabItemFromIndex => UserTabItem.values.elementAt(this);

  AdminTabItem get adminTabItemFromIndex => AdminTabItem.values.elementAt(this);
}
