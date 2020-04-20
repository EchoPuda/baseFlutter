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

  Future _requestTest() async {
    setLoadingWidgetVisible(true);
    RequestUtil.testRequest(ShowLoadingIntercept(this), "data").listen((event) {

    }).onError((e) {
      log(e.messgae);
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
                onPressed: _onPressed,
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

  }

}