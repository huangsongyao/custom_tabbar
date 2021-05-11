import 'dart:async';

import 'package:custom_tab_bar/custom_tab_configs.dart';
import 'package:custom_tab_bar/custom_tab_indicator.dart';
import 'package:flutter/material.dart';

typedef HSYCustomTabBarGesture = void Function(
    HSYCustomTabBarItemConfigs itemConfigs);
typedef HSYCustomTabBarChangedItem = void Function(
    int index, HSYCustomTabBarItemConfigs itemConfigs, bool toChangedOthers);

class HSYCustomTabBar extends StatefulWidget {
  /// 默认选中的位置
  final int initSelectedIndex;

  /// TabBar的padding
  final EdgeInsets tabBarPadding;

  /// TabBar的背景
  final BoxDecoration backgroundDecoration;

  /// TabBar改变选中的item后的事件
  final HSYCustomTabBarChangedItem onChanged;

  /// TabBar的数据源
  final HSYCustomTabBarConfigs initTabBarConfigs;

  /// TabBar控制器
  final TabController tabController;

  /// 动画时间
  final Duration animatedDuration;

  /// TabBar高度
  final double tabHeights;

  /// 是否需要延迟监听，默认为true，为true时，会延迟[animatedDuration]的动画时间后再执行[onChanged]事件
  final bool delayedListener;

  HSYCustomTabBar({
    @required this.initTabBarConfigs,
    this.tabHeights = kToolbarHeight,
    this.tabBarPadding = EdgeInsets.zero,
    this.animatedDuration = const Duration(milliseconds: 350),
    this.initSelectedIndex = 0,
    this.delayedListener = true,
    this.backgroundDecoration,
    this.tabController,
    this.onChanged,
  });

  @override
  _HSYCustomTabBarState createState() => _HSYCustomTabBarState();
}

class _HSYCustomTabBarState extends State<HSYCustomTabBar>
    with TickerProviderStateMixin {
  int _selectedIndex;
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = this.widget.initSelectedIndex;
    _tabController = (this.widget.tabController ??
        TabController(
          initialIndex: _selectedIndex,
          length: this.widget.initTabBarConfigs.tabBarItemConfigs.length,
          vsync: this,
        ))
      ..addListener(
        () {
          if (_tabController.animation.status == AnimationStatus.completed &&
              _tabController.animation.isCompleted &&
              _tabController.index.toDouble() ==
                  _tabController.animation.value &&
              this.widget.onChanged != null) {
            Future.delayed(
              (this.widget.delayedListener
                  ? this.widget.animatedDuration
                  : Duration()),
              () {
                /// 切换其他tab时，通过这里返回事件
                print('切换其他tab时，通过这里返回事件');
                this.widget.onChanged(
                      _tabController.index,
                      this
                          .widget
                          .initTabBarConfigs
                          .itemConfigs[_tabController.index],
                      true,
                    );
              },
            );
          }
        },
      );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle selected =
        this.widget.initTabBarConfigs.selectedHighStyle(true);
    final TextStyle unselected =
        this.widget.initTabBarConfigs.selectedHighStyle(false);
    return Container(
      alignment: Alignment.center,
      height: this.widget.tabHeights,
      width: MediaQuery.of(context).size.width,
      decoration: this.widget.backgroundDecoration ??
          BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white,
              ],
            ),
          ),
      padding: (this.widget.initTabBarConfigs.tabPadding ??
          this.widget.tabBarPadding),
      child: TabBar(
        isScrollable: true,
        controller: _tabController,
        indicator: CustomIndicator(
          radius: this.widget.initTabBarConfigs.tabBarIndicatorConfig.radius,
          indicatorWidth:
              this.widget.initTabBarConfigs.tabBarIndicatorConfig.widths,
          indicatorHeights:
              this.widget.initTabBarConfigs.tabBarIndicatorConfig.heights,
          colors: this.widget.initTabBarConfigs.tabBarIndicatorConfig.colors,
        ),
        labelStyle: selected,
        labelColor: selected.color,
        unselectedLabelStyle: unselected,
        unselectedLabelColor: unselected.color,
        labelPadding: EdgeInsets.zero,
        tabs: (this.widget.initTabBarConfigs.tabBarItemConfigs.isNotEmpty
            ? this.widget.initTabBarConfigs.tabBarItemConfigs.map((item) {
                final int index = this
                    .widget
                    .initTabBarConfigs
                    .tabBarItemConfigs
                    .indexOf(item);
                return _HSYCustomTabBarItem(
                  configs: item,
                  onTap: (HSYCustomTabBarItemConfigs item) {
                    _animatedTo(
                      index: index,
                      item: item,
                    );
                  },
                );
              }).toList()
            : []),
      ),
    );
  }

  void _animatedTo({
    int index,
    HSYCustomTabBarItemConfigs item,
  }) {
    assert(
      (this.widget.initTabBarConfigs.tabBarItemConfigs ?? []).length >
          _selectedIndex,
      'index位置越界',
    );
    if (_selectedIndex == index && this.widget.onChanged != null) {
      /// 点击同一个tab时，通过这里返回事件
      this.widget.onChanged(
            _selectedIndex,
            item,
            false,
          );
    }
    _selectedIndex = index;
    _tabController.animateTo(
      _selectedIndex,
      duration: this.widget.animatedDuration,
      curve: Curves.ease,
    );
  }
}

class _HSYCustomTabBarItem extends StatelessWidget {
  final bool showIcons;
  final HSYCustomTabBarAlign align;
  final HSYCustomTabBarItemConfigs configs;
  final HSYCustomTabBarGesture onTap;

  _HSYCustomTabBarItem({
    Key key,
    this.showIcons = false,
    this.align = HSYCustomTabBarAlign.IconInTop,
    @required this.configs,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Text text = Text(
      this.configs.text,
    );
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: this.configs.horizontals),
        child: (this.showIcons
            ? _buildItems(
                align: this.align,
                text: text,
              )
            : text),
      ),
      onTap: () {
        this.onTap(this.configs);
      },
    );
  }

  Widget _buildItems({
    HSYCustomTabBarAlign align,
    Text text,
  }) {
    final Image icon = Image.asset(
      this.configs.icons,
      width: this.configs.iconSize.width,
      height: this.configs.iconSize.height,
    );
    switch (align) {
      case HSYCustomTabBarAlign.IconInTop:
        return Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              icon,
              SizedBox(
                height: this.configs.offsets,
              ),
              text,
            ],
          ),
        );
        break;
      case HSYCustomTabBarAlign.IconInBottom:
        return Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              text,
              SizedBox(
                height: this.configs.offsets,
              ),
              icon,
            ],
          ),
        );
        break;
      case HSYCustomTabBarAlign.IconInLeft:
        return Container(
          alignment: Alignment.center,
          child: Row(
            children: [
              icon,
              SizedBox(
                width: this.configs.offsets,
              ),
              text,
            ],
          ),
        );
        break;
      case HSYCustomTabBarAlign.IconInRight:
        return Container(
          alignment: Alignment.center,
          child: Row(
            children: [
              text,
              SizedBox(
                width: this.configs.offsets,
              ),
              icon,
            ],
          ),
        );
        break;
    }
    return Container();
  }
}
