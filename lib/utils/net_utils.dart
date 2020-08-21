import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class NetUtils {
  static Dio dio = Dio();

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
    try {
      Response response = await dio.get(url);
      print(response);
      return response.data;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future post(String url, Map<String, dynamic> params) async {
    try {
      Response response = await dio.post(url, data: params);
      return response.data;
    }catch(e){
      print(e);
    }
    return null;
  }
}
