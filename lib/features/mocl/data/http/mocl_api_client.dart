
import 'package:get/get.dart';

class ApiClient extends GetConnect {

  @override
  void onInit() {
    httpClient.baseUrl = 'https://api.example.com';
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 10);
    httpClient.userAgent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:126.0) Gecko/20100101 Firefox/126.0';
    super.onInit();
  }

  Future<Response> getUsers() => get('/users');

  Future<Response> createUser(Map data) => post('/users', data);
}