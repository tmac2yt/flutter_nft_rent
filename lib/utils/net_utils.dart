import 'package:http/http.dart' as http;

class NetUtils {
  static Future get(String url, Map<String, dynamic> params) async {
    if (url != null && params != null && params.isNotEmpty) {
      //拼接参数
      StringBuffer sb = new StringBuffer("?");
      params.forEach((key, value) {
        sb.write('$key=$value&');
      });
      String paramStr = sb.toString().substring(0, sb.length - 1);
      url += paramStr;
    }
    print('NetUtils:$url');
    http.Response response = await http.get(url);
    return response.body;
  }

  static Future post(String url, Map<String, dynamic> params) async {
    http.Response response = await http.post(url, body: params);
    return response.body;
  }
}
