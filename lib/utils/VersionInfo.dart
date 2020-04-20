import 'package:get_version/get_version.dart';

/// 版本管理
/// @author puppet
class VersionInfo {
  static String versionCode;

  static Future<bool> getInstance() async {
    versionCode = await GetVersion.projectVersion;
    print("version:" + versionCode);
    return true;
  }

  static get deviceCode {
    return versionCode;
  }
}