import 'dart:math' as Math;
import 'dart:ui';

import 'helpers/platform_helper_interface.dart'
  if (dart.library.io) 'helpers/platform_helper_vm.dart'
  if (dart.library.js) 'helpers/platform_helper_web.dart';

import 'package:flutter/widgets.dart';

enum OperatingSystem {
  android,
  ios,
  windows,
  mac,
  linux,
  fuschia,
  web,
  other,
}

enum ScaleBehavior {
  width,
  height,
  horizontal,
  vertical,
  minimum,
  maximum,
}

// Values taken from bootstrap
const double _smallSizeCategoryWidthThreshold = 576;
const double _mediumSizeCategoryWidthThreshold = 768;
const double _largeSizeCategoryWidthThreshold = 992;
const double _xlargeSizeCategoryWidthThreshold = 1200;

enum SizeCategory {
  xsmall,
  small,
  medium,
  large,
  xlarge,
}

class LayoutContext {
  LayoutContext._({
    this.os,
    this.screenSize,
    this.rawScreenSize,
    this.sizeCategory,
    this.orientation,
    this.scaleBehavior,
    this.scaleRatio,
    this.scaleFactor,
    this.scaleDimensionSize,
    double baseFontSize,
    double baseIconSize,
  }) : this._baseFontSize = baseFontSize,
       this._baseIconSize = baseIconSize;

  factory LayoutContext.of(
    BuildContext ctx, {
    ScaleBehavior scaleBehavior = ScaleBehavior.width,
    double scaleOffset = 1.0,
    double baseWidth = 414.0,
    double baseHeight = 736.0,
    double baseFontSize = 12.0,
    double baseIconSize = 24.0,
  }) {
    OperatingSystem os;
    if (PlatformHelper.isAndroid) os = OperatingSystem.android;
    else if (PlatformHelper.isIOS) os = OperatingSystem.ios;
    else if (PlatformHelper.isWindows) os = OperatingSystem.windows;
    else if (PlatformHelper.isMac) os = OperatingSystem.mac;
    else if (PlatformHelper.isLinux) os = OperatingSystem.linux;
    else if (PlatformHelper.isFuschia) os = OperatingSystem.fuschia;
    else if (PlatformHelper.isWeb) os = OperatingSystem.web;
    else os = OperatingSystem.other;

    final mediaQuery = MediaQuery.of(ctx);
    final screenSize = mediaQuery.size;

    double scaleDimensionSize;
    double ratio;

    if (os == OperatingSystem.android || os == OperatingSystem.ios) {
      switch (scaleBehavior) {
        case ScaleBehavior.width:
          scaleDimensionSize = mediaQuery.orientation == Orientation.portrait ? screenSize.width : screenSize.height;
          ratio = scaleDimensionSize / baseWidth;
          break;
        case ScaleBehavior.height:
          scaleDimensionSize = mediaQuery.orientation == Orientation.portrait ? screenSize.height : screenSize.width;
          ratio = scaleDimensionSize / baseHeight;
          break;
        case ScaleBehavior.horizontal:
          scaleDimensionSize = screenSize.width;
          ratio = scaleDimensionSize / (mediaQuery.orientation == Orientation.portrait ? baseWidth : baseHeight);
          break;
        case ScaleBehavior.vertical:
          scaleDimensionSize = screenSize.height;
          ratio = scaleDimensionSize / (mediaQuery.orientation == Orientation.portrait ? baseHeight : baseWidth);
          break;
        case ScaleBehavior.minimum:
          scaleDimensionSize = Math.min(screenSize.width, screenSize.height);
          ratio = scaleDimensionSize / Math.min(baseWidth, baseHeight);
          break;
        case ScaleBehavior.maximum:
          scaleDimensionSize = Math.max(screenSize.width, screenSize.height);
          ratio = scaleDimensionSize / Math.max(baseWidth, baseHeight);
          break;
      }
    } else {
      switch (scaleBehavior) {
        case ScaleBehavior.width:
        case ScaleBehavior.horizontal:
          scaleDimensionSize = screenSize.width;
          ratio = scaleDimensionSize / baseWidth;
          break;
        case ScaleBehavior.height:
        case ScaleBehavior.vertical:
          scaleDimensionSize = screenSize.height;
          ratio = scaleDimensionSize / baseHeight;
          break;
        case ScaleBehavior.minimum:
          scaleDimensionSize = Math.min(screenSize.width, screenSize.height);
          ratio = scaleDimensionSize / Math.min(baseWidth, baseHeight);
          break;
        case ScaleBehavior.maximum:
          scaleDimensionSize = Math.max(screenSize.width, screenSize.height);
          ratio = scaleDimensionSize / Math.max(baseWidth, baseHeight);
          break;
      }
    }

    double rawDimensionSize = scaleDimensionSize * mediaQuery.devicePixelRatio;
    SizeCategory category;
    if (rawDimensionSize >= _xlargeSizeCategoryWidthThreshold) {
      category = SizeCategory.xlarge;
    } else if (rawDimensionSize >= _largeSizeCategoryWidthThreshold) {
      category = SizeCategory.large;
    } else if (rawDimensionSize >= _mediumSizeCategoryWidthThreshold) {
      category = SizeCategory.medium;
    } else if (rawDimensionSize >= _smallSizeCategoryWidthThreshold) {
      category = SizeCategory.small;
    } else {
      category = SizeCategory.xsmall;
    }

    return LayoutContext._(
      os: os,
      screenSize: screenSize,
      rawScreenSize: screenSize * mediaQuery.devicePixelRatio,
      sizeCategory: category,
      orientation: mediaQuery.orientation,
      scaleBehavior: scaleBehavior,
      scaleRatio: ratio,
      scaleFactor: scaleOffset,
      scaleDimensionSize: scaleDimensionSize,
      baseFontSize: baseFontSize,
      baseIconSize: baseIconSize,
    );
  }

