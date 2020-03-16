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

移植并Packages get后，相应界面的import会报红，用ctrl+shift+r替换baseflutter 为你的项目名

## 页面结构    
*lib*目录下分为：     
  --base -- 基类  
  --dialog -- 弹窗  
  --generated -- 自动生成的model管理文件  
  --network -- 网络相关与model  
  --res -- 资源管理  
  --ui -- 页面与组件  
  --utils -- 工具与管理器  
  
*assets*目录下可分为     
  --images     
  ----android     
  ------hdpi    
  ------mdpi    
  ------xhdpi    
  ------xxhdpi    
  ------xxxhdpi    
  ----ios    
  --language.json    
  
## 配置dart的页面信息
Setting - File and Code Templates - Dart File 中设置：

```dart
import 'package:${PROJECT_NAME}/base/common/commonInsert.dart';

/// 
/// @author jm
class ${NAME} {

}
```
可导入基础的包以及建立默认class，有需要可自己设置

例，添加一个快速创建页面的dart：
![new dart page](https://github.com/EchoPuda/baseFlutter/blob/master/picture/example_1.jpg)

```dart
import 'package:${PROJECT_NAME}/base/common/commonInsert.dart';

/// 
/// @author jm
class ${NAME} extends BaseWidget {

  @override
  BaseWidgetState<BaseWidget> getState() => new ${NAME}State();

}

class ${NAME}State extends BaseWidgetState<${NAME}> {
  @override
  Widget buildWidget(BuildContext context) {
    return Container();
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
  }

  @override
  void onPause() {
    // TODO: implement onPause
  }

  @override
  void onResume() {
    // TODO: implement onResume
  }

}
```

## 1.在main中进行各资源第三方的初始化   
例：
```dart
void realRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  //将LocalStorage 异步转为同步
  bool success = await LocalStorage.getInstance();
  assert(success);
  //加载语言库
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
  ```dart
  ShowLoadingIntercept(widget.baseFunction)
  ```
  
  也可手动调用loading展示
  ```dart
  setLoadingWidgetVisible(true);
  ```
  
  具体可以查看BaseFunction，均有注释。
  
## 3.导航页的构建    
新建一个继承BaseWidget的“底”，使用***BaseTabBarWidget***作为导航栏。  
例：
```dart
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
其中 Home Mine 页面继承 ***BaseInnerWidget***
setIndex需设置为第X个页面  
```dart
  @override
  int setIndex() => 0;
```

**需注意的是**，   
  作为“底”的**Lead**，要在onCreate中设置**状态栏**和**标题栏**不显示（除非需要导航的所有页面都有同样的标题栏）;  
  在页面(**BaseInnerWidget**)中需要状态栏和标题栏的在onCreate设置显示，默认为不显示。  
  
## 4.基本方法封装     
**BaseCommon**是常用方法的封装  
包括 页面导航方法，网络图片 等， 常用的方法在该类进行复用。  

## 5.常量   
**Commons**常量需要专门管理

## 6.网络封装  
网络的相关配置在**HttpManager**中进行配置  
如何使用参考 *Address* 和 *RequestUtil* 中的写法。  

基础拦截器如 *BaseIntercept* ,可在其中进行拦截处理，比如请求前添加**token**
可增加额外的拦截器比如*ShowLoadingIntercept*, 并**继承** *BaseIntercept*

## 7.model   
model的构建需用一个插件：**FlutterJsonBeanFactory**

通过请求所得的json，在model下，根据json直接通过该插件 new一个model即可。    
创建的model在对应的请求接口上声明 *PublishSubject<**XXXModelEntity**>*  
即在listener中直接使用。  

## 8.res   
颜色，样式，字符等的相关管理。

## 9.多语言   
**LanguageUtil**为多语言管理器，通过读取assets中的json文件，得到相对应语言的翻译。  
在*runApp*前进行读取
```dart
  await LanguageUtil.loadLanguage();
```

使用：
```dart
  LanguageUtil.getText("test")
  
  //在BaseWidget页面可直接
  getText("text")
```

切换语言：
```dart
  // 必须要setState才能更改当前页面的语言，最好判断下mounted
  setState(() {
    LanguageUtil.changeLanguage(SwitchLanguage.zh);
  });
```

Language.json写法：
```java
{
  "test" : {
    "eg" : "test",
    "zh" : "测试"
  },
  "yes" : {
    "eg" : "yes",
    "zh" : "是"
  }
}
```

## 10.图片使用   
【1】本地图片, 返回Widget:
```dart
LocalImageSelecter.getImage("image")

// 在BaseWidget页面中可直接
getImage("image");
```
具体可看LocalImageSelecter

【2】网络图片，返回Widget:
```dart
BaseCommon.netImage("",20,20)
```

## 11.本地存取 LocalStorage   
在*runApp*前可将异步转为同步
```dart
  //将LocalStorage 异步转为同步
  bool success = await LocalStorage.getInstance();
```

存：
```dart
LocalStorage.save();
```
取：
```dart
LocalStorage.get();
```

## 12.距离转换（适配）, 谨慎使用！   
*ScreenAdapter*
根据设计图与实际屏幕的宽度（高度）计算得到相应比例的距离，  
但必须**谨慎使用**

**禁止**直接用该工具直接做适配，一个页面的适配不是靠一个工具就能实现

改工具适配原理(BaseFunction中也有强调)：
```dart
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
```

即，就单位来说，系统已经是有自己的适配，不需要我们画蛇添足给他们换算。  
仅有页面设计的布局拥挤且不可滚动，需要计算每一个控件的分布区域的少数特殊情况下，才需要用这个来计算。

## 13.EventBus 事件处理   
很有用的工具。  
当一个页面上的处理需要通知到另一个可见或不可见的页面进行处理时，就可利用这个工具进行通知。
例：同一级导航中，当我在 商场 消费了金币，需要同时保证 钱包 中的显示金额同步变化，但仅是切换导航（或者说返回页面）并不能调用接口更新，  
就可以通过bus发送一个**事件**，通知钱包页调用接口更新钱包数据。

一个bus的设计：
```dart
class TestEventBus {

  static final TestEventBus _gInstance = TestEventBus._init();

  EventBus _eventBus = EventBus();

  TestEventBus._init() {
    ///
  }

  factory TestEventBus() {
    return _gInstance;
  }

  EventBus get bus {
    return _eventBus;
  }

}

/// 事件
class RefreshEvent {
  String data;
  RefreshEvent({this.data});
}
```

监听：
```dart
  /// 监听
  TestEventBus().bus.on<RefreshEvent>().listen((event) {
    log(event.data);
  });
```

发送事件：
```dart
  /// 发送后所有添加了该监听的监听器都会收到
  TestEventBus().bus.fire(RefreshEvent(data: "数据"));
```

fire可以指定事件给予不同的数据，在相同bus的监听上都会受到信息。
