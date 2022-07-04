import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_color.dart';
import 'size_util.dart';

class ApiService extends GetConnect {
  static ApiService get me => Get.find<ApiService>();

  String _baseUrl = "http://fairydustbridal-api.grhadigital.id/";
  String get baseUrl => _baseUrl;
  Map<String, String> _headers = {"Accept": "application/json"};

  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = _baseUrl + "api/";
    httpClient.followRedirects = true;
    httpClient.maxAuthRetries = 0;
    httpClient.maxRedirects = 5;
    httpClient.timeout = const Duration(seconds: 8);
    httpClient.userAgent = "getx-client";
  }

  void attachToken(String token) =>
      _headers["Authorization"] = "Bearer " + token;
  void detachToken() => _headers.remove("Authorization");

  @override
  Future<Response<T>> post<T>(String? url, body,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query,
      Decoder<T>? decoder,
      Progress? uploadProgress}) async {
    print("Post.Url : $url");
    Response<T> response = await super.post(url, body,
        contentType: contentType,
        headers: _headers,
        query: query,
        decoder: decoder,
        uploadProgress: uploadProgress);
    if (validateStatusCode(response)) return response;
    return Response();
  }

  @override
  Future<Response<T>> get<T>(String url,
      {Map<String, String>? headers,
      String? contentType,
      Map<String, dynamic>? query,
      Decoder<T>? decoder}) async {
    print("Get.Url : $url");
    Response<T> response = await super.get(url,
        headers: _headers,
        contentType: contentType,
        query: query,
        decoder: decoder);
    if (validateStatusCode(response)) return response;
    return Response();
  }

  Future<Uint8List?> getUint8list<T>(String url,
      {Map<String, String>? headers,
      String? contentType,
      Map<String, dynamic>? query,
      Decoder<T>? decoder}) async {
    print("Get.Url : $url");

    Response<T> response = await super.get(url,
        headers: _headers,
        contentType: contentType,
        query: query,
        decoder: decoder);
    String? result = response.bodyString;
    print("RESULT" + result!);
    if (validateStatusCode(response))
      return Uint8List.fromList(utf8.encode(result));
    return null;
  }

  @override
  Future<Response<T>> put<T>(String? url, body,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query,
      Decoder<T>? decoder,
      Progress? uploadProgress}) async {
    print("Put.Url : $url");
    Response<T> response = await super.put(url!, body,
        contentType: contentType,
        headers: _headers,
        query: query,
        decoder: decoder,
        uploadProgress: uploadProgress);
    if (validateStatusCode(response)) return response;
    return Response();
  }

  @override
  Future<Response<T>> delete<T>(String? url,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query,
      Decoder<T>? decoder}) async {
    print("Delete.Url : $url");
    Response<T> response = await super.delete(url!,
        contentType: contentType,
        headers: _headers,
        query: query,
        decoder: decoder);
    if (validateStatusCode(response)) return response;
    return Response();
  }

  void showErrorSnackBar({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      messageText: Text(message, style: TextStyle(fontStyle: FontStyle.italic)),
      margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
      backgroundColor: AppColor.snackbarBackground,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  bool validateStatusCode(Response? response) {
    print("Response.StatusCode : ${response?.statusCode}");
    print("Response.Body : ${response?.body}");

    if (response == null) {
      showErrorSnackBar(
          title: "Oops.. Seems like there is a connection problem",
          message:
              "Check your internet connnection and please try again later.");
      return false;
    }

    if (response.statusCode == null || response.body == null) {
      showErrorSnackBar(
          title: "Oops.. Seems like there is a connection problem",
          message:
              "Check your internet connnection and please try again later.");
      return false;
    }

    int statusCode = response.statusCode!;
    String statusText = response.statusText!;

    if (statusCode == 401) {
      print("Current Route : " + Get.currentRoute);
      if (Get.currentRoute != "/splash") {
        if (Get.currentRoute != "/login") {
          Get.offAllNamed("/login");
          showErrorSnackBar(
              title: statusText,
              message: "Your session has expired! Please login again.");
          return false;
        }

        showErrorSnackBar(
            title: "Invalid ID/Password",
            message: "Please enter a valid combination of email/password.");
        return false;
      }
    }

    if (statusCode >= 400 && statusCode < 500) {
      try {
        showErrorSnackBar(
            title: "Oops...",
            message: response.body["data"]["description"][0] == ""
                ? "An error occurred, please try again later."
                : response.body["data"]["description"][0]);
      } catch (_) {
        showErrorSnackBar(
            title: "Oops...",
            message: response.body["message"] == ""
                ? "An error occurred, please try again later."
                : response.body["message"]);
      }
      return false;
    }

    if (statusCode == 200 || statusCode == 201) {
      return true;
    }

    showErrorSnackBar(
        title: "Oops.. Looks like something went wrong!",
        message: response.statusText!);
    return false;
  }
}
