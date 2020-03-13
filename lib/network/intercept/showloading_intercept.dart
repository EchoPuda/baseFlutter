import 'package:baseflutter/base/CommonFunction.dart';
import 'base_intercept.dart';

class ShowLoadingIntercept extends BaseIntercept {
  ShowLoadingIntercept(BaseFuntion baseFuntion,
      {bool isDefaultFailure = true}) {
    this.baseFuntion = baseFuntion;
    this.isDefaultFailure = isDefaultFailure;
  }
  @override
  void afterRequest() {
    if (baseFuntion != null) {
      baseFuntion.setLoadingWidgetVisible(false);
    }
  }

  @override
  void beforeRequest() {
    if (baseFuntion != null) {
      baseFuntion.setLoadingWidgetVisible(true);
    }
  }
}
