import 'package:flutter/material.dart';

enum HSYCustomTabBarAlign {
  IconInLeft,
  IconInRight,
  IconInTop,
  IconInBottom,
}

const double HSYCustomTabBarIndicatorHeights = 3.0;

class HSYCustomTabBarItemConfigs {
  /// item的title
  final String text;

  /// item的icon，如果以http开头，则自动适配，否则默认为本地图标
  final String icons;

  /// item的text的水平方向左右padding间距
  final num horizontals;

  /// item的icon的size
  final Size iconSize;

  /// 如果item的text和icon同时存在，则[offsets]表示二者间的间距
  final num offsets;

  HSYCustomTabBarItemConfigs({
    @required this.text,
    this.iconSize = const Size(35.0, 35.0),
    this.horizontals = 10.0,
    this.offsets = 5.0,
    this.icons,
  });
}

class HSYCustomTabBarIndicatorConfig {
  /// 指示器和text直接的间距
  final num tops;

  /// 指示器和整个tabbar底部的间距
  final num bottom;

  /// 指示器的宽度
  final num widths;

  /// 指示器的高度
  final num heights;

  /// 指示器圆角
  final num radius;

  /// 指示器的颜色，支持渐变色
  final List<Color> colors;

  HSYCustomTabBarIndicatorConfig({
    this.tops = 0,
    this.bottom = 0,
    this.widths = 24.0,
    this.heights = HSYCustomTabBarIndicatorHeights,
    this.radius = HSYCustomTabBarIndicatorHeights,
    this.colors = const [
      Colors.black,
      Colors.black,
    ],
  });

  factory HSYCustomTabBarIndicatorConfig.indicator() {
    return HSYCustomTabBarIndicatorConfig(
      tops: 8.0,
      bottom: 8.0,
      heights: HSYCustomTabBarIndicatorHeights,
      widths: kToolbarHeight,
      colors: [
        Color(0xFF02F260),
        Color(0xFF0575E6),
      ],
    );
  }
}

class HSYCustomTabBarConfigs {
  /// 如果item同时存在text和icon时，这个枚举表示text和icon的排序方式
  final HSYCustomTabBarAlign iconAlign;

  /// item的数据集合
  final List<HSYCustomTabBarItemConfigs> itemConfigs;

  /// tabbar的指示器配置数据
  final HSYCustomTabBarIndicatorConfig indicatorConfig;

  /// item的text的选中高亮的文本状态
  final TextStyle selectedStyle;

  /// item的text的非选中时的文本状态
  final TextStyle unselectedStyle;

  HSYCustomTabBarConfigs({
    @required this.itemConfigs,
    this.indicatorConfig,
    this.iconAlign = HSYCustomTabBarAlign.IconInTop,
    this.unselectedStyle,
    this.selectedStyle,
  });

  List<HSYCustomTabBarItemConfigs> get tabBarItemConfigs {
    return (this.itemConfigs ?? []);
  }

  HSYCustomTabBarIndicatorConfig get tabBarIndicatorConfig {
    return (this.indicatorConfig ?? HSYCustomTabBarIndicatorConfig.indicator());
  }

  TextStyle selectedHighStyle(bool selected) {
    return (selected
        ? (this.selectedStyle ??
            TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ))
        : (this.unselectedStyle ??
            TextStyle(
              fontSize: 15,
              color: Colors.black45,
            )));
  }
}
