# custom_tab_bar

高度自定义TabBar

# Getting Started

正常的TabBar方式使用。

HSYCustomTabBar: 自定义的TabBar小部件，内部实现了对TabBar的自定义效果
HSYCustomTabBarConfigs: 自定义TabBar的定义参数模型及相关内容
CustomIndicator: 自定义的indicator指示器

# example

```
_configs = [
      HSYCustomTabBarItemConfigs(text: '已入金'),
      HSYCustomTabBarItemConfigs(text: '已注册'),
      HSYCustomTabBarItemConfigs(text: '已交易'),
      HSYCustomTabBarItemConfigs(text: '已认证'),
      HSYCustomTabBarItemConfigs(text: '已理财'),
      HSYCustomTabBarItemConfigs(text: '已登录')
    ];

```

``` 

HSYCustomTabBar(
            tabController: _tabController,
            initTabBarConfigs: HSYCustomTabBarConfigs(
              itemConfigs: _configs,
              indicatorConfig:
                  HSYCustomTabBarIndicatorConfig.indicator3(Size(20.0, 2.0)),
            ),
            onChanged: (int index, HSYCustomTabBarItemConfigs itemConfigs) {
              print(
                  '------------index=${index}----------itemConfigs.text:${itemConfigs.text}');
            },
          )

```