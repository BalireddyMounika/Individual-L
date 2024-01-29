import 'package:dio/dio.dart';
import 'package:life_eazy/net/base_url.dart';

class ApiServiceConfig {
  static ApiServiceConfig? _instance;
  Dio? _dio;
  static final Map<String, ApiServiceConfig> _cache =
      <String, ApiServiceConfig>{};
  Dio get dio => _dio!;
  Map<String, dynamic> map = new Map();
  factory ApiServiceConfig() {
    _instance ??= ApiServiceConfig._internal();
    return _instance!;
  }

  Dio createDio() {
    map["accept"] = "application/json";
    map["Authorization"] = stageHeader;
    //map["Authorization"] = productionHeadr;
    var dio = Dio(BaseOptions(
        connectTimeout: 100000,
        receiveTimeout: 1000000,
        headers: map,
        baseUrl: stage_url
        // baseUrl: production_url
        ));

    return dio;
  }

  ApiServiceConfig._internal() {
    _dio = createDio();
  }
}
