import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_stripe_payments/data/network/preferences/preference_manager.dart';
import 'package:http/http.dart' as http;
import 'network_check.dart';
import 'network_constants.dart';

enum HttpMethod { GET, POST }

class NetworkProvider {
  NetworkProvider._internal();

  static NetworkProvider instance = new NetworkProvider._internal();

  factory NetworkProvider() => instance;

  NetworkCheck networkCheck = new NetworkCheck();

  Future<dynamic> request({
    String url,
    HttpMethod method,
    Map<dynamic, dynamic> body,
    Map<dynamic, String> headers,
    bool isContentTypeJson = false,
  }) async {
    final Map<dynamic, dynamic> mapNetworkApiStatus = HashMap();

    final bool isConnect = await networkCheck.check();
    if (isConnect) {
      final String userToken =
          await PreferenceManager.instance.getSecurityToken() ?? "";
      print("Auth Token = $userToken");

      print("Base URL :: ${NetworkAPI.BASE_URL + url}");

      try {
        Map<String, String> headers = {
          NetworkParams.USER_TOKEN: userToken.isNotEmpty ? userToken : "",
          'Content-Type': 'application/json'
        };
        String jsonBody = jsonEncode(body);
        print(jsonBody);
        final response = method == HttpMethod.GET
            ? await http.get(Uri.parse(NetworkAPI.BASE_URL + url),
                headers: headers)
            : await http.post(
                NetworkAPI.BASE_URL + url,
                body: jsonBody ?? {},
                headers: headers,
              );
        print(response);
        print("API Response status code = ${response.statusCode}");

        if (response.statusCode >= 200 && response.statusCode < 400) {
          mapNetworkApiStatus[NetworkResponse.STATUS_CODE] =
              response.statusCode.toString();
          mapNetworkApiStatus[NetworkResponse.STATUS] = NetworkResponse.SUCCESS;
          mapNetworkApiStatus[NetworkResponse.DATA] = response.body.toString();
        } else {
          mapNetworkApiStatus[NetworkResponse.STATUS_CODE] =
              response.statusCode.toString();
          mapNetworkApiStatus[NetworkResponse.STATUS] = NetworkResponse.FAILURE;
          mapNetworkApiStatus[NetworkResponse.DATA] = response.body.toString();
        }
        return mapNetworkApiStatus;
      } catch (error) {
        mapNetworkApiStatus[NetworkResponse.STATUS_CODE] = "-1";
        mapNetworkApiStatus[NetworkResponse.STATUS] = NetworkResponse.EXCEPTION;
        mapNetworkApiStatus[NetworkResponse.DATA] = error.toString();
        return mapNetworkApiStatus;
      }
    } else {
      mapNetworkApiStatus[NetworkResponse.STATUS_CODE] = "0";
      mapNetworkApiStatus[NetworkResponse.STATUS] = NetworkResponse.NO_INTERNET;
      mapNetworkApiStatus[NetworkResponse.DATA] = "Internect not connected";
      return mapNetworkApiStatus;
    }
  }

  Future<dynamic> requestMultipart(
      {String url,
      HttpMethod method,
      Map<dynamic, String> headers,
      Map<dynamic, String> body,
      String imageKey,
      File imageValue}) async {
    final Map<dynamic, dynamic> mapNetworkApiStatus = HashMap();

    final bool isConnect = await networkCheck.check();
    if (isConnect) {
      print("Base URL :: ${NetworkAPI.BASE_URL + url}");
      print("Body :: $body");

      try {
        var uri = Uri.parse(NetworkAPI.BASE_URL + url);
        var request = http.MultipartRequest('POST', uri);

        body.forEach((key, value) {
          request.fields[key] = value;
        });

        if (imageValue != null) {
          print("Body profilePic :: ${imageValue.path}");

          http.MultipartFile multipartFile =
              await http.MultipartFile.fromPath(imageKey, imageValue.path);
          request.files.add(multipartFile);
        }

        final String authToken =
            await PreferenceManager.instance.getSecurityToken() ?? "";
        print("Auth Token = $authToken");

        request.headers[NetworkParams.USER_TOKEN] =
            authToken.isNotEmpty ? authToken : "";

        var response = await request.send();

        var responseHttp = await http.Response.fromStream(response);

        print("response reasonPhrase = ${response.reasonPhrase}");
        print("response Data = ${response.statusCode}");
        print("response responseHttp body = ${responseHttp.body}");

        if (response.statusCode == 200) {
          mapNetworkApiStatus[NetworkResponse.STATUS_CODE] =
              response.statusCode.toString();
          mapNetworkApiStatus[NetworkResponse.STATUS] = NetworkResponse.SUCCESS;
          mapNetworkApiStatus[NetworkResponse.DATA] =
              responseHttp.body.toString();
        } else {
          mapNetworkApiStatus[NetworkResponse.STATUS_CODE] =
              response.statusCode.toString();
          mapNetworkApiStatus[NetworkResponse.STATUS] = NetworkResponse.FAILURE;
          mapNetworkApiStatus[NetworkResponse.DATA] =
              responseHttp.body.toString();
        }

        return mapNetworkApiStatus;
      } catch (error) {
        mapNetworkApiStatus[NetworkResponse.STATUS_CODE] = "-1";
        mapNetworkApiStatus[NetworkResponse.STATUS] = NetworkResponse.EXCEPTION;
        mapNetworkApiStatus[NetworkResponse.DATA] = error.toString();
        return mapNetworkApiStatus;
      }
    } else {
      mapNetworkApiStatus[NetworkResponse.STATUS_CODE] = "0";
      mapNetworkApiStatus[NetworkResponse.STATUS] = NetworkResponse.NO_INTERNET;
      mapNetworkApiStatus[NetworkResponse.DATA] = "Internect not connected";
      return mapNetworkApiStatus;
    }
  }
}
