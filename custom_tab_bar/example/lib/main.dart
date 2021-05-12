import 'package:custom_tab_bar/custom_tab_bar.dart';
import 'package:custom_tab_bar/custom_tab_configs.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: MyHomePage(
        title: 'TabBar',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _string = '已入金';

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: GestureDetector(
          child: Container(
            height: 100,
            color: Colors.amber,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Text(
              _string,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return TestCustomTabBar(
                    title: '测试自定义TabBar',
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class TestCustomTabBar extends StatefulWidget {
  final String title;

  TestCustomTabBar({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _TestCustomTabBarState createState() => _TestCustomTabBarState();
}

class _TestCustomTabBarState extends State<TestCustomTabBar>
    with TickerProviderStateMixin {
  TabController _tabController;
  List<HSYCustomTabBarItemConfigs> _configs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _configs = [
      HSYCustomTabBarItemConfigs(
        text: '已入金',
        horizontals: 16.0,
      ),
      HSYCustomTabBarItemConfigs(
        text: '已注册',
        horizontals: 16.0,
      ),
      HSYCustomTabBarItemConfigs(
        text: '已交易',
        horizontals: 16.0,
      ),
      HSYCustomTabBarItemConfigs(
        text: '已认证',
        horizontals: 16.0,
      ),
      HSYCustomTabBarItemConfigs(
        text: '已理财',
        horizontals: 16.0,
      ),
      HSYCustomTabBarItemConfigs(
        text: '已登录',
        horizontals: 16.0,
      ),
    ];
    _tabController = TabController(
      length: _configs.length,
      vsync: this,
    )..addListener(() {
        print(
            '------------_tabController.index=${_tabController.index}---------');
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          HSYCustomTabBar(
            delayedListener: false,
            tabController: _tabController,
            initTabBarConfigs: HSYCustomTabBarConfigs(
              itemConfigs: _configs,
              indicatorConfig:
                  HSYCustomTabBarIndicatorConfig.indicator3(Size(20.0, 2.0)),
              positioneds: [
                Positioned(
                  child: _buildOverlay(
                    heights: kToolbarHeight,
                  ),
                ),
                Positioned(
                  child: _buildOverlay(
                    heights: kToolbarHeight,
                    isLeft: false,
                  ),
                  right: 0.0,
                ),
              ],
            ),
            onChanged: (int index, HSYCustomTabBarItemConfigs itemConfigs,
                bool toChangedOthers) {
              print(
                  '------------index=${index}----------itemConfigs.text:${itemConfigs.text}');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay({
    bool isLeft = true,
    @required num heights,
  }) {
    final Widget overlay = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: (isLeft
              ? [
                  Colors.white,
                  Colors.white.withOpacity(0),
                ]
              : [
                  Colors.white.withOpacity(0),
                  Colors.white,
                ]),
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      height: heights,
      width: 40.0,
    );
    return overlay;
  }
}
