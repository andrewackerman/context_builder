import 'package:context_builder/context_builder.dart';
import 'package:flutter/widgets.dart';

class ContextProvider extends StatelessWidget {
  ContextProvider({
    Key key,
    this.scaleBehavior = ScaleBehavior.width,
    this.scaleOffset = 1.0,
    this.baseWidth = 414.0,
    this.baseHeight = 736.0,
    this.baseFontSize = 12.0,
    this.baseIconSize = 24.0,
    @required this.child,
  }) : assert(child != null),
       super(key: key);

  final ScaleBehavior scaleBehavior;
  final double scaleOffset;
  final double baseWidth;
  final double baseHeight;
  final double baseFontSize;
  final double baseIconSize;
  final Widget child;

  static LayoutContext of(BuildContext context) {
    final inheritedContext = context.inheritFromWidgetOfExactType(_InheritedContext) as _InheritedContext;
    return inheritedContext?.layoutContext;
  }

  @override
  Widget build(BuildContext context) {
    return ContextBuilder(
      scaleBehavior: scaleBehavior,
      scaleOffset: scaleOffset,
      baseWidth: baseWidth,
      baseHeight: baseHeight,
      baseFontSize: baseFontSize,
      baseIconSize: baseIconSize,
      builder: (_, layoutContext) {
        print('rebuild');
        return _InheritedContext(
          layoutContext: layoutContext,
          child: child,
        );
      }
    );
  }
}

class _InheritedContext extends InheritedWidget {
  final LayoutContext layoutContext;

  _InheritedContext({
    @required this.layoutContext,
    @required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(_InheritedContext oldWidget) {
    print('should notify: ${layoutContext != oldWidget.layoutContext}');
    if (layoutContext != oldWidget.layoutContext) {
      return true;
    }
    return false;
  }
  
}