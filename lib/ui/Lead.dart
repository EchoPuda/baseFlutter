
import 'package:baseflutter/base/BaseTabBarWidget.dart';
import 'package:baseflutter/base/common/commonInsert.dart';
import 'package:baseflutter/ui/Mine/Mine.dart';

import 'home/Home.dart';

/// 导航
/// @author jm
class Lead extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() => new LeadState();

}

class LeadState extends BaseWidgetState<Lead> {

  /// 页面控制
  PageController pageController = new PageController();
  /// 双击退出时间
  int backTime = 0;

  @override
  Widget buildWidget(BuildContext context) {
    // TODO: implement buildWidget
    return BaseTabBarWidget(
      tabItems: <BottomNavigationBarItem>[
        new BottomNavigationBarItem(
          icon: Icon(Icons.home,size: 22,),
          activeIcon: Icon(Icons.home,size: 22,color: MyColors.blue,),
          title: Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "Home",
            ),
          ),
        ),
        new BottomNavigationBarItem(
          icon: Icon(Icons.people,size: 22,),
          activeIcon: Icon(Icons.people,size: 22,color: MyColors.blue,),
          title: Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "Mine",
            ),
          ),
        ),
      ],
      tabViews: <Widget>[
        new Home(),
        new Mine(),
      ],
      pageControl: pageController,
      indicatorColor: MyColors.blue,
    );
  }

  @override
  Future getBackEvent(BuildContext context) async {

    if (backTime != 0 && DateTime.now().millisecondsSinceEpoch - backTime < 2000) {
//      finishDartPageOrApp();
      Navigator.of(context).pop();
    } else if (backTime != 0 && DateTime.now().millisecondsSinceEpoch - backTime > 2000){
      backTime = DateTime.now().millisecondsSinceEpoch;
      showToast("再点击一次退出");
    } else {
      backTime = DateTime.now().millisecondsSinceEpoch;
      showToast("再点击一次退出");
    }

  }

  @override
  void onCreate() {
    /// 必须得设置 状态栏 和 标题栏 为不显示
    setAppBarVisible(false);
    setTopBarVisible(false);
    setBackIconHinde();

  }

  @override
  void onDestroy() {
    // TODO: implement onDestory
    super.onDestroy();
  }

  @override
  void onPause() {
    // TODO: implement onPause
  }

  @override
  void onResume() {
    // TODO: implement onResume
  }

  @override
  void onBackground() {
    // TODO: implement onBackground
    super.onBackground();
  }

  @override
  void onForeground() {
    // TODO: implement onForeground
    super.onForeground();
  }

  bool isRemind = true;

}