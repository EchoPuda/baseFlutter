import 'package:flutter/material.dart';

/// 底部或顶部的导航栏
class BaseTabBarWidget extends StatefulWidget {
  static const int BOTTOM_TAB = 1;

  static const int TOP_TAB = 2;

  final int type;

  /// 底部tab時傳BottomNavigationBarItem
  final List<dynamic> tabItems;

  final List<Widget> tabViews;

  final Color backgroundColor;

  final Color indicatorColor;

  final Widget title;

  final Widget drawer;

  final Widget floatingActionButton;

  final TarWidgetControl tarWidgetControl;

  final PageController pageControl;

  final ValueChanged<int> onPageChanged;

  BaseTabBarWidget(
      {Key key,
      this.type : 1,
      this.tabItems,
      this.tabViews,
      this.backgroundColor,
      this.indicatorColor,
      this.title,
      this.drawer,
      this.floatingActionButton,
      this.tarWidgetControl,
      this.pageControl,
      this.onPageChanged})
      : super(key: key);

  @override
  _BaseTabBarState createState() => new _BaseTabBarState(
      type,
      backgroundColor,
      indicatorColor,
      title,
      drawer,
      floatingActionButton,
      pageControl,
      onPageChanged);
}

class _BaseTabBarState extends State<BaseTabBarWidget>
    with SingleTickerProviderStateMixin {
  final int _type;

  final Color _backgroundColor;

  final Color _indicatorColor;

  final Widget _title;

  final Widget _drawer;

  final Widget _floatingActionButton;

  final PageController _pageController;

  final ValueChanged<int> _onPageChanged;

  int currentPage = 0;

  _BaseTabBarState(
      this._type,
      this._backgroundColor,
      this._indicatorColor,
      this._title,
      this._drawer,
      this._floatingActionButton,
      this._pageController,
      this._onPageChanged)
      : super();

  TabController _tabController;

  @override
  void initState() {
    super.initState();

    ///初始化时创建控制器
    ///通过 with SingleTickerProviderStateMixin 实现动画效果。
    _tabController = new TabController(vsync: this, length: widget.tabItems.length);
  }

  @override
  void dispose() {
    ///页面销毁时，销毁控制器
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///顶部TAbBar模式
    if (this._type == BaseTabBarWidget.TOP_TAB) {
      return new Scaffold(
        ///设置侧边滑出 drawer，不需要可以不设置
        drawer: _drawer,

        ///设置悬浮按键，不需要可以不设置
        floatingActionButton: _floatingActionButton,

        ///标题栏
//        appBar: new AppBar(
//          backgroundColor: _backgroundColor,
//          title: _title,
//          ///tabBar控件
//          bottom: new TabBar(
//            ///顶部时，tabBar为可以滑动的模式
//            isScrollable: true,
//            ///必须有的控制器，与pageView的控制器同步
//            controller: _tabController,
//            ///每一个tab item，是一个List<Widget>
//            tabs: _tabItems,
//            ///tab底部选中条颜色
//            indicatorColor: _indicatorColor,
//          ),
//        ),
        ///页面主体，PageView，用于承载Tab对应的页面
        body: new PageView(
          ///必须有的控制器，与tabBar的控制器同步
          controller: _pageController,

          ///每一个 tab 对应的页面主体，是一个List<Widget>
          children: widget.tabViews,

          ///页面触摸作用滑动回调，用于同步tab选中状态
          onPageChanged: (index) {
            _tabController.animateTo(index);
            _onPageChanged?.call(index);
          },
        ),
      );
    }

    ///底部TAbBar模式
    return new Scaffold(

        ///设置侧边滑出 drawer，不需要可以不设置
        drawer: _drawer,

        ///设置悬浮按键，不需要可以不设置
        floatingActionButton: _floatingActionButton,

        ///标题栏
//        appBar: new AppBar(
//          backgroundColor: _backgroundColor,
//          title: _title,
//        ),
        ///页面主体，PageView，用于承载Tab对应的页面
        body: new PageView(
          ///必须有的控制器，与tabBar的控制器同步
          controller: _pageController,

          physics: NeverScrollableScrollPhysics(),

          ///每一个 tab 对应的页面主体，是一个List<Widget>
          children: widget.tabViews,
          onPageChanged: (index) {
            ///页面触摸作用滑动回调，用于同步tab选中状态
            _tabController.animateTo(index);
            _onPageChanged?.call(index);
            setState(() {
              this.currentPage = index;
            });
          },
        ),

        ///底部导航栏，也就是tab栏
        bottomNavigationBar: new BottomNavigationBar(
          items: widget.tabItems,
          onTap: (int position){
            _pageController.jumpToPage(position);
          },
          iconSize: 40,
          currentIndex: currentPage,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: _indicatorColor,
          selectedFontSize: 10,
          unselectedFontSize: 10,
        ),);
  }
}

class TarWidgetControl {
  List<Widget> footerButton = [];
}
