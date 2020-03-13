import 'package:baseflutter/utils/LocalImageSelecter.dart';
import 'package:baseflutter/utils/ScreanAdapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'buildConfig.dart';

/// base 类 常用的一些工具类 ， 放在这里就可以了
/// get方法均可以重写，set方法可直接调用设置
abstract class BaseFuntion {
  State _stateBaseFunction;
  BuildContext _contextBaseFunction;

  bool _isTopBarShow = true; //状态栏是否显示
  bool _isAppBarShow = true; //导航栏是否显示
  bool _isAppBarBottomShow = true; //导航栏底部是否显示

  bool _isErrorWidgetShow = false; //错误信息是否显示

  Color _topBarColor = Colors.transparent;
  Color _appBarColor = Colors.white;
  Color _appBarContentColor = Colors.black54;
  Color _appBarBottomLineColor = Colors.grey[300];
  Widget _appBarRightContent;
  bool _topBarStyle = false;

  Function _backIconClick;

  //标题字体大小
  double _appBarCenterTextSize = 20; //根据需求变更
  String _appBarTitle;

  //小标题信息
  String _appBarRightTitle;
  double _appBarRightTextSize = 15.0;
  double _appBarBottomLineheight = 0.5;

  String _errorContentMesage = "网络错误啦~~~";

  String _errImgPath = "assets/images/load_error_view.png";

  bool _isLoadingWidgetShow = false;

  bool _isEmptyWidgetVisible = false;

  String _emptyWidgetContent = "暂无数据~";

  String _emptyImgPath = "assets/images/ic_empty.png"; //自己根据需求变更
  bool _isBackIconShow = true;

  FontWeight _fontWidget = FontWeight.w600; //错误页面和空页面的字体粗度

  double bottomVsrtical = 0; //作为内部页面距离底部的高度

  ///有需要的话就重写以下的方法
  ///-----------------------------
  void initBaseCommon(State state, BuildContext context) {
    _stateBaseFunction = state;
    _contextBaseFunction = context;
    if (BuildConfig.isDebug) {
      _appBarTitle = "";
      _appBarRightTitle = "";
    }
  }

  BuildContext get contextBase {
    return _contextBaseFunction;
  }

