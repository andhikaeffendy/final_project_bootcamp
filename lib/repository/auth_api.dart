import 'dart:io';

import 'package:dio/dio.dart';
import 'package:final_project_bootcamp/constant/api_url.dart';
import 'package:final_project_bootcamp/helpers/users_email.dart';
import 'package:final_project_bootcamp/models/network_response.dart';

class AuthApi {
  Dio dioApi() {
    BaseOptions option = BaseOptions(
        baseUrl: ApiUrl.baseUrl,
        headers: {
          "x-api-key": ApiUrl.apiKey,
          HttpHeaders.contentTypeHeader: "application/json"
        },
        responseType: ResponseType.json);

    final dio = Dio(option);
    return dio;
  }

  Future<NetworkResponse> _getRequest({endpoint, param}) async {
    try {
      final dio = dioApi();
      final result = await dio.get(endpoint, queryParameters: param);
      return NetworkResponse.succes(result.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.sendTimeout) {
        return NetworkResponse.error(data: null, message: "request timeout");
      }
      return NetworkResponse.error(data: null, message: "request error dio");
    } catch (e) {
      return NetworkResponse.error(data: null, message: "other error");
    }
  }

  Future<NetworkResponse> _postRequest({endpoint, body}) async {
    try {
      final dio = dioApi();
      final result = await dio.post(endpoint, data: body);
      return NetworkResponse.succes(result.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.sendTimeout) {
        return NetworkResponse.error(data: null, message: "request timeout");
      }
      return NetworkResponse.error(data: null, message: "request error dio");
    } catch (e) {
      return NetworkResponse.error(data: null, message: "other error");
    }
  }

  Future<NetworkResponse> getUserByEmail() async {
    final result = await _getRequest(
      endpoint: ApiUrl.users,
      param: {
        "email": UserEmail.getUserEmail(),
      },
    );

    return result;
  }

  Future<NetworkResponse> postRegister(body) async {
    final result = await _postRequest(
      endpoint: ApiUrl.userRegistrasi,
      body: body,
    );

    return result;
  }

  Future<NetworkResponse> postUpdateUser(body) async {
    final result = await _postRequest(
      endpoint: ApiUrl.userUpdateProfile,
      body: body,
    );

    return result;
  }
}
