import 'package:baseflutter/base/BaseInnerWidget.dart';
import 'package:baseflutter/base/common/commonInsert.dart';

/// @author jm
class Mine extends BaseInnerWidget {
  @override
  BaseInnerWidgetState<BaseInnerWidget> getState() => MineState();

  @override
  int setIndex() => 1;

}

class MineState extends BaseInnerWidgetState<Mine> {
  @override
  Widget buildWidget(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Center(
        child: Text(
            "第二个页面"
        ),
      ),
    );
  }

  @override
  void onCreate() {
    /// 在BaseInnerWidget中，以下两个默认为false
    setTopBarVisible(true);
    setAppBarVisible(true);
    setAppBarTitle("Mine");
  }

  @override
  double getVerticalMargin() {
    // 与底部的间距，无要求给0即可
    return 0;
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