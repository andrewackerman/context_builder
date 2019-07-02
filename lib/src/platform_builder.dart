import 'package:context_builder/src/layout_context.dart';
import 'package:context_builder/src/context_builder.dart';
import 'package:context_builder/src/context_provider.dart';
import 'package:flutter/widgets.dart';

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

  Widget buildPlatform(BuildContext buildContext, LayoutContext layoutContext) {
    if (layoutContext.isMobile) {
      if (layoutContext.isAndroid && onAndroid != null) {
        return onAndroid(buildContext);
      }
      
      if (layoutContext.isIOS && onIOS != null) {
        return onIOS(buildContext);
      }
      
      if (onMobile != null) {
        return onMobile(buildContext);
      }
    }

    if (layoutContext.isDesktop) {
      if (layoutContext.isWindows && onWindows != null) {
        return onWindows(buildContext);
      }

      if (layoutContext.isMac && onMac != null) {
        return onMac(buildContext);
      }

      if (layoutContext.isLinux && onLinux != null) {
        return onLinux(buildContext);
      }

      if (onDesktop != null) {
        return onDesktop(buildContext);
      }
    }

    if (layoutContext.isWeb && onWeb != null) {
      return onWeb(buildContext);
    }

    if (layoutContext.isFuschia && onFuschia != null) {
      return onFuschia(buildContext);
    }

    if (onAny != null) {
      return onAny(buildContext);
    }

    throw StateError('${layoutContext.os} detected, but no appropriate builder function was supplied.');
  }

  @override
  Widget build(BuildContext context) {
    final layoutContext = ContextProvider.of(context, notifyChanges: false);
    Widget child;

    if (layoutContext != null) {
      child = buildPlatform(context, layoutContext);
    } else {
      child = ContextBuilder(
        builder: (buildContext, appContext) {
          return buildPlatform(buildContext, layoutContext);
        },
      );
    }

    return child;
  }
}