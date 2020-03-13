import 'package:baseflutter/base/BaseFunction.dart';
import 'base_intercept.dart';

class ShowLoadingIntercept extends BaseIntercept {
  ShowLoadingIntercept(BaseFunction baseFunction,
      {bool isDefaultFailure = true}) {
    this.baseFuntion = baseFunction;
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
