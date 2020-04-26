import 'package:baseflutter/base/common/commonInsert.dart';

import '../network/intercept/showloading_intercept.dart';
import '../utils/bus/TestEventBus.dart';
import 'Lead.dart';
import 'home/TestChange.dart';

/// 测试页
/// @author puppet
class TestPage extends BaseWidget {
  static const String TEST_PAGE = "/test_page";

  @override
  BaseWidgetState<BaseWidget> getState() => TestPageState();

}

class TestPageState extends BaseWidgetState<TestPage> {

  ///
  /// () {} 与 () => (){}
  /// 后者可相当于前者的简写，即
  /// onTap: () {
  ///   onMyTap();
  /// },
  /// 与
  /// onTap: () => onMyTap(),  //注意括号
  /// 是一样的。
  ///
  /// 当然假如onMyTap的类型和参数跟onTap的一致，那更可以简写为
  /// onTap: onMyTap,  //注意没括号
  /// 不过() => (){}只有在仅有一行语句的时候简写
  /// 比如 onTap: () {
  ///    onMyTap();
  ///    onOtherTap();
  /// },
  /// 无法简写。
  ///
  ///
  /// UI编译时，有括号和没括号的区别：
  /// 无括号 :
  ///   如 onTap: onMyTap,  //注意没有括号
  ///   void onMyTap(var m) {}
  ///   也可以 onTap：(m) => onMyTap(m)  注意后面的要有括号及传值，
  ///   前面括号内容视提供onTap的该方法是否有回调参数而定
  ///
  /// 有括号 :
  ///   即是需要返回规定的对象
  ///   () {
  ///     return m; // 注意这个return，必须要返回规定的对象
  ///   }
  ///
  ///   如：
  ///     ···
  ///       Container(
  ///         child: MyWidget(),  //注意有括号
  ///       ),
  ///     ···
  ///     Widget MyWidget(
  ///       return Container();  //返回规定的widget
  ///     )
  ///
  /// 所以可以简单做个区别，
  /// 当构建UI时，
  ///   如果没有括号，即是回调并调用你提供的方法； onTap: onTap,
  ///   如果有括号，即是需要你提供规定的对象； child: Container(),
  ///
  /// 所以点击事件 onTap: onTap(), 是错误的写法，
  /// *但不会报错，因为语法没问题，但主次不对。点击事件不会响应。或者一直响应
  /// child: Container, 会直接报错，因为没有提供需要的对象
  ///
  ///

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  /// 改語言
  Future<void> _changeLanguage() async {
    if (!mounted) {
      return;
    }
    setState(() {
      if (LanguageUtil.currentLanguage == SwitchLanguage.eg) {
        LanguageUtil.changeLanguage(SwitchLanguage.zh);
      } else {
        LanguageUtil.changeLanguage(SwitchLanguage.eg);
      }
    });
  }

  Future<void> _onPressed() async {
    await _changeLanguage();
  }

  /// 请求测试
  Future _requestTest() async {
    await RequestUtil.testRequest(ShowLoadingIntercept(this), 94).then((event) {
      // 成功处理
      print(event.data);
    }, onError: (e) {
      // 错误处理
      log(e.message.toString());
    });
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Container(
        key: _scaffoldKey,
        width: double.maxFinite,
        height: double.maxFinite,
        color: MyColors.background,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      LanguageUtil.getText("test"),
                    ),
                    SizedBox(height: 30,),
                    GestureDetector(
                      onTap: () {
                        BaseCommon.openPage(context, TestChange());
                      },
                      child: Text(
                        LanguageUtil.getText("click to next picture"),
                        style: TextStyle(
                          fontSize: 15,
                          color: MyColors.blue,
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    GestureDetector(
                      onTap: () {
                        BaseCommon.openPage(context, Lead());
                      },
                      child: Text(
                        LanguageUtil.getText("go to Lead"),
                        style: TextStyle(
                          fontSize: 15,
                          color: MyColors.blue,
                        ),
                      ),
                    )
                  ],
                )
            ),
            Positioned(
              bottom: 40,
              child: FlatButton(
                onPressed: () => _onPressed(),
                child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: MyColors.yellow,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Center(
                        child: Text(
                          LanguageUtil.getText("change"),
                          style: TextStyle(
                            fontSize: 14,
                            color: MyColors.white,
                          ),
                        ),
                      ),
                    )
                ),
              ),
            ),
          ],
        )
    );
  }

  /// 抽屉
  @override
  Drawer getDrawer() {
    // TODO: implement getDrawer
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
              child: Center(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Center(
                      child: Text(
                        "D",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 19
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ),
          Text(
              "第一个标题"
          ),
        ],
      ),
    );
  }

  @override
  Widget getAppBarLeft() {
    return InkWell(
      onTap: () {
        Scaffold.of(_scaffoldKey.currentContext).openDrawer();
      },
      child: Center(
        child: Icon(Icons.menu,color:Colors.black54,),
      ),
    );
  }

  @override
  void onCreate() {
    setTopBarVisible(true);
    setAppBarVisible(true);
    setAppBarTitle("Home");

    /// 监听
    TestEventBus().bus.on<RefreshEvent>().listen((event) {
      log(event.data);
      _changeLanguage();
    });
  }

  @override
  void onPause() {
  }

  @override
  void onResume() {
    _requestTest();
  }

}