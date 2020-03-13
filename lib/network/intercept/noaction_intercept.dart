
import 'package:baseflutter/base/BaseFunction.dart';
import 'base_intercept.dart';

class NoActionIntercept extends BaseIntercept {
  NoActionIntercept(BaseFunction baseFuntion, {bool isDefaultFailure = true}) {
    this.baseFuntion = baseFuntion;
    this.isDefaultFailure = isDefaultFailure;
  }
  @override
  void afterRequest() {}

  @override
  void beforeRequest() {}
}
