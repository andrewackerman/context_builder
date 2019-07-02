import 'package:context_builder/src/context.dart';
import 'package:flutter/widgets.dart';

class ContextBuilder extends StatefulWidget {
  ContextBuilder({
    Key key,
    this.scaleBehavior = ScaleBehavior.width,
    this.scaleOffset = 1.0,
    this.baseWidth = 414.0,
    this.baseHeight = 736.0,
    this.baseFontSize = 12.0,
    this.baseIconSize = 24.0,
    @required this.builder,
  }) : super(key: key);

  final ScaleBehavior scaleBehavior;
  final double scaleOffset;
  final double baseWidth;
  final double baseHeight;
  final double baseFontSize;
  final double baseIconSize;
  final Widget Function(BuildContext buildContext, LayoutContext layoutContext) builder;

  @override
  ContextBuilderState createState() => ContextBuilderState();
}

class ContextBuilderState extends State<ContextBuilder> implements WidgetsBindingObserver {
  LayoutContext _layoutContext;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    refreshContext();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(ContextBuilder oldWidget) {
    refreshContext();
    super.didUpdateWidget(oldWidget);
  }

  void refreshContext() {
    bool needsRefresh = false;
    if (_layoutContext == null) {
      needsRefresh = true;
    } else {
      final mediaQuery = MediaQuery.of(context);
      if (mediaQuery.orientation != _layoutContext.orientation) {
        needsRefresh = true;
      }
    }

    if (needsRefresh) {
      setState(() {
        _layoutContext = LayoutContext.of(
          context,
          scaleBehavior: widget.scaleBehavior,
          scaleOffset: widget.scaleOffset ?? WidgetsBinding.instance.window.textScaleFactor,
          baseWidth: widget.baseWidth,
          baseHeight: widget.baseHeight,
          baseFontSize: widget.baseFontSize,
          baseIconSize: widget.baseIconSize,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _layoutContext);
  }

  @override
  void didChangeMetrics() {
    refreshContext();
  }

  @override
  void didChangeTextScaleFactor() {
    if (widget.scaleOffset == null) {
      refreshContext();
    }
  }

  @override void didChangeAccessibilityFeatures() { }
  @override void didChangeAppLifecycleState(AppLifecycleState state) { }
  @override void didChangeLocales(List<Locale> locale) { }
  @override void didChangePlatformBrightness() { }
  @override void didHaveMemoryPressure() { }
  @override Future<bool> didPopRoute() => null; 
  @override Future<bool> didPushRoute(String route) => null;
}