import 'dart:io';

class PlatformHelper {
  static bool get isAndroid => Platform.isAndroid;
  static bool get isIOS => Platform.isIOS;
  static bool get isWindows => Platform.isWindows;
  static bool get isMac => Platform.isMacOS;
  static bool get isLinux => Platform.isLinux;
  static bool get isFuschia => Platform.isFuchsia;
  static bool get isWeb => false;
}