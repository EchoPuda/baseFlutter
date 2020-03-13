import 'package:baseflutter/base/common/commonInsert.dart';
import 'package:flutter/services.dart';

import 'CommonFunction.dart';
import 'NavigatorManger.dart';

/// 基类
/// @author puppet
abstract class BaseWidgetPage extends StatefulWidget {

  BaseWidgetPage({Key key}) : super(key: key);

  BaseWidgetPageState baseWidgetState;
  @override
  BaseWidgetPageState createState() {
    baseWidgetState = getState();
    return baseWidgetState;
  }

  BaseWidgetPageState getState();
  String getStateName() {
    return baseWidgetState.getClassName();
  }
}

abstract class BaseWidgetPageState<T extends BaseWidgetPage> extends State<T>
    with WidgetsBindingObserver, BaseFuntion {
  //平台信息
//  bool isAndroid = Platform.isAndroid;

  BaseFuntion getBaseFunction() {
    return this;
  }

  bool _onResumed = false; //页面展示标记
  bool _onPause = false; //页面暂停标记

  @override
  void initState() {
    initBaseCommon(this, context);
    NavigatorManger().addWidget(this);
    WidgetsBinding.instance.addObserver(this);
    onCreate();
    super.initState();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
//    log("----buildbuild---deactivate");
    //说明是被覆盖了
    if (NavigatorManger().isSecondTop(this)) {
      if (!_onPause) {
        onPause();
        _onPause = true;
      } else {
        onResume();
        _onPause = false;
      }
    } else if (NavigatorManger().isTopPage(this)) {
      if (!_onPause) {
        onPause();
      }
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
//    log("------buildbuild---build");
    if (!_onResumed) {
      //说明是 初次加载
      if (NavigatorManger().isTopPage(this)) {
        _onResumed = true;
        onResume();
      }
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getTopBarStyle() ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: WillPopScope(
        onWillPop: () => getBackEvent(context),
        child: Scaffold(
          drawer: getDrawer(),
          body: getBaseView(context),
        ),
      )
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    onDestroy();
    WidgetsBinding.instance.removeObserver(this);
    _onResumed = false;
    _onPause = false;

    //把该页面 从 页面列表中 去除
    NavigatorManger().removeWidget(this);
    //取消网络请求
    HttpManager.cancelHttp(getClassName());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    //此处可以拓展 是不是从前台回到后台
    if (state == AppLifecycleState.resumed) {
      //on resume
      if (NavigatorManger().isTopPage(this)) {
        onForeground();
        onResume();
      }
    } else if (state == AppLifecycleState.paused) {
      //onpause
      if (NavigatorManger().isTopPage(this)) {
        onBackground();
        onPause();
      }
    }
    super.didChangeAppLifecycleState(state);
  }
}