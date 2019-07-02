import 'package:context_builder/src/context_builder.dart';
import 'package:flutter/cupertino.dart';

class PlatformBuilder extends StatelessWidget {
  final Widget Function(BuildContext) onAndroid;
  final Widget Function(BuildContext) onIOS;
  final Widget Function(BuildContext) onMobile;
  final Widget Function(BuildContext) onWindows;
  final Widget Function(BuildContext) onMac;
  final Widget Function(BuildContext) onLinux;
  final Widget Function(BuildContext) onDesktop;
  final Widget Function(BuildContext) onFuschia;
  final Widget Function(BuildContext) onWeb;
  final Widget Function(BuildContext) onOther;
  final Widget Function(BuildContext) onAny;

  PlatformBuilder({
    this.onAndroid,
    this.onIOS,
    this.onMobile,
    this.onWindows,
    this.onMac,
    this.onLinux,
    this.onDesktop,
    this.onFuschia,
    this.onWeb,
    this.onOther,
    this.onAny,
  });

  @override
  Widget build(BuildContext context) {
    return ContextBuilder(
      builder: (buildContext, appContext) {
        if (appContext.isMobile) {
          if (appContext.isAndroid && onAndroid != null) {
            return onAndroid(buildContext);
          }
          
          if (appContext.isIOS && onIOS != null) {
            return onIOS(buildContext);
          }
          
          if (onMobile != null) {
            return onMobile(buildContext);
          }
        }

        if (appContext.isDesktop) {
          if (appContext.isWindows && onWindows != null) {
            return onWindows(buildContext);
          }

          if (appContext.isMac && onMac != null) {
            return onMac(buildContext);
          }

          if (appContext.isLinux && onLinux != null) {
            return onLinux(buildContext);
          }

          if (onDesktop != null) {
            return onDesktop(buildContext);
          }
        }

        if (appContext.isWeb && onWeb != null) {
          return onWeb(buildContext);
        }

        if (appContext.isFuschia && onFuschia != null) {
          return onFuschia(buildContext);
        }

        if (onAny != null) {
          return onAny(buildContext);
        }

        throw StateError('${appContext.os} detected, but no appropriate builder function was supplied.');
      }
    );
  }
}