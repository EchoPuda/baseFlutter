import 'package:baseflutter/network/RequestUtil.dart';
import 'package:baseflutter/network/intercept/showloading_intercept.dart';
import 'package:baseflutter/ui/LaunchPage.dart';
import 'package:baseflutter/ui/Lead.dart';
import 'package:baseflutter/ui/TestPage.dart';
import 'package:baseflutter/ui/home/TestChange.dart';
import 'package:baseflutter/utils/LanguageUtil.dart';
import 'package:baseflutter/utils/LocalImageSelecter.dart';
import 'package:baseflutter/utils/PermissionManager.dart';
import 'package:baseflutter/utils/ScreanAdapter.dart';
import 'package:baseflutter/utils/VersionInfo.dart';
import 'package:baseflutter/utils/bus/TestEventBus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:baseflutter/base/common/commonInsert.dart';

/// @author jm
void main() => realRunApp();

/// 在进入app前的初始化
void realRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  //将LocalStorage 异步转为同步
  await LocalStorage.getInstance();
  // 加载版本号
  await VersionInfo.getInstance();
  // 加载语言
  await LanguageUtil.loadLanguage();
  // 请求权限
  await PermissionManager.request();
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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;
    ScreenAdapter.screenWidth = width;
    ScreenAdapter.screenHeight = height;
    //TODO 设计图的宽高
    ScreenAdapter.designWidth = 300;
    ScreenAdapter.designHeight = 800;
    return LaunchPage();
  }
}

/// 所有页面路由
Map<String,WidgetBuilder> routes = {
  /// 测试页
  TestPage.TEST_PAGE : (context) => TestPage(),

};
