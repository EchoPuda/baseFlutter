
import 'package:baseflutter/base/CommonFunction.dart';
import 'base_intercept.dart';

class NoActionIntercept extends BaseIntercept {
  NoActionIntercept(BaseFuntion baseFuntion, {bool isDefaultFailure = true}) {
    this.baseFuntion = baseFuntion;
    this.isDefaultFailure = isDefaultFailure;
  }
  @override
  void afterRequest() {}

  @override
  void beforeRequest() {}
}