  Widget getBaseView(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Column(
        children: <Widget>[
          _getBaseTopBar(),
          _getBaseAppBar(),
          Expanded(
            flex: 1,
            child: Container(
              width: getScreenWidth(),
              color: Colors.white, //背景颜色，可自己变更
              child: Stack(
                children: <Widget>[
                  buildWidget(context),
                  _getBaseErrorWidget(),
                  _getBaseEmptyWidget(),
                  _getBassLoadingWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBaseTopBar() {
    return Offstage(
      offstage: !_isTopBarShow,
      child: getTopBar(),
    );
  }

  Widget _getBaseAppBar() {
    return Offstage(
      offstage: !_isAppBarShow,
      child: getAppBar(),
    );
  }

  ///设置状态栏，可以自行重写拓展成其他的任何形式
  Widget getTopBar() {
    return Container(
      height: getTopBarHeight(),
      width: double.infinity,
      color: _topBarColor,
    );
  }

  /// 状态栏主题
  bool getTopBarStyle() {
    return _topBarStyle;
  }

  /// 设置状态栏主题
  void setTopBarStyle(bool topBarStyle) {
    if (topBarStyle != null) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction.setState(() {
        _topBarStyle = topBarStyle;
      });
    }
  }

  ///导航栏 appBar 可以重写
  Widget getAppBar() {
    return Container(
      height: getAppBarHeight(),
      width: double.infinity,
      color: _appBarColor,
      child: Stack(
        alignment: FractionalOffset(0, 0.5),
        children: <Widget>[
          Align(
            alignment: FractionalOffset(0.5, 0.5),
            child: getAppBarCenter(),
          ),
          Positioned(
            //左边返回导航 的位置，可以根据需求变更
            left: 15,
            child: Offstage(
              offstage: !_isBackIconShow,
              child: getAppBarLeft(),
            ),
          ),
          Positioned(
            right: 15,
            child: getAppBarRight(),
          ),
          Positioned(
            bottom: 0,
            child: getAppBarBottom(),
          ),
        ],
      ),
    );
  }

  ///暴露的错误页面方法，可以自己重写定制
  Widget getErrorWidget() {
    return Container(
      //错误页面中心可以自己调整
      padding: EdgeInsets.fromLTRB(0, 0, 0, 200),
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: InkWell(
          onTap: onClickErrorWidget,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage(_errImgPath),
                width: 150,
                height: 150,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(_errorContentMesage,
                    style: TextStyle(
                      fontWeight: _fontWidget,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///点击错误页面后展示内容
  void onClickErrorWidget() {
    onResume(); //此处 默认onResume 就是 调用网络请求，
  }

  Widget getLoadingWidget() {
    return Container(
      //加载页面可以自己调整
      padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
      color: Colors.black12,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child:
        // 圆形进度条
        new CircularProgressIndicator(
          strokeWidth: 4.0,
          backgroundColor: Colors.blue,
          // value: 0.2,
          valueColor: new AlwaysStoppedAnimation<Color>(_appBarColor),
        ),
      ),
    );
  }

  ///导航栏appBar中间部分 ，不满足可以自行重写
  Widget getAppBarCenter() {
    return Text(
      _appBarTitle,
      style: TextStyle(
        fontSize: _appBarCenterTextSize,
        color: _appBarContentColor,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  ///导航栏appBar右边部分 ，不满足可以自行重写
  Widget getAppBarRight() {
    return _appBarRightContent ?? Text(
      _appBarRightTitle == null ? "" : _appBarRightTitle,
      style: TextStyle(
        fontSize: _appBarRightTextSize,
        color: _appBarContentColor,
      ),
    );
  }

  ///导航栏appBar左边部分 ，不满足可以自行重写
  Widget getAppBarLeft() {
    return InkWell(
      onTap: clickAppBarBack,
      child: Icon(
        Icons.arrow_back_ios,
        color: _appBarContentColor,
        size: 20,
      ),
    );
  }

  ///导航栏appBar底部部分 ，不满足可以自行重写
  Widget getAppBarBottom() {
    return Offstage(
      offstage: !_isAppBarBottomShow,
      child: Container(
        height: _appBarBottomLineheight,
        width: double.maxFinite,
        color: _appBarBottomLineColor,
      ),
    );
  }

  void clickAppBarBack() async {
    _backIconClick ?? getBackEvent(_contextBaseFunction);
  }

  /// 返回事件
  Future getBackEvent(BuildContext context) async {
    if (Navigator.canPop(_contextBaseFunction)) {
      Navigator.of(_contextBaseFunction).pop();
    } else {
      finishDartPageOrApp();
    }
  }

//
//
//  defaultRouteName → String 启动应用程序时嵌入器请求的路由或路径。
//  devicePixelRatio → double 每个逻辑像素的设备像素数。 例如，Nexus 6的设备像素比为3.5。
//  textScaleFactor → double 系统设置的文本比例。默认1.0
//  toString（） → String 返回此对象的字符串表示形式。
//  physicalSize → Size 返回一个包含屏幕宽高的对象，单位是dp
//
//

  ///返回中间可绘制区域，也就是 我们子类 buildWidget 可利用的空间高度
  double getMainWidgetHeight() {
    double screenHeight = getScreenHeight() - bottomVsrtical;

    if (_isTopBarShow) {
      screenHeight = screenHeight - getTopBarHeight();
    }
    if (_isAppBarShow) {
      screenHeight = screenHeight - getAppBarHeight();
    }

    return screenHeight;
  }

  ///返回屏幕高度
  double getScreenHeight() {
    return MediaQuery.of(_contextBaseFunction).size.height;
  }

  ///返回状态栏高度
  double getTopBarHeight() {
    return MediaQuery.of(_contextBaseFunction).padding.top;
  }

  ///返回appbar高度，也就是导航栏高度
  double getAppBarHeight() {
    return kToolbarHeight;
  }

  ///返回屏幕宽度
  double getScreenWidth() {
    return MediaQuery.of(_contextBaseFunction).size.width;
  }

  Widget _getBaseErrorWidget() {
    return Offstage(
      offstage: !_isErrorWidgetShow,
      child: getErrorWidget(),
    );
  }

  Widget _getBassLoadingWidget() {
    return Offstage(
      offstage: !_isLoadingWidgetShow,
      child: getLoadingWidget(),
    );
  }

  Widget _getBaseEmptyWidget() {
    return Offstage(
      offstage: !_isEmptyWidgetVisible,
      child: getEmptyWidget(),
    );
  }

  Widget getEmptyWidget() {
    return Container(
      //错误页面中心可以自己调整
      padding: EdgeInsets.fromLTRB(0, 0, 0, 200),
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                color: Colors.black12,
                image: AssetImage(_emptyImgPath),
                width: 150,
                height: 150,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(_emptyWidgetContent,
                    style: TextStyle(
                      fontWeight: _fontWidget,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 抽屉， 如需要需重写
  /// 抽屉顶部状态栏灰色解决方法：Drawer() 下的child设置padding为zero。
  Drawer getDrawer() {
    return null;
  }

  ///关闭最后一个 flutter 页面 ， 如果是原生跳过来的则回到原生，否则关闭app
  void finishDartPageOrApp() {
    SystemNavigator.pop();
  }

  ///设置状态栏隐藏或者显示
  void setTopBarVisible(bool isVisible) {
    // ignore: invalid_use_of_protected_member
    _stateBaseFunction.setState(() {
      _isTopBarShow = isVisible;
    });
  }

  ///默认这个状态栏下，设置颜色
  void setTopBarBackColor(Color color) {
    // ignore: invalid_use_of_protected_member
    _stateBaseFunction.setState(() {
      _topBarColor = color == null ? _topBarColor : color;
    });
  }

  ///设置导航栏的字体以及图标颜色
  void setAppBarContentColor(Color contentColor) {
    if (contentColor != null) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction.setState(() {
        _appBarContentColor = contentColor;
      });
    }
  }

  ///设置导航栏隐藏或者显示
  void setAppBarVisible(bool isVisible) {
    // ignore: invalid_use_of_protected_member
    _stateBaseFunction.setState(() {
      _isAppBarShow = isVisible;
    });
  }

  ///默认这个导航栏下，设置颜色
  void setAppBarBackColor(Color color) {
    // ignore: invalid_use_of_protected_member
    _stateBaseFunction.setState(() {
      _appBarColor = color == null ? _appBarColor : color;
    });
  }

  void setAppBarTitle(String title) {
    if (title != null) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction.setState(() {
        _appBarTitle = title;
      });
    }
  }

  void setAppBarRightTitle(String title) {
    if (title != null) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction.setState(() {
        _appBarRightTitle = title;
      });
    }
  }

  ///设置了这个设置的右边title将无效
  void setAppBarRightContent(Widget widget) {
    if (widget != null) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction.setState(() {
        _appBarRightContent = widget;
      });
    }
  }

  ///设置底部线是否显示
  void setAppBarBottomShow(bool isShow, {Color bottomColor, double height}) {
    if (isShow != null) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction.setState(() {
        _isAppBarBottomShow = isShow;
        if (bottomColor != null) {
          _appBarBottomLineColor = bottomColor;
        }
        if (height != null) {
          _appBarBottomLineheight = height;
        }
      });

    }

  }

  ///设置返回事件
  void setAppBarBackEvent(Function backFunc) {
    if (backFunc != null) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction.setState(() {
        _backIconClick = backFunc;
      });
    }
  }

  ///设置错误提示信息
  void setErrorContent(String content) {
    if (content != null) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction.setState(() {
        _errorContentMesage = content;
      });
    }
  }

  ///设置错误页面显示或者隐藏
  void setErrorWidgetVisible(bool isVisible) {
    // ignore: invalid_use_of_protected_member
    _stateBaseFunction.setState(() {
      if (isVisible) {
        //如果可见 说明 空页面要关闭啦
        _isEmptyWidgetVisible = false;
      }
      // 不管如何loading页面要关闭啦，
      _isLoadingWidgetShow = false;
      _isErrorWidgetShow = isVisible;
    });
  }

  ///设置空页面显示或者隐藏
  void setEmptyWidgetVisible(bool isVisible) {
    // ignore: invalid_use_of_protected_member
    _stateBaseFunction.setState(() {
      if (isVisible) {
        //如果可见 说明 错误页面要关闭啦
        _isErrorWidgetShow = false;
      }

      // 不管如何loading页面要关闭啦，
      _isLoadingWidgetShow = false;
      _isEmptyWidgetVisible = isVisible;
    });
  }

  void setLoadingWidgetVisible(bool isVisible) {
    // ignore: invalid_use_of_protected_member
    _stateBaseFunction.setState(() {
      _isLoadingWidgetShow = isVisible;
    });
  }

  ///设置空页面内容
  void setEmptyWidgetContent(String content) {
    if (content != null) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction.setState(() {
        _emptyWidgetContent = content;
      });
    }
  }

  ///设置错误页面图片
  void setErrorImage(String imagePath) {
    if (imagePath != null) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction.setState(() {
        _errImgPath = imagePath;
      });
    }
  }

  ///设置空页面图片
  void setEmptyImage(String imagePath) {
    if (imagePath != null) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction.setState(() {
        _emptyImgPath = imagePath;
      });
    }
  }

  /// 得到目前loading的状态
  bool loadingStatus() {
    return _isLoadingWidgetShow;
  }

  void setBackIconHinde({bool isHiinde = true}) {
    // ignore: invalid_use_of_protected_member
    _stateBaseFunction.setState(() {
      _isBackIconShow = !isHiinde;
    });
  }

  ///初始化一些变量 相当于 onCreate ， 放一下 初始化数据操作
  void onCreate() {
    log("create");
  }

  ///相当于onResume, 只要页面来到栈顶， 都会调用此方法，网络请求可以放在这个方法
  void onResume();

  ///页面被覆盖,暂停
  void onPause();

  ///返回UI控件 相当于setContentView()
  Widget buildWidget(BuildContext context);

  ///app切回到后台
  void onBackground() {
    log("回到后台");
  }

  ///app切回到前台
  void onForeground() {
    log("回到前台");
  }

  ///页面注销方法
  void onDestroy() {
    log("destroy");
  }

  /// 适配原理：
  ///   根据设计图中的总宽高和所需[width]，计算得出当前屏幕下的[width]。
  ///   但是，大多数情况下并不需要换算这个值！
  ///   系统默认距离单位是dp，简单来说就是会自动适配的单位，一般不同屏幕差距不大，不同于px。
  /// 随意使用很容易产生比例与设计图不一致的问题，因为设计图宽高比与实际宽高比不一致就会
  /// 产生这样的问题。比较明显的就是正方形变成长方形。
  ///   因此，一般的使用方法是：
  ///   当组件需要根据横向方向（竖直方向）分布时，适配设计图中的该组件的[width]，
  /// 但竖直方向（横向方向）不应适配，并且最好是不设置竖直方向（横向方向）的距离，
  /// 或者说赋予与横向方向（竖直方向）适配的值，假如是正方形的话。
  ///   通常整个页面的布局适配应利用margin、padding，或者position等属性值来实现，
  /// 使用该适配应是少数情况。
  ///
  /// 适配宽 (谨慎使用)
  double widthOf(double width) {
    return ScreenAdapter.getWidth(width);
  }

  /// 适配高 （谨慎使用）
  double heightOf(double height) {
    return ScreenAdapter.getHeight(height);
  }

  ///获取本地图片
  Image getImage(String imageName,
      {double imageWidth,
        double imageHeight,
        String type,
        BoxFit bFitFill,
        Key key,
        Color imageColor}) {
    return LocalImageSelector.getImage(imageName,
      imageWidth: imageWidth,
      imageHeight: imageHeight,
      type: type,
      bFitFill: bFitFill,
      imageColor: imageColor,
      key: key,
    );
  }

  /// 输入日志
  void log(String content) {
    print(getClassName() + "------:" + content);
  }

  String getClassName() {
    if (_contextBaseFunction == null) {
      return "";
    }
    String className = _contextBaseFunction.toString();
    if (className == null) {
      return "";
    }

    if (BuildConfig.isDebug) {
      try {
        className = className.substring(0, className.indexOf("("));
      } catch (err) {
        className = "";
      }
      return className;
    }

    return className;
  }
}
