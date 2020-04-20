import 'package:baseflutter/base/common/commonInsert.dart';
import 'package:baseflutter/ui/TestPage.dart';
import 'package:baseflutter/utils/VersionInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../base/common/common.dart';
import '../res/colors.dart';
import '../utils/LocalStorage.dart';

/// 引导页
/// 一般启动页是根据app加载速度而由系统决定，不应主动显示。
/// 不应在引导页进行耗时操作或显示启动页导致引导页显示异常。
/// 所以获取版本判断应在app加载之前。
/// @author jm
class LaunchPage extends BaseWidget {

  LaunchPage({
    Key key,
  }) : super(key: key);

  @override
  BaseWidgetState<BaseWidget> getState() => new LaunchPageState();

}

class LaunchPageState extends BaseWidgetState<LaunchPage> {
  @override
  Widget buildWidget(BuildContext context) {
    return isShow ? launchPages : TestPage();
  }

  /// 引导页
  Widget get launchPages {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: backgroundColor,
      child: _getListLaunch().length == 0 ? Container() : Swiper(
        scrollDirection: Axis.horizontal,
        containerWidth: double.maxFinite,
        containerHeight: double.maxFinite,
        itemCount: _getListLaunch().length,
        autoplay: false,
        loop: false,
        itemBuilder: (BuildContext context, int index) {
          return _getListLaunch()[index];
        },
      ),
    );
  }

  bool isShow = false;
  /// 背景色
  Color backgroundColor = MyColors.white;
  /// 引导页路径
  String assetPath = "assets/images/";

  @override
  void onCreate() {
    /// 引导页一般全屏不显示状态栏
    setTopBarVisible(false);
    setAppBarVisible(false);

    // 判断版本是否更改
    String version = VersionInfo.deviceCode;
    if (LocalStorage.get(Commons.VERSION) == null
        || LocalStorage.get(Commons.VERSION) != version) {
      isShow = true;
      // TODO 若需求是点击了立即进入后下次登录才不显示，那便将save移动到立即进入中
      LocalStorage.save(Commons.VERSION, version);
    } else {
      isShow = false;
    }
  }

  @override
  void onPause() {
    // TODO: implement onPause
  }

  @override
  void onResume() {
    // TODO: implement onResume
  }

  /// 获取引导页
  /// 引导页的BoxFit属性需根据需求更改
  List<Widget> _getListLaunch() {
    List<Widget> list = new List();
    list = [
      Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Image.asset(assetPath + "launch1.jpg", fit: BoxFit.cover,),
      ),
      Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Image.asset(assetPath + "launch2.jpg",fit: BoxFit.cover,),
      ),
      Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                child: Image.asset(assetPath + "launch3.jpg",fit: BoxFit.cover,),
              ),
            ),

            Positioned(
              bottom: 60,
              child: GestureDetector(
                onTap: _go,
                child: Container(
                  width: 250,
                  height: 40,
                  decoration: BoxDecoration(
                    color: MyColors.blue,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "立即进入",
                    style: TextStyle(
                      fontSize: 18,
                      color: MyColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
    return list;
  }

  /// 立即进入
  void _go() {
    BaseCommon.closeAllAndOpenPage(context, TestPage());
  }

}