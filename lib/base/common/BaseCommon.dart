
import 'dart:io';

import 'package:baseflutter/utils/LocalImageSelecter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:path_provider/path_provider.dart';

/// 基础方法
/// @author jm
class BaseCommon {
  ///图片导入头
  static const String ImagePath = "assets/images/";

  ///获取图片地址，默认images下的.png
  static String getImage(String image,{String type}) {
    return ImagePath + image + type ?? ".png";
  }

  ///打开新页面
  static openPage(BuildContext context, Widget widget) {
    return Navigator.push(context, new MaterialPageRoute(builder: (context) => widget));
  }

  ///打开新页面(用页名)
  static openPageWithName(BuildContext context, String widget) {
    return Navigator.pushNamed(context, widget);
  }

  ///打开新页面代替旧页面
  static openPageReplacement(BuildContext context, Widget widget) {
    return Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => widget));
  }

  ///打开新页面代替旧页面(用页名)
  static openPageReplacementWithName(BuildContext context, widget) {
    return Navigator.pushReplacementNamed(context, widget);
  }

  ///关闭页面知道route
  static closeUntil(BuildContext context, {String route}) {
    return Navigator.popUntil(context, route == null ? (route) => route == null : ModalRoute.withName(route));
  }

  ///关闭所有页面(或直到某页面)并打开该页面
  ///可以修改默认[route],比如到Main
  static closeAllAndOpenPage(BuildContext context, Widget widget,{String route}) {
    return Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context) => widget), route == null ? (route) => route == null : ModalRoute.withName(route));
  }

  ///关闭页面
  static closePage(BuildContext context, {dynamic msg}) {
    msg == null ? Navigator.of(context).pop() : Navigator.of(context).pop(msg);
  }

  /// 网络图片
  static Widget netImage(String headImg, double width, double height,) {
    // TODO error, loading 需修改
    return headImg.length > 7 && headImg.substring(0,7) == "http://" ? CachedNetworkImage(
      placeholder: (context, url) => SizedBox(width: width * 0.5,height: width * 0.5,child: LoadingIndicator(indicatorType: Indicator.ballSpinFadeLoader,color: Colors.grey,),),
      errorWidget: (context, url, error) => Icon(Icons.error_outline),
      imageUrl: headImg,
      width: width,
      height: height,
    ) : LocalImageSelector.getImage("touxiang_60",imageWidth: width);
  }

  ///加载缓存
  static Future<double> loadCache() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      double value = await _getTotalSizeOfFilesInDir(tempDir);
      /*tempDir.list(followLinks: false,recursive: true).listen((file){
          //打印每个缓存文件的路径
        print(file.path);
      });*/
      print('临时目录大小: ' + value.toString());
      return value;
    } catch (err) {
      print(err);
      return 0.0;
    }
  }

  /// 递归方式 计算文件的大小
  static Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
        int length = await file.length();
        return double.parse(length.toString());
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        double total = 0;
        if (children != null)
          for (final FileSystemEntity child in children)
            total += await _getTotalSizeOfFilesInDir(child);
        return total;
      }
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }
}