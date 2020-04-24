
import 'package:permission_handler/permission_handler.dart';

/// 权限管理
/// @author puppet
class PermissionManager {

  static List<Permission> listPermission = new List();

  /// 请求权限
  static Future request() async {
    /// 检查权限
    if (await Permission.storage.isUndetermined){
      /// 添加权限
      listPermission.add(Permission.storage);
    }
//    if (await Permission.camera.isUndetermined) {
//      listPermission.add(Permission.camera);
//    }
//    if (await Permission.location.isUndetermined){
//      listPermission.add(Permission.location);
//    }
    if (listPermission.isNotEmpty) {
      Map<Permission, PermissionStatus> statuses = await listPermission.request();
      /// 请求结果
      print(statuses);
    }

  }

}