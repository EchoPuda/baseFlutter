import 'package:baseflutter/network/RequestUtil.dart';
import 'package:baseflutter/network/intercept/showloading_intercept.dart';
import 'package:baseflutter/ui/Lead.dart';
import 'package:baseflutter/ui/home/TestChange.dart';
import 'package:baseflutter/utils/LanguageUtil.dart';
import 'package:baseflutter/utils/LocalImageSelecter.dart';
import 'package:baseflutter/utils/bus/TestEventBus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:oktoast/oktoast.dart';
import 'package:baseflutter/base/common/commonInsert.dart';

/// @author jm
void main() => realRunApp();

void realRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  //将LocalStorage 异步转为同步
  bool success = await LocalStorage.getInstance();
  assert(success);

  await LanguageUtil.loadLanguage();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This ui.Mine.widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor:Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    return OKToast(
      position: ToastPosition.bottom,
      backgroundColor: MyColors.grey,
      child: MaterialApp(
          title: 'base_flutter',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: MyColors.white,
          ),
          routes: routes,
          home: Main()
      ),
    );
  }
}

class Main extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MainState();
}

class MainState extends State<Main>  {

  @override
  void initState() {
    super.initState();
    LocalImageSelector.init();
//    Commons.language = LocalStorage.get("language") ?? "eg";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;
    Commons.screenWidth = width;
    Commons.screenHeight = height;
    //TODO 设计图的宽高
    Commons.designWidth = 300;
    Commons.designHeight = 800;
    return HomePage();
  }
}

class HomePage extends BaseWidget {

  @override
  BaseWidgetState<BaseWidget> getState() => HomePageState();

}

class HomePageState extends BaseWidgetState<HomePage> {

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

///所有页面路由
Map<String,WidgetBuilder> routes = {

};
