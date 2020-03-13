# baseFlutter

base flutter to design

一个简单的flutter封装，包括网络请求，基类等，以及一些常用的方法，包括一个简单的多语言实现。

参考大佬：https://github.com/385841539/flutter_BaseWidget.git

## Getting Started

这个不是plugin插件。主要做参考，可自己移植，并导入或修改相关包。  

# 移植所需要的文件
【1】*lib*下的所有文件覆盖到自己的项目下  
【2】*assets*下的目录结构，*language.json*为语言转换文件  
【3】*pubspec.yaml*的dependencies（有需要可自己调整版本）  
【4】android与iOS的相关权限等配置需自己添加  

## 页面结构
*lib*目录下分为：
  --base -- 基类  
  --dialog -- 弹窗  
  --generated -- 自动生成的model管理文件  
  --network -- 网络相关与model  
  --res -- 资源管理  
  --ui -- 页面与组件  
  --utils -- 工具与管理器  
  
assets目录下可分为
  --images
    --android
      --hdpi
      --mdpi
      --xhdpi
      --xxhdpi
      --xxxhdpi
    --ios
   language.json
    

## 1.在main中进行各资源第三方的初始化
例：
```dart
void realRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  //将LocalStorage 异步转为同步
  bool success = await LocalStorage.getInstance();
  assert(success);
  //加载语音库
  await LanguageUtil.loadLanguage();
  runApp(MyApp());
}
```
  MyApp中可以做一些全局的设置管理，如默认字体样式
  
## 2.普通页面构建
【1】继承（extends） 使用 *BaseWidget* 代替 StatefulWidget ，*BaseWidgetState* 代替BaseWidgetState；
但是 组件（Widget） 依旧是用StatefulWidget，要分清楚页面与组件的区别。

【2】**BaseWidget**封装了页面状态，完善了生命周期（参考Android），  
  主要有onCreate，onResume, onPause, onDestory。替代initState等方法。  
  可以在  
    onCreate进行初始化处理  
    onResume中进行网络请求  
    onDestory中释放资源  
    
【3】**BaseFunction**中封装了页面布局结构等，并与网络请求等结合。  
  如状态栏，标题，body，loading，error等  
  get相关的方法均可以在继承了BaseWidget的页面中进行**重写**（override）  
  set相关的方法可以调用以修改单独页面的特定属性。  
  
  loading，error等可以修改为项目所需的样式。与封装的网络请求结合使用。  
  网络请求例子：  
  ```dart
    RequestUtil.testRequest(ShowLoadingIntercept(this), "data").listen((event) { 
      //请求成功
    }).onError((e) {
      //请求失败
      log(e.messgae);
    });
  ```
  需传入ShowLoadingIntercept拦截器（可自定义）才能有loading等，
    在StatefulWidget的组件中可通过传入BaseFunction参数来使用，不需要loading可传null
  ```
  ShowLoadingIntercept(widget.baseFunction)
  ```
  
  也可手动调用loading展示
  ```
  setLoadingWidgetVisible(true);
  ```
  
  具体可以查看BaseFunction，均有注释。
  
## 导航页的构建  
新建一个继承BaseWidget的“底”，使用*BaseTabBarWidget*作为导航栏。  
例：
```
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
```
其中 Home Mine 页面继承 *BaseInnerWidget*  
setIndex需设置为第X个页面  
```dart
  @override
  int setIndex() => 0;
```

**需注意的是**，
  作为“底”的Lead，要在onCreate中设置状态栏和标题栏不显示（除非需要导航的所有页面都有同样的标题栏）  
  在页面中需要状态栏和标题栏的在onCreate设置显示，默认为不显示。  
  


  
  
  






