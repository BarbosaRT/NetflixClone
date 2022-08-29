import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

abstract class HttpInterface {
  Future<dynamic> get(String url);
}

class DioImpl implements HttpInterface {
  final Dio dio;

  DioImpl({required this.dio});

  @override
  Future<dynamic> get(String url) async {
    return (await dio.get(url)).data;
  }
}

class HttpImpl implements HttpInterface {
  final http.Client client;
  final Map<String, String> headers;

  HttpImpl({required this.client, required this.headers});

  @override
  Future<dynamic> get(String url) async {
    return await client.get(Uri.parse(url), headers: headers);
  }
}
