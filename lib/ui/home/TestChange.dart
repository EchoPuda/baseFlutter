import 'package:baseflutter/base/common/commonInsert.dart';
import 'package:baseflutter/utils/LanguageUtil.dart';
import 'package:baseflutter/utils/bus/TestEventBus.dart';

/// 
/// @author puppet
class TestChange extends BaseWidget {
  static const String TEST_CHANGE = "/test_change";

  @override
  BaseWidgetState<BaseWidget> getState() => new TestChangeState();

}

class TestChangeState extends BaseWidgetState {
  @override
  Widget buildWidget(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              getText("yes"),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                /// 发送后所有添加了该监听的监听器都会收到
                TestEventBus().bus.fire(RefreshEvent(data: "切换"));
                setState(() {
                });
              },
              child: Text(
                getText("notify previous page to switch language"),
                style: TextStyle(
                  fontSize: 15,
                  color: MyColors.text_font_red
                ),
              ),
            ),
          ],
        )
      ),
    );
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