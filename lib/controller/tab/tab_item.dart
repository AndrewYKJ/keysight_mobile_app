import 'package:flutter/material.dart';
import 'package:keysight_pma/const/constants.dart';

enum TabItem { Home, Notification, Admin }

Map<TabItem, String> tabName = {
  TabItem.Home: 'Home',
  TabItem.Notification: 'Notification',
  TabItem.Admin: 'Admin',
};

Map<TabItem, Image> tabIconSelected = {
  TabItem.Home: Image.asset(
    Constants.ASSET_IMAGES + 'home_active.png',
    width: 24,
    fit: BoxFit.contain,
  ),
  TabItem.Notification: Image.asset(
    Constants.ASSET_IMAGES + 'notification_active.png',
    width: 24,
    fit: BoxFit.contain,
  ),
  TabItem.Admin: Image.asset(
    Constants.ASSET_IMAGES + 'admin_active.png',
    width: 24,
    fit: BoxFit.contain,
  ),
};

Map<TabItem, Image> tabIconUnselected = {
  TabItem.Home: Image.asset(
    Constants.ASSET_IMAGES + 'home_inactive.png',
    width: 24,
    fit: BoxFit.contain,
  ),
  TabItem.Notification: Image.asset(
    Constants.ASSET_IMAGES + 'notification_inactive.png',
    width: 24,
    fit: BoxFit.contain,
  ),
  TabItem.Admin: Image.asset(
    Constants.ASSET_IMAGES + 'admin_inactive.png',
    width: 24,
    fit: BoxFit.contain,
  ),
};
Map<TabItem, Image> tabIconSelectedLight = {
  TabItem.Home: Image.asset(
    Constants.ASSET_IMAGES_LIGHT + 'home_active.png',
    width: 24,
    fit: BoxFit.contain,
  ),
  TabItem.Notification: Image.asset(
    Constants.ASSET_IMAGES_LIGHT + 'notification_active.png',
    width: 24,
    fit: BoxFit.contain,
  ),
  TabItem.Admin: Image.asset(
    Constants.ASSET_IMAGES_LIGHT + 'admin_active.png',
    width: 24,
    fit: BoxFit.contain,
  ),
};

Map<TabItem, Image> tabIconUnselectedLight = {
  TabItem.Home: Image.asset(
    Constants.ASSET_IMAGES_LIGHT + 'home_inactive.png',
    width: 24,
    fit: BoxFit.contain,
  ),
  TabItem.Notification: Image.asset(
    Constants.ASSET_IMAGES_LIGHT + 'notification_inactive.png',
    width: 24,
    fit: BoxFit.contain,
  ),
  TabItem.Admin: Image.asset(
    Constants.ASSET_IMAGES_LIGHT + 'admin_inactive.png',
    width: 24,
    fit: BoxFit.contain,
  ),
};
