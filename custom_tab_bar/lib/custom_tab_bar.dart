import 'package:custom_tab_bar/custom_tab_configs.dart';
import 'package:custom_tab_bar/custom_tab_indicator.dart';
import 'package:flutter/material.dart';

typedef HSYCustomTabBarGesture = void Function(
    HSYCustomTabBarItemConfigs itemConfigs);
typedef HSYCustomTabBarChangedItem = void Function(
    int index, HSYCustomTabBarItemConfigs itemConfigs);

class HSYCustomTabBar extends StatefulWidget {
  final int initSelectedIndex;
  final EdgeInsets tabBarPadding;
  final BoxDecoration backgroundDecoration;
  final HSYCustomTabBarChangedItem onChanged;
  final HSYCustomTabBarConfigs initTabBarConfigs;
  final TabController tabController;
  final Duration animatedDuration;
  final double tabHeights;

  HSYCustomTabBar({
    @required this.initTabBarConfigs,
    this.tabHeights = kToolbarHeight,
    this.tabBarPadding = EdgeInsets.zero,
    this.animatedDuration = const Duration(milliseconds: 350),
    this.initSelectedIndex = 0,
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
              this.widget.animatedDuration,
              () {
                this.widget.onChanged(
                      _tabController.index,
                      this
                          .widget
                          .initTabBarConfigs
                          .itemConfigs[_tabController.index],
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
      padding: this.widget.tabBarPadding,
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
        tabs: (this.widget.initTabBarConfigs.tabBarItemConfigs.isNotEmpty
            ? this.widget.initTabBarConfigs.tabBarItemConfigs.map((item) {
                final int index = this
                    .widget
                    .initTabBarConfigs
                    .tabBarItemConfigs
                    .indexOf(item);
                return _HSYCustomTabBarItem(
                  configs: item,
                  textStyle: this
                      .widget
                      .initTabBarConfigs
                      .selectedHighStyle((_selectedIndex == index)),
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
    if (_selectedIndex == index && this.widget.onChanged != null) {
      this.widget.onChanged(_selectedIndex, item);
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
  final TextStyle textStyle;
  final HSYCustomTabBarAlign align;
  final HSYCustomTabBarItemConfigs configs;
  final HSYCustomTabBarGesture onTap;

  _HSYCustomTabBarItem({
    Key key,
    this.textStyle,
    this.showIcons = false,
    this.align = HSYCustomTabBarAlign.IconInTop,
    @required this.configs,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Text text = Text(
      this.configs.text,
      // style: this.textStyle,
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
