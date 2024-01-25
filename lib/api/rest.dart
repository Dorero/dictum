import 'package:dio/dio.dart';

class Rest {
  static final Rest _rest = Rest._();

  final dio = Dio(
      BaseOptions(
          baseUrl: "https://api.fisenko.net/v1/"
      )
  );

  Rest._();

  factory Rest() {
    return _rest;
  }


  Future<dynamic> get(String url) async {
    final response = await dio.get(url);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("Network request finished failed");
    }
  }
}
