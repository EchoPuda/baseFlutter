import 'package:baseflutter/base/common/commonInsert.dart';
import 'package:baseflutter/utils/LanguageUtil.dart';

/// 
/// @author puppet
class TestChange extends BaseWidgetPage {
  static const String TEST_CHANGE = "/test_change";

  @override
  BaseWidgetPageState<BaseWidgetPage> getState() => new TestChangeState();

}

class TestChangeState extends BaseWidgetPageState {
  @override
  Widget buildWidget(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          LanguageUtil.getText(MyStrings.yes),
        ),
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