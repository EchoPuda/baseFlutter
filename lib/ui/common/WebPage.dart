import 'package:baseflutter/base/common/commonInsert.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

/// webview 调用方式 https://www.jianshu.com/p/17287c204c55
class WebPage extends BaseWidget {
  static const String EXAMPLE = "/example";

  WebPage({
    Key key,
    this.url,
  }) : super(key: key);
  final String url;

  @override
  BaseWidgetState<BaseWidget> getState() => new WebPageState();

}

class WebPageState extends BaseWidgetState<WebPage> {
  InAppWebView inAppWebView;

  /// 可控制与H5的交互
  InAppWebViewController webView;

  String url;

  @override
  Widget buildWidget(BuildContext context) {
    // TODO: implement buildWidget

    return getWebWidget();
  }

  @override
  void clickAppBarBack() {
    // TODO: implement clickAppBarBack

    if (this.webView != null) {
      webView.canGoBack().then((value) {
        if (value) {
          webView.goBack();
        } else {
          super.clickAppBarBack();
        }
      }, onError: (err) {
        super.clickAppBarBack();
      });
    } else {
      super.clickAppBarBack();
    }
  }

  @override
  void onCreate() {
    // TODO: implement onCreate

    inAppWebView = InAppWebView(
      initialUrl: widget.url,
//        initialHeaders: ,
//    initialOptions: ,

      onWebViewCreated: (InAppWebViewController controller) {
        webView = controller;

        webView.addJavaScriptHandler('test', (args) {
          print("收到来自web的消息" + args.toString());
        });

        webView.addJavaScriptHandler('handlerFooWithArgs', (args) {
          print(args);
          return [args[0] + 5, !args[1], args[2][0], args[3]['foo']];
        });
      },
      onLoadStart: (InAppWebViewController controller, String url) {
        print("started $url");
        setLoadingWidgetVisible(true);
        setState(() {
          this.url = url;
        });
      },
      onLoadStop: (InAppWebViewController controller, String url) async {
        print("stopped $url");
        setLoadingWidgetVisible(false);
      },
      onProgressChanged: (InAppWebViewController controller, int progress) {
        setState(() {
          log("$progress");
        });
      },
      shouldOverrideUrlLoading:
          (InAppWebViewController controller, String url) {
        print("override $url");
        controller.loadUrl(url);
      },
      onLoadResource: (InAppWebViewController controller,
          WebResourceResponse response, WebResourceRequest request) {
        print("Started at: " +
            response.startTime.toString() +
            "ms ---> duration: " +
            response.duration.toString() +
            "ms " +
            response.url);
      },
      onConsoleMessage:
          (InAppWebViewController controller, ConsoleMessage consoleMessage) {
        print("""
              console output:
                sourceURL: ${consoleMessage.sourceURL}
                lineNumber: ${consoleMessage.lineNumber}
                message: ${consoleMessage.message}
                messageLevel: ${consoleMessage.messageLevel}
              """);
      },
    );
  }

  @override
  void onPause() {
    // TODO: implement onPause
  }

  @override
  void onResume() {
    // TODO: implement onResume
  }

  Future<bool> _onBackKeyDown() {
//    clickAppBarBack
    log("--点击返回--");
    clickAppBarBack();
  }

  Widget getWebWidget() {
    return WillPopScope(
      child: inAppWebView,
      onWillPop: _onBackKeyDown,
    );
  }
}