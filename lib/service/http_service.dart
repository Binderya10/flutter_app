import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/utilities/globals.dart';
import 'package:http/http.dart';

class Services {
  Future<Response> postRequest(String apiName, Object body) async {
    Response response = await post(
      Uri.https(Globals().domain, apiName),
      body: body,
      headers: {"ContentType": "application/json; charset=UTF-8"},
    );
    // var client =new  HttpClient();
    // var request =await client.post(Globals().domainHost, Globals().port, apiName);
    // request.headers.set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    // request.write(body);
    //
    // var response = request.close();
    return response;
  }

  Future<Response> getRequest(String apiName, Map<String, String> query) async {
    Response response = await get(
      Uri.https(Globals().domain, apiName, query),
      headers: {"ContentType": "application/json; charset=UTF-8"},
    );
    // var client = new HttpClient();
    // var request =
    //     await client.get(Globals().domainHost, Globals().port, apiName + query);
    // request.headers
    //     .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    //
    // var response = request.close();
    return response;
  }
}
