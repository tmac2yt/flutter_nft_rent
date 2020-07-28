import 'package:shared_preferences/shared_preferences.dart';

class DataUtils {
  static const String SP_PRIVATE_KEY = 'private_key';

//  {"access_token":"aa105aaf-ca4f-4458-822d-1ae6a1fa33f9","refresh_token":"daae8b80-3ca6-4514-a8ae-acb3a82c951c","uid":2006874,"token_type":"bearer","expires_in":510070}
  static Future<void> saveLoginInfo(Map<String, dynamic> map) async {
    if (map != null && map.isNotEmpty) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp..setString(SP_PRIVATE_KEY, map[SP_PRIVATE_KEY]);
    }
  }

  static Future<void> clearLoginInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp..setString(SP_PRIVATE_KEY, '');
  }

  static Future<bool> isLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String privateKey = sp.getString(SP_PRIVATE_KEY);
    return privateKey != null && privateKey.isNotEmpty;
  }

  static Future<String> getPrivateKey() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(SP_PRIVATE_KEY);
  }
}

enum ItemType {
  title_my_lessor_list,
  title_others_lessor_list,
  my_lessor_list,
  others_tenant_list
}