  final OperatingSystem os;
  final Size screenSize;
  final Size rawScreenSize;
  final SizeCategory sizeCategory;
  final Orientation orientation;
  final double scaleDimensionSize;
  final ScaleBehavior scaleBehavior;
  final double scaleRatio;
  final double scaleFactor;

  final double _baseFontSize;
  final double _baseIconSize;

  bool operator ==(Object other) {
    if (other is LayoutContext) {
      return os == other.os &&
             screenSize == other.screenSize &&
             rawScreenSize == other.rawScreenSize &&
             sizeCategory == other.sizeCategory &&
             orientation == other.orientation &&
             scaleDimensionSize == other.scaleDimensionSize &&
             scaleBehavior == other.scaleBehavior &&
             scaleRatio == other.scaleRatio &&
             scaleFactor == other.scaleFactor &&
             _baseFontSize == other._baseFontSize &&
             _baseIconSize == other._baseIconSize;
    }

    return false;
  }

  @override
  int get hashCode {
    return (os.hashCode << 1) ^
           (screenSize.hashCode << 2) ^
           (rawScreenSize.hashCode << 3) ^
           (orientation.hashCode << 4) ^
           (scaleDimensionSize.hashCode << 4) ^
           (scaleBehavior.hashCode << 5) ^
           (scaleRatio.hashCode << 6) ^
           (scaleFactor.hashCode << 7) ^
           (_baseFontSize.hashCode << 8) ^
           (_baseIconSize.hashCode << 9);
  }

  bool get isAndroid => os == OperatingSystem.android;
  bool get isIOS => os == OperatingSystem.ios;
  bool get isMobile => isAndroid || isIOS;

  bool get isWindows => os == OperatingSystem.windows;
  bool get isMac => os == OperatingSystem.mac;
  bool get isLinux => os == OperatingSystem.linux;
  bool get isDesktop => isWindows || isMac || isLinux;

  bool get isFuschia => os == OperatingSystem.fuschia;

  bool get isWeb => os == OperatingSystem.web;

  bool get isOther => os == OperatingSystem.other;

  double scale(double dimension, {bool ignoreOffset = false}) {
    var value = dimension * scaleRatio;
    if (!ignoreOffset) value *= scaleFactor;
    return value;
  }

  double scaleClamped(double dimension, {double min, double max, bool ignoreOffset = false}) {
    var value = scale(dimension, ignoreOffset: ignoreOffset);
    if (min != null) value = Math.min(value, min);
    if (max != null) value = Math.max(value, max);
    return value;
  }

  Size scaleSize(Size size, {bool ignoreOffset = false}) {
    var value = size * scaleRatio;
    if (!ignoreOffset) value *= scaleFactor;
    return value;
  }
  
  Size scaleSizeClamped(Size size, {double minWidth, double minHeight, double maxWidth, double maxHeight, bool ignoreOffset = false}) {
    var value = scaleSize(size, ignoreOffset: ignoreOffset);
    if (minWidth != null || minHeight != null) {
      value = Size(
        minWidth == null ? value.width : Math.min(value.width, minWidth), 
        minHeight == null ? value.height : Math.min(value.height, minHeight),
      );
    }
    if (maxWidth != null || maxHeight != null) {
      value = Size(
        maxWidth == null ? value.width : Math.max(value.width, maxWidth), 
        maxHeight == null ? value.height : Math.max(value.height, maxHeight),
      );
    }
    return value;
  }

  Offset scaleOffset(Offset offset, {bool ignoreOffset = false}) {
    var value = offset * scaleRatio;
    if (!ignoreOffset) value *= scaleFactor;
    return value;
  }
  
  Offset scaleOffsetClamped(Offset offset, {double minX,  double minY, double maxX, double maxY, bool ignoreOffset = false}) {
    var value = scaleOffset(offset, ignoreOffset: ignoreOffset);
    if (minX != null || minY != null) {
      value = Offset(
        minX == null ? value.dx : Math.min(value.dx, minX), 
        minY == null ? value.dy : Math.min(value.dy, minY),
      );
    }
    if (maxX != null || maxY != null) {
      value = Offset(
        maxX == null ? value.dx : Math.max(value.dx, maxX), 
        maxY == null ? value.dy : Math.max(value.dy, maxY),
      );
    }
    return value;
  }

  double scaleFont({double fontSize, bool ignoreOffset = false}) {
    var value = (fontSize ?? _baseFontSize) * scaleRatio;
    if (!ignoreOffset) value *= scaleFactor;
    return value;
  }
  
  double scaleFontClamped({double fontSize, double min, double max, bool ignoreOffset = false}) {
    var value = scaleFont(fontSize: fontSize, ignoreOffset: ignoreOffset);
    if (min != null) value = Math.min(value, min);
    if (max != null) value = Math.max(value, max);
    return value;
  }

  double scaleIcon({double iconSize, bool ignoreOffset = false}) {
    var value = (iconSize ?? _baseIconSize) * scaleRatio;
    if (!ignoreOffset) value *= scaleFactor;
    return value;
  }
  
  double scaleIconClamped({double iconSize, double min, double max, bool ignoreOffset = false}) {
    var value = scaleIcon(iconSize: iconSize, ignoreOffset: ignoreOffset);
    if (min != null) value = Math.min(value, min);
    if (max != null) value = Math.max(value, max);
    return value;
  }
}